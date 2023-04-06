//  Copyright © 2023 George Urick
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import Alamofire
import FloatplaneApp_Models

protocol LoginOperationStrategy: InternalOperationStrategy<LoginRequest, LoginResponse> { }

/// Attempts to login the user to Floatplane. Takes a username and password and relies on cookies to maintain access to user-level APIs.
class LoginOperationStrategyImpl: LoginOperationStrategy {
    
    private let baseUrl: URL = URL(string: "\(OperationConstants.domainBaseUrl)/api/v2/auth/login")!
    // Used to simulate iOS so we don't need captcha
    private let userAgent = "floatplane/59 CFNetwork/1404.0.5 Darwin/22.3.0"
    private let headers: HTTPHeaders
    
    var dataRequest: DataRequest?
    var session: Session
    
    init(session: Session) {
        let headerMap = [
            "user-agent" : userAgent
        ]
        headers = HTTPHeaders(headerMap)
        self.session = session
    }
    
    /// Attempts a login. If login fails, it returns a LoginFailedResponse containing the reason for failure, which also includes a clear message on the failure.
    func get(request: LoginRequest) async -> OperationResponse<LoginResponse> {
        let dataRequest = session.request(baseUrl, method: .post, parameters: request, headers: headers)
        self.dataRequest = dataRequest
        return await withCheckedContinuation { continuation in
            dataRequest.response { response in
                // Login successful
                if let data = response.data,
                    let loginSuccessResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    continuation.resume(returning: OperationResponse(response: loginSuccessResponse, error: nil))
                }
                // Failure response from server.
                else if let data = response.data,
                        let loginFailedResponse = try? JSONDecoder().decode(LoginFailedResponse.self, from: data) {
                    let error = LoginFailedError.error(response: loginFailedResponse)
                    continuation.resume(returning: OperationResponse(response: nil, error: error))
                }
                // Generic HTTP Failure
                else if let httpError = response.error {
                    let failedResponse = LoginFailedResponse(errors: [], message: httpError.localizedDescription)
                    let error = LoginFailedError.error(response: failedResponse)
                    continuation.resume(returning: OperationResponse(response: nil, error: error))
                }
            }
        }
    }
}