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

class PromiseKitViewController: CoordinatorViewController {
    deinit {
        print("PromiseKitViewController deinit")
    }
    
    @IBOutlet private weak var animationView: LOTAnimationView!
    @IBOutlet private weak var imageView: UIImageView!

    private lazy var fetchImage = DownloadImageDataController.fetchImageWithCancel()

    @IBAction func onStartAnimation(_ sender: Any) {
        if self.fetchImage.promise.isResolved {
            //Обновление задачи
            self.fetchImage = DownloadImageDataController.fetchImageWithCancel()
            //закачка картинки
            self.downloadImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.fetchImage.cancel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.downloadImage()
    }

    private func downloadImage() {
        self.imageView.image = nil
        //закачка картинки
        self.onDownloadStarted()
        self.fetchImage.promise.done { [weak self] newImage in
            self?.imageView.image = newImage
        }.ensure { [weak self] in
            self?.onDownloadComplete()
        }.catch(policy: .allErrors) { error in
            dump(error)
        }
    }

    private func setupAnimation() {
        self.animationView.setAnimation(named: "loading-image")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = 1.0
        self.animationView.loopAnimation = true
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
