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

public struct StreamUrl {
    public let url: URL
    
    public init(deliveryKey: DeliveryKey, qualityLevel: QualityLevel) {
        // If none provided, use the last (highest quality)
        let resourceData = deliveryKey.resource.data
        let qualityLevelName = DeliveryKeyQualityLevel.fromReadable(readable: qualityLevel.label)
        let qualityLevel = resourceData.getResource(qualitylevelName: qualityLevelName) ?? resourceData.lowestQuality()

        let fileName = qualityLevel.fileName
        let token = qualityLevel.accessToken
        let cdn = deliveryKey.cdn
        let fileNameKey = QualityLevelParams.Constants.FileNameKey
        let accessTokenKey = QualityLevelParams.Constants.AccessTokenKey
        let path = deliveryKey.resource.uri
            .replacing(fileNameKey, with: fileName)
            .replacing(accessTokenKey, with: token)
        
        let video = "\(cdn)\(path)"
        url = URL(string: video)!
    }
    
    public init(deliveryKey: DeliveryKey) {
        let cdn = deliveryKey.cdn
        let path = deliveryKey.resource.uri
        let video = "\(cdn)\(path)"
        url = URL(string: video)!
    }
}