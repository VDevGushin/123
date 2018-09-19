//
//  Observers+NotificationCenter.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//NOTIFICATION CENTER
extension Notification.Name {
    static var playbackStarted: Notification.Name {
        return .init(rawValue: "AudioPlayer.playbackStarted")
    }

    static var playbackPaused: Notification.Name {
        return .init(rawValue: "AudioPlayer.playbackPaused")
    }

    static var playbackStopped: Notification.Name {
        return .init(rawValue: "AudioPlayer.playbackStopped")
    }
}

class AudioPlayerNotificationCenter {
    class Item { }
    private let notificationCenter: NotificationCenter
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    private var state = State.idle {
        didSet {
            stateDidChange()
        }
    }

    func play(_ item: Item) {
        self.state = .playing(item)
        startPlayBack(with: item)
    }

    func pause() {
        switch state {
        case .idle, .paused:
            // Calling pause when we're not in a playing state
            // could be considered a programming error, but since
            // it doesn't do any harm, we simply break here.
            break
        case .playing(let item):
            state = .paused(item)
            pausePlayback()
        }
    }

    func stop() {
        state = .idle
        stopPlayback()
    }

    func stopPlayback() { }
    func pausePlayback() { }
    func startPlayBack(with: Item) { }
    func stateDidChange() {
        switch self.state {
        case .idle:
            notificationCenter.post(name: .playbackStopped, object: nil)
        case .playing(let item):
            notificationCenter.post(name: .playbackStarted, object: item)
        case .paused(let item):
            notificationCenter.post(name: .playbackPaused, object: item)
        }
    }
}

private extension AudioPlayerNotificationCenter {
    enum State {
        case idle
        case playing(Item)
        case paused(Item)
    }
}

//How to use
private class TestNotificationCenterVC: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(playbackDidStart),
                                       name: .playbackStarted,
                                       object: nil
        )
    }

    @objc private func playbackDidStart(_ notification: Notification) {
        guard let item = notification.object as? AudioPlayerNotificationCenter.Item else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }
    }
}
