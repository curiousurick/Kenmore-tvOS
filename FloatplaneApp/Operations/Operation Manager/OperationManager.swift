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

protocol CacheableOperation {
    func cancel()
    func clearCache()
}

extension CacheableAPIOperation: CacheableOperation {
    
}

class OperationManager {
    static let instance = OperationManager()

    // Cacheable Operations
    let contentFeedOperation = ContentFeedOperation()
    let subscriptionOperation = SubscriptionOperation()
    let searchOperation = SearchOperation()
    let creatorListOperation = CreatorListOperation()
    let creatorOperation = CreatorOperation()
    let contentVideoOperation = ContentVideoOperation()
    
    let allCacheableOperations: [CacheableOperation]
    
    // Non-cached Operations
    let vodDeliveryKeyOperation = VodDeliveryKeyOperation()
    let liveDeliveryKeyOperation = LiveDeliveryKeyOperation()
    let loginOperation = LoginOperation()
    let logoutOperation = LogoutOperation()
    let videoMetadataOperation = VideoMetadataOperation()
    
    private init() {
        allCacheableOperations = [
            contentFeedOperation,
            subscriptionOperation,
            searchOperation,
            creatorListOperation,
            creatorOperation,
            contentVideoOperation
        ]
    }
    
    func clearCache() {
        allCacheableOperations.forEach {
            $0.cancel()
            $0.clearCache()
        }
    }
}
