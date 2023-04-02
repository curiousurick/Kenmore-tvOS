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

public class CreatorOperation: CacheableAPIOperation<CreatorRequest, Creator> {
    
    static let base = URL(string: "\(OperationConstants.domainBaseUrl)/api/v2/creator/named")!
    
    init() {
        super.init(baseUrl: CreatorOperation.base)
    }
    
    override func _get(request: CreatorRequest, completion: ((Creator?, Error?) -> Void)? = nil) -> DataRequest {
        return AF.request(baseUrl, parameters: request.params).responseDecodable(of: [Creator].self) { response in
            if let creators = response.value,
               creators.count == 1 {
                completion?(creators[0], nil)
            }
            else {
                completion?(nil, response.error)
            }
        }
    }
}