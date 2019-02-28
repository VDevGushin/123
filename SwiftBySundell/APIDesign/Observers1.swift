//
//  Observers1.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 28/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Model for observe
fileprivate class AudioPlayer {
    private var observations = [ObjectIdentifier: Observation]()

    enum State {
        case idle
        case playing(Item)
        case paused(Item)
    }

    struct Item {
        let title: String
        let duration: String
    }

    private let notificationCenter: NotificationCenter

    private var state = State.idle {
        // We add a property observer on 'state', which lets us
        // run a function on each value change.
        didSet { stateDidChange() }
    }

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    func play(_ item: Item) {
        state = .playing(item)
        startPlayback(with: item)
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

    private func startPlayback(with: Item) { }
    private func stopPlayback() { }
    private func pausePlayback() { }
}

// MARK: - NotificationCenter
private extension AudioPlayer {
    func stateDidChange() {
        switch state {
        case .idle:
            notificationCenter.post(name: .playbackStopped, object: nil)
        case .playing(let item):
            notificationCenter.post(name: .playbackStarted, object: item)
        case .paused(let item):
            notificationCenter.post(name: .playbackPaused, object: item)
        }


        for (id, observation) in observations {
            // If the observer is no longer in memory, we
            // can clean up the observation for its ID
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            switch state {
            case .idle:
                observer.audioPlayerDidStop(self)
            case .playing(let item):
                observer.audioPlayer(self, didStartPlaying: item)
            case .paused(let item):
                observer.audioPlayer(self, didPausePlaybackOf: item)
            }
        }
    }
}

fileprivate extension Notification.Name {
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

// MARK: - Observation protocols
private extension AudioPlayer {
    struct Observation {
        weak var observer: AudioPlayerObserver?
    }

    func addObserver(_ observer: AudioPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AudioPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}

fileprivate protocol AudioPlayerObserver: class {
    func audioPlayer(_ player: AudioPlayer,
                     didStartPlaying item: AudioPlayer.Item)

    func audioPlayer(_ player: AudioPlayer,
                     didPausePlaybackOf item: AudioPlayer.Item)

    func audioPlayerDidStop(_ player: AudioPlayer)
}

// MARK: - View controller
fileprivate class NowPlayingViewController: UIViewController {
    deinit {
        notificationCenter?.removeObserver(self)
    }

    weak var titleLabel: UILabel?
    weak var durationLabel: UILabel?
    fileprivate var player: AudioPlayer = AudioPlayer()
    private var notificationCenter: NotificationCenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        //NotificationCenter
        notificationCenter?.addObserver(self,
                                        selector: #selector(playbackDidStart),
                                        name: .playbackStarted,
                                        object: nil)
        notificationCenter?.addObserver(self,
                                        selector: #selector(playbackDidPaused),
                                        name: .playbackPaused,
                                        object: nil)
        notificationCenter?.addObserver(self,
                                        selector: #selector(playbackDidStop),
                                        name: .playbackStopped,
                                        object: nil)


        //Observation
        player.addObserver(self)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.removeObserver(self)
    }

    //NotificationCenter
    @objc private func playbackDidStart(_ notification: Notification) {
        guard let item = notification.object as? AudioPlayer.Item else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }

        titleLabel?.text = item.title
        durationLabel?.text = item.duration
    }

    @objc private func playbackDidPaused(_ notification: Notification) {
        guard let item = notification.object as? AudioPlayer.Item else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }

        titleLabel?.text = item.title
        durationLabel?.text = item.duration
    }

    @objc private func playbackDidStop(_ notification: Notification) {
        guard let item = notification.object as? AudioPlayer.Item else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            return
        }

        titleLabel?.text = item.title
        durationLabel?.text = item.duration
    }
}

////Observation
extension NowPlayingViewController: AudioPlayerObserver {
    func audioPlayer(_ player: AudioPlayer,
                     didStartPlaying item: AudioPlayer.Item) { }

    func audioPlayer(_ player: AudioPlayer,
                     didPausePlaybackOf item: AudioPlayer.Item) { }

    func audioPlayerDidStop(_ player: AudioPlayer) { }
}
