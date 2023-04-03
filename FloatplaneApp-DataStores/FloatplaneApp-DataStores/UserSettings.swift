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
import FloatplaneApp_Models

/// Basic user settings access. Use this for non-restricted data.
/// Currently used for default quality level settings. Do not put personal or private data here.
public class UserSettings {
    
    private let QualitySettingsKey = "com.georgie.floatplane.QualitySettings"
    /// Data is stored in UserDefaults
    private let userDefaults = UserDefaults.standard
    
    /// Singleton access to UserSettings
    public static let instance = UserSettings()
    
    private init() { }
    
    /// This is used as the default quality level settings when starting a new video.
    /// If never selected, the default value is returned of 720p.
    public var qualitySettings: DeliveryKeyQualityLevel {
        get {
            // Found in userDefault
            if let savedValue = userDefaults.string(forKey: QualitySettingsKey),
               let quality = DeliveryKeyQualityLevel(rawValue: savedValue) {
                return quality
            }
            // First time use default
            return DeliveryKeyQualityLevel.defaultLevel
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: QualitySettingsKey)
        }
    }
    
    
}
