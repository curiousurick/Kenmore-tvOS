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

class SubscriptionOperation: CacheableAPIOperation<SubscriptionRequest, SubscriptionResponse> {
    
    typealias Request = SubscriptionRequest
    typealias Response = SubscriptionResponse
    
    static let baseUrl = URL(string: "https://\(OperationConstants.domain)/api/v3/user/subscriptions")!
    
    init() {
        super.init(baseUrl: SubscriptionOperation.baseUrl)
    }
    
    override func _get(request: SubscriptionRequest, completion: ((SubscriptionResponse?, Error?) -> Void)?) -> DataRequest {
        return AF.request(baseUrl).responseDecodable(of: [Subscription].self) { response in
            if let subscriptions = response.value {
                completion?(SubscriptionResponse(subscriptions: subscriptions), nil)
            }
            else {
                completion?(nil, response.error)
            }
        }
    }
}
