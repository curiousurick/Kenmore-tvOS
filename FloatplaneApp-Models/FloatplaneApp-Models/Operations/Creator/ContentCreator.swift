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

/// The creator object which is present in a FeedItem.
public struct ContentCreator: Hashable, Codable, Equatable {
    public let about: String
    public let card: Icon
    public let category: Category?
    public let channels: [String]
    public let cover: Icon
    public let defaultChannel: String
    public let description: String
    public let discoverable: Bool
    public let icon: Icon
    public let id: String
    public let incomeDisplay: Bool
    public let liveStream: LiveStream
    public let owner: Owner
    public let subscriberCountDisplay: String
    public let subscriptionPlans: [Subscription.Plan]
    public let title: String
    public let urlname: String
    
    public init(
        about: String, card: Icon, category: Category?, channels: [String],
        cover: Icon, defaultChannel: String, description: String, discoverable: Bool,
        icon: Icon, id: String, incomeDisplay: Bool, liveStream: LiveStream, owner: Owner,
        subscriberCountDisplay: String, subscriptionPlans: [Subscription.Plan],
        title: String, urlname: String
    ) {
        self.about = about
        self.card = card
        self.category = category
        self.channels = channels
        self.cover = cover
        self.defaultChannel = defaultChannel
        self.description = description
        self.discoverable = discoverable
        self.icon = icon
        self.id = id
        self.incomeDisplay = incomeDisplay
        self.liveStream = liveStream
        self.owner = owner
        self.subscriberCountDisplay = subscriberCountDisplay
        self.subscriptionPlans = subscriptionPlans
        self.title = title
        self.urlname = urlname
    }
}
