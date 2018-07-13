//
//  Observers+ClosureTokens.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
private extension Dictionary where Key == UUID {
    mutating func insert(_ value: Value) -> UUID {
        let id = UUID()
        self[id] = value
        return id
    }
}

class ObservationToken {
    private let cancellationClosure: () -> Void

    init(cancellationClosure: @escaping () -> Void) {
        self.cancellationClosure = cancellationClosure
    }

    func cancel() {
        cancellationClosure()
    }
}

class AudioPlayerClosuteTokens {
    private var observations = (
        started: [UUID: (AudioPlayerClosuteTokens, Item) -> Void](),
        paused: [UUID: (AudioPlayerClosuteTokens, Item) -> Void](),
        stopped: [UUID: (AudioPlayerClosuteTokens) -> Void]()
    )
    
    @discardableResult
    func addPlaybackStartedObserver<T: AnyObject>(_ observer: T,
        closure: @escaping (T, AudioPlayerClosuteTokens, Item) -> Void) -> ObservationToken {
        let id = UUID()
        observations.started[id] = { [weak self, weak observer] player, item in
            // If the observer has been deallocated, we can
            // automatically remove the observation closure.
            guard let observer = observer else {
                self?.observations.started.removeValue(forKey: id)
                return
            }
            closure(observer, player, item)
        }
        
        return ObservationToken { [weak self] in
            self?.observations.started.removeValue(forKey: id)
        }
    }

    @discardableResult
    func observePlaybackPaused(using closure: @escaping (AudioPlayerClosuteTokens, Item) -> Void)
        -> ObservationToken {
            let id = observations.paused.insert(closure)

            return ObservationToken { [weak self] in
                self?.observations.paused.removeValue(forKey: id)
            }
    }

    @discardableResult
    func observePlaybackStopped(using closure: @escaping (AudioPlayerClosuteTokens) -> Void)
        -> ObservationToken {
            let id = observations.stopped.insert(closure)

            return ObservationToken { [weak self] in
                self?.observations.stopped.removeValue(forKey: id)
            }
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
        func stateDidChange() {
            switch state {
            case .idle:
                observations.stopped.values.forEach { closure in
                    closure(self)
                }
            case .playing(let item):
                observations.started.values.forEach { closure in
                    closure(self, item)
                }
            case .paused(let item):
                observations.paused.values.forEach { closure in
                    closure(self, item)
                }
            }
        }
    }
}

//How to use
fileprivate class TestClosureTokensVC: UIViewController {
    var player: AudioPlayerClosuteTokens?
    deinit {
        observationToken?.cancel()
    }
    private var observationToken: ObservationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        player?.addPlaybackStartedObserver (self) { vc, player, item in
//            titleLabel.text = item.title
//            durationLabel.text = "\(item.duration)"
        }
    }
}
