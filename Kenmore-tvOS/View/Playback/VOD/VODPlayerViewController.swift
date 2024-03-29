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

import AVKit
import SwiftDate
import Kenmore_Models
import Kenmore_Utilities
import Kenmore_DataStores
import Kenmore_Operations

protocol VODPlayerViewDelegate {
    func videoDidEnd(guid: String)
}

class VODPlayerViewController: BaseVideoPlayerViewController {
    private var progressStore: ProgressStore? {
        UserStoreImpl.instance.getProgressStore()
    }

    private let videoMetadataOperation = OperationManagerImpl.instance.videoMetadataOperation
    private let streamURLFactory = StreamURLFactoryImpl()
    private let closeEnoughToFinishToRestart = 0.95

    var vodDelegate: VODPlayerViewDelegate?

    var customMenu: UIMenu?
    var feedItem: AvailableFeedItem!
    var guid: String {
        feedItem.videoAttachments[0]
    }

    var videoMetadata: VideoMetadata?
    /// Initialize with default quality level
    lazy var selectedQualityLevel: QualityLevel? = AppSettings.instance.qualitySettings.toQualityLevel

    override func viewDidLoad() {
        super.viewDidLoad()
        speeds = PlaybackSpeed.allCases.map {
            AVPlaybackSpeed(rate: $0.value, localizedName: $0.readable)
        }
        Task {
            let request = VideoMetadataRequest(feedItem: feedItem, id: guid)
            let videoMetadataOpResponse = await videoMetadataOperation.get(request: request)
            if let videoMetadata = videoMetadataOpResponse.response {
                self.videoMetadata = videoMetadata
                self.setupMenu(videoMetadata: videoMetadata)
                self.startVideo(videoMetadata: videoMetadata)
            }
            else {
                showPlaybackError()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            let seconds = player.currentTime().seconds
            progressStore?.setProgress(for: guid, progress: seconds)
        }
        vodDelegate?.videoDidEnd(guid: guid)
    }

    override func progressUpdate(time: CMTime) {
        let seconds = time.seconds
        progressStore?.setProgress(for: guid, progress: seconds)
    }

    @objc func videoEnded() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    private func startVideo(videoMetadata: VideoMetadata) {
        let selectedQualityLevel = selectedQualityLevel ?? videoMetadata.levels[0]
        let url = streamURLFactory.create(deliveryKey: videoMetadata.deliveryKey, qualityLevel: selectedQualityLevel)
        let playerItem = AVPlayerItem(url: url)

        let progress = getStartTime(videoMetadata: videoMetadata)
        let player = getOrCreatePlayer(playerItem: playerItem)
        playerItem.seek(to: progress, completionHandler: { success in
            self.player!.play()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.videoEnded),
                name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                object: player.currentItem
            )
            if success {
                self.logger.debug("Started at position \(progress)")
            }
            else {
                self.logger.error("Tried to seek to position \(progress) but it failed. Will start from zero")
            }
        })

        player.updateItemMetadata(video: videoMetadata)
        logger.debug("Started playing video \(url)")
    }

    private func getOrCreatePlayer(playerItem: AVPlayerItem) -> AVPlayer {
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
            return player
        }
        else {
            let player = AVPlayer(playerItem: playerItem)
            self.player = player
            return player
        }
    }

    private func getStartTime(videoMetadata: VideoMetadata) -> CMTime {
        // Replacing video in progress with new stream.
        if let player = player {
            return player.currentTime()
        }
        // Starting video that was watched before and we have its progress
        else if let progressStore = progressStore,
                let savedProgress = progressStore.getProgress(for: guid) {
            let percent = savedProgress / Double(videoMetadata.duration)
            // Only continue from last position if you're not close enough to restart the video.
            if percent < closeEnoughToFinishToRestart {
                return CMTime(seconds: savedProgress, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            }
        }
        // Start from the beginning
        return .zero
    }
}

extension VODPlayerViewController {
    private func setupMenu(videoMetadata: VideoMetadata) {
        let selectedQualityLevel = selectedQualityLevel ?? videoMetadata.levels[0]
        let qualityMenu = UIMenu.getQualityMenu(
            selectedQualityLevel: selectedQualityLevel,
            videoMetadata: videoMetadata
        ) { option in
            guard self.selectedQualityLevel != option else {
                self.logger.debug("User selected same option as current. Returning early")
                return
            }
            DispatchQueue.main.async {
                self.selectedQualityLevel = option
                self.setupMenu(videoMetadata: videoMetadata)
                self.startVideo(videoMetadata: videoMetadata)
            }
        }
        customMenu = UIMenu(children: [qualityMenu])
        DispatchQueue.main.async {
            self.transportBarCustomMenuItems = self.customMenu?.children ?? []
            self.showsPlaybackControls = true
        }
    }
}

extension VODPlayerViewController {
    private func showPlaybackError() {
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        }
        let alert = UIAlertController(
            title: "Unable to start playback",
            message: "Something went wrong while trying to get the video. Please try again later",
            preferredStyle: .alert
        )
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
