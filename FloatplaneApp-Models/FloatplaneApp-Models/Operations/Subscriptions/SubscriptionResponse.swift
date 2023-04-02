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

public struct Subscription: Codable, Equatable {
    public struct Plan: Codable, Equatable {
        public let allowGrandfatheredAccess: Bool
        public let currency: String
        public let description: String
        public let discordRoles: [String]
        public let discordServers: [String]
        public let featured: Bool
        public let id: String
        public let interval: Interval
        public let logo: Icon?
        public let price: String
        public let priceYearly: String
        public let title: String
    }
    
    public enum Interval: String, Codable, Equatable {
        case month
        case year
    }
    
    public let creator: String
    public let endDate: Date
    public let interval: Interval
    public let paymentCancelled: Bool
    public let paymentID: Int
    public let plan: Plan
    public let startDate: Date
    
}

public struct SubscriptionResponse: Codable {
    
    public let subscriptions: [Subscription]
    
    public init(subscriptions: [Subscription]) {
        self.subscriptions = subscriptions
    }
    
}
