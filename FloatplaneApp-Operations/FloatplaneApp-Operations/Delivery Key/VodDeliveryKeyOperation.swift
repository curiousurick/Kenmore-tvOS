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

/// Gets a delivery key for a given video GUID. This delivery key is used to generate a stream URL for an m3u8 (as of 4/3/2023) stream.
/// This is not a cached API call because we should only retrieve it when starting a video and I think it's generated on demand.
public class VodDeliveryKeyOperation {
    private let baseUrl: URL = URL(string: "\(OperationConstants.domainBaseUrl)/api/v2/cdn/delivery")!
    
    /// Gets a DeliveryKey for a given video GUID
    public func get(request: VodDeliveryKeyRequest, completion: ((DeliveryKey?, Error?) -> Void)? = nil) {
        AF.request(baseUrl, parameters: request.params).responseDecodable(of: DeliveryKey.self) { response in
            completion?(response.value!, nil)
        }
    }
}
