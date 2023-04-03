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
import FloatplaneApp_Utilities
import FloatplaneApp_DataStores

/// Attemps a Logout. Clears all caches after successful logout.
public class LogoutOperation {
    private let logger = Log4S()
    
    var baseUrl: URL = URL(string: "\(OperationConstants.domainBaseUrl)/api/v2/auth/logout")!
    // Used to simulate iOS so we don't need captcha
    private let userAgent = "floatplane/59 CFNetwork/1404.0.5 Darwin/22.3.0"
    private let headers: HTTPHeaders
    
    init() {
        let headerMap = [
            "user-agent" : userAgent
        ]
        headers = HTTPHeaders(headerMap)
    }
    
    /// Performs a logout and then clears all caches upon success.
    /// TODO: Investigate if we should clear the cache even if the call fails.
    public func get(completion: ((Error?) -> Void)? = nil) {
        AF.request(baseUrl, method: .post, headers: headers).response() { response in
            if response.response?.statusCode == 200 {
                UserStore.instance.removeUser()
                OperationManager.instance.cancelAllOperations()
                OperationManager.instance.clearCache()
                URLCache.shared.removeAllCachedResponses()
                self.logger.info("Successfully logged out")
                completion?(nil)
            }
            else {
                completion?(response.error)
            }
        }
    }
}
