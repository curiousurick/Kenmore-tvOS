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

struct QualityLevel: Codable, Equatable {
    let name: String
    let width: UInt
    let height: UInt
    let label: String
    let order: UInt
    
    var resolution: CGSize {
        get {
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }
    }
    
    struct Standard {
        private init() { }
        static let ql360p = QualityLevel(name: "360", width: 640, height: 360, label: "360p", order: 0)
        static let ql480p = QualityLevel(name: "480", width: 848, height: 478, label: "480p", order: 1)
        static let ql720p = QualityLevel(name: "720", width: 1280, height: 720, label: "720p", order: 2)
        static let ql1080p = QualityLevel(name: "1080", width: 1920, height: 1080, label: "1080p", order: 3)
    }
}
