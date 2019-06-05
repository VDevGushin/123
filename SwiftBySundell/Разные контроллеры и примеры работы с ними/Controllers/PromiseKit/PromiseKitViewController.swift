//
//  PromiseKitViewController.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import PromiseKit
import Lottie

class PromiseKitViewController: CoordinatorViewController, DownloadImageDataControllerDelegate {
    deinit {
        print("PromiseKitViewController deinit")
    }

    @IBOutlet private weak var animationView: AnimationView!
    @IBOutlet private weak var imageView: UIImageView!

    private lazy var fetchImageContiller = DownloadImageDataController()

    @IBAction func onStartAnimation(_ sender: Any) {
        self.onDownloadStarted()
        self.imageView.image = nil
        //fetchImageContiller.getImage()
        fetchImageContiller.getWelcome()
    }

    func complete(dataController: DownloadImageDataController, image: UIImage?) {
        self.imageView.image = image
        self.onDownloadComplete()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
        self.fetchImageContiller.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.fetchImageContiller.cancel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onStartAnimation(self)
    }

    private func setupAnimation() {
        self.animationView.animation = Animation.named("loading-image")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = 1.0
        self.animationView.loopMode = .loop
        self.animationView.isHidden = true
    }

    private func onDownloadComplete() {
        if animationView.isAnimationPlaying {
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }

    private func onDownloadStarted() {
        if !animationView.isAnimationPlaying {
            self.animationView.play()
            self.animationView.isHidden = false
        }
    }
}
