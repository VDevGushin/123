//
//  ModellingState .swift
//  MyWork
//
//  Created by Vladislav Gushin on 14/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

private class Enemy {
    var health = 10 {
        didSet { self.putOutOfPlayIfNeeded() }
    }

    private(set) var isInPlay = true

    var remove: (() -> Void)?
    func putOutOfPlayIfNeeded() {
        guard health <= 0 else { return }
        isInPlay = false
        remove?()
    }
}

private struct Video {
    struct PlaybackState {
        let file: File
        var progress: Double
    }
    enum State {
        case willDownload(from: URL)
        case downloading(task: URLSessionDownloadTask)
        case playing(PlaybackState)
        case paused(PlaybackState)
    }
    var state: State
    let url: URL
    var downloadTask: URLSessionDownloadTask?
    var file: File?
    var isPlaying = false
    var progress: Double = 0
}

/*
 if let downloadTask = video.downloadTask {
 // Handle download
 } else if let file = video.file {
 // Perform playback
 } else {
 // Uhm... what to do here? 🤔
 }
*/
