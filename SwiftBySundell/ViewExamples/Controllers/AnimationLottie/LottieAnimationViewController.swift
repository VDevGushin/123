//
//  LottieAnimationViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Lottie

fileprivate extension Array where Element == LOTAnimationView {
    func stopAnimation() {
        for element in self {
            element.stop()
        }
    }
}

class LottieAnimationViewController: CoordinatorViewController {

    @IBOutlet private weak var animationView: LOTAnimationView!
    @IBOutlet private weak var animationView2: LOTAnimationView!
    @IBOutlet private weak var animationView3: LOTAnimationView!
    @IBOutlet private weak var animationView4: LOTAnimationView!
    @IBOutlet private weak var contentView: UIView!

    //For download testing
    var prevProgress : CGFloat = 0.0
    private var downloadTask: URLSessionDownloadTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBigAnimations()
        self.addSwitcher()
        self.progressAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        [self.animationView, self.animationView2, self.animationView3, self.animationView4].stopAnimation()
    }

    @IBAction func onStartAnimation(_ sender: Any) {
        if !animationView2.isAnimationPlaying {
            animationView2.play()
        }

        if animationView.isAnimationPlaying {
            self.animationView.stop()
        } else {
            self.animationView.play { finish in
                print("End animation")
            }
        }

        //Download for progress
        let downloadRequest = URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/8f/Whole_world_-_land_and_oceans_12000.jpg")!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

        downloadTask = session.downloadTask(with: downloadRequest)
        downloadTask!.resume()
    }

    @objc func switchTogge(animatedSwitch: LOTAnimatedSwitch) {
        if animatedSwitch.isOn {
            print("on")
        } else {
            print("off")
        }
    }

    private func progressAnimation() {
        //self.animationView4.setAnimation(named: "success")
        //taxi-app-loading
        self.animationView4.setAnimation(named: "taxi-app-loading")
        self.animationView4.contentMode = .scaleAspectFit
    }

    private func addSwitcher() {
        let mySwitch = LOTAnimatedSwitch(named: "switch-action")
        mySwitch.translatesAutoresizingMaskIntoConstraints = false

        mySwitch.setProgressRangeForOnState(fromProgress: 0.5, toProgress: 1.0)
        mySwitch.setProgressRangeForOffState(fromProgress: 1.0, toProgress: 0.5)
        mySwitch.addTarget(self, action: #selector(switchTogge), for: .valueChanged)
        self.contentView.addSubview(mySwitch)
        NSLayoutConstraint.activate([
            mySwitch.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            mySwitch.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            mySwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            mySwitch.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5),
        ])
    }

    private func addBigAnimations() {
        self.animationView.setAnimation(named: "pulsing-loading-circles")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = 1.0
        self.animationView.loopAnimation = true

        self.animationView2.setAnimation(named: "not-found")
        self.animationView2.loopAnimation = true
        self.animationView2.contentMode = .scaleAspectFit

        self.animationView3.setAnimation(named: "im-thirsty")
        self.animationView3.loopAnimation = true
        self.animationView3.contentMode = .scaleAspectFit
        self.animationView3.play()
    }
}

extension LottieAnimationViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.prevProgress = 0.0
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
    
        self.animationView4.play(fromProgress: self.prevProgress, toProgress: progress, withCompletion: { _ in
            print(progress)
        })
        self.prevProgress = progress
    }

}
