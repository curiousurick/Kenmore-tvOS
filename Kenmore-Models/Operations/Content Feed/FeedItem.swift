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

/// Contains the info needed to display an item in the browse feed or search results.
public struct FeedItem: Hashable, Codable, Equatable {
    public let availableItem: AvailableFeedItem?
    public let lockedItem: LockedFeedItem?

    public init(availableItem: AvailableFeedItem) {
        self.availableItem = availableItem
        lockedItem = nil
    }

    public init(lockedItem: LockedFeedItem) {
        self.lockedItem = lockedItem
        availableItem = nil
    }

    public init(from decoder: Decoder) throws {
        if let available = try? decoder.container(keyedBy: AvailableFeedItem.CodingKeys.self),
           let _ = try? available.decode(Channel.self, forKey: AvailableFeedItem.CodingKeys.channel) {
            try self.init(availableItem: AvailableFeedItem(from: decoder))
        }
        else {
            try self.init(lockedItem: LockedFeedItem(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let availableItem = availableItem {
            try container.encode(availableItem)
        }
        else if let lockedItem = lockedItem {
            try container.encode(lockedItem)
        }
    }
}

public struct AvailableFeedItem: Hashable, Codable, Equatable {
    public let attachmentOrder: [String]
    public let audioAttachments: [String]
    public let channel: Channel
    public let comments: UInt64
    public let creator: ContentCreator
    public let dislikes: UInt64
    public let galleryAttachments: [String]
    public let guid: String
    public let id: String
    public var isAccessible: Bool? = true
    public let likes: UInt64
    public let metadata: Metadata
    public let pictureAttachments: [String]
    public let releaseDate: Date
    public let score: UInt64
    public let tags: [String]
    public let text: String
    public let thumbnail: Icon
    public let title: String
    public let type: VideoType
    public let videoAttachments: [String]
    public let wasReleasedSilently: Bool

    enum CodingKeys: CodingKey {
        case attachmentOrder
        case audioAttachments
        case channel
        case comments
        case creator
        case dislikes
        case galleryAttachments
        case guid
        case id
        case isAccessible
        case likes
        case metadata
        case pictureAttachments
        case releaseDate
        case score
        case tags
        case text
        case thumbnail
        case title
        case type
        case videoAttachments
        case wasReleasedSilently
    }

    public init(
        attachmentOrder: [String], audioAttachments: [String], channel: Channel,
        comments: UInt64, creator: ContentCreator, dislikes: UInt64,
        galleryAttachments: [String], guid: String, id: String, isAccessible: Bool? = nil,
        likes: UInt64, metadata: Metadata, pictureAttachments: [String], releaseDate: Date,
        score: UInt64, tags: [String], text: String, thumbnail: Icon, title: String,
        type: VideoType, videoAttachments: [String], wasReleasedSilently: Bool
    ) {
        self.attachmentOrder = attachmentOrder
        self.audioAttachments = audioAttachments
        self.channel = channel
        self.comments = comments
        self.creator = creator
        self.dislikes = dislikes
        self.galleryAttachments = galleryAttachments
        self.guid = guid
        self.id = id
        self.isAccessible = isAccessible
        self.likes = likes
        self.metadata = metadata
        self.pictureAttachments = pictureAttachments
        self.releaseDate = releaseDate
        self.score = score
        self.tags = tags
        self.text = text
        self.thumbnail = thumbnail
        self.title = title
        self.type = type
        self.videoAttachments = videoAttachments
        self.wasReleasedSilently = wasReleasedSilently
    }
}

public struct LockedFeedItem: Codable, Equatable, Hashable {
    public let attachmentOrder: [String]
    public let channel: String
    public let comments: UInt64
    public let creator: ContentCreator
    public let dislikes: UInt64
    public let galleryAttachments: [String]
    public let guid: String
    public let id: String
    public var isAccessible: Bool? = true
    public let likes: UInt64
    public let metadata: Metadata
    public let releaseDate: Date
    public let score: UInt64
    public let tags: [String]
    public let text: String
    public let thumbnail: Icon
    public let title: String
    public let type: VideoType
    public let wasReleasedSilently: Bool

    enum CodingKeys: CodingKey {
        case attachmentOrder
        case channel
        case comments
        case creator
        case dislikes
        case galleryAttachments
        case guid
        case id
        case isAccessible
        case likes
        case metadata
        case releaseDate
        case score
        case tags
        case text
        case thumbnail
        case title
        case type
        case wasReleasedSilently
    }

    public init(
        attachmentOrder: [String], channel: String,
        comments: UInt64, creator: ContentCreator, dislikes: UInt64,
        galleryAttachments: [String], guid: String, id: String, isAccessible: Bool? = nil,
        likes: UInt64, metadata: Metadata, releaseDate: Date,
        score: UInt64, tags: [String], text: String, thumbnail: Icon, title: String,
        type: VideoType, wasReleasedSilently: Bool
    ) {
        self.attachmentOrder = attachmentOrder
        self.channel = channel
        self.comments = comments
        self.creator = creator
        self.dislikes = dislikes
        self.galleryAttachments = galleryAttachments
        self.guid = guid
        self.id = id
        self.isAccessible = isAccessible
        self.likes = likes
        self.metadata = metadata
        self.releaseDate = releaseDate
        self.score = score
        self.tags = tags
        self.text = text
        self.thumbnail = thumbnail
        self.title = title
        self.type = type
        self.wasReleasedSilently = wasReleasedSilently
    }
}
