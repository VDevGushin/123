//
//  Observers+Protocols.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol AudioPlayerObserver: class {
    func audioPlayer(_ player: AudioPlayerProtocol,
                     didStartPlaying item: AudioPlayerProtocol.Item)

    func audioPlayer(_ player: AudioPlayerProtocol,
                     didPausePlaybackOf item: AudioPlayerProtocol.Item)

    func audioPlayerDidStop(_ player: AudioPlayerProtocol)
}

extension AudioPlayerObserver {
    func audioPlayer(_ player: AudioPlayerProtocol,
                     didStartPlaying item: AudioPlayerProtocol.Item) { }

    func audioPlayer(_ player: AudioPlayerProtocol,
                     didPausePlaybackOf item: AudioPlayerProtocol.Item) { }

    func audioPlayerDidStop(_ player: AudioPlayerProtocol) { }
}

class AudioPlayerProtocol {
    struct Observation {
        weak var observer: AudioPlayerObserver?
    }
    private var observations = [ObjectIdentifier: Observation]()

    func addObserver(_ observer: AudioPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AudioPlayerObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

    class Item { }
    enum State {
        case idle
        case playing(Item)
        case paused(Item)
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
        for (id, observation) in observations {
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

//How to use
fileprivate class TestProtocolsVC: UIViewController, AudioPlayerObserver {
    var player: AudioPlayerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player?.addObserver(self)
    }
}
