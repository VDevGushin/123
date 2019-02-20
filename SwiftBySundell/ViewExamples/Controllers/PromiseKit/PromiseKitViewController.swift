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
    @IBOutlet private weak var animationView: LOTAnimationView!
    @IBOutlet private weak var imageView: UIImageView!
    private let dataController = DownloadImageDataController()

    @IBAction func onStartAnimation(_ sender: Any) {
        self.imageView.image = nil
        self.onDownloadStarted()

        self.dataController.downloadImage().done { image in
            self.imageView.image = image
        }.ensure {
            self.onDownloadComplete()
        }.catch { error in
            dump(error)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAnimation()
    }

    private func setupAnimation() {
        self.animationView.setAnimation(named: "loading-image")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.animationSpeed = 1.0
        self.animationView.loopAnimation = true
        self.animationView.isHidden = true
    }

    func onDownloadComplete() {
        if animationView.isAnimationPlaying {
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }

    func onDownloadStarted() {
        if !animationView.isAnimationPlaying {
            self.animationView.play()
            self.animationView.isHidden = false
        }
    }
}

extension PromiseKitViewController {
    static func make(title: String, navigator: AppCoordinator) -> PromiseKitViewController {
        return PromiseKitViewController(navigator: navigator, title: title, nibName: String(describing: PromiseKitViewController.self), bundle: nil)
    }
}

