//
//  ETBImageViewerViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 19/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol IImageShowController: class {
    func showImage(with: UIImage)
    func closeImage()
}

fileprivate extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        child.view.frame = self.view.bounds
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.layoutSubviews()
    }

    func remove() {
        guard parent != nil else { return }
        UIView.animate(withDuration: 0.7, animations: {
            self.view.alpha = 0
        }) { _ in
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
}

extension IImageShowController where Self: UIViewController {
    func showImage(with image: UIImage) {
        let imageView = ETBImageViewerViewController.controller(with: image)
        self.add(imageView)
    }

    func closeImage() {
        self.remove()
    }
}

class ETBImageViewerViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var closeButton: RoundButton!
    let image: UIImage

    init(with image: UIImage) {
        self.image = image
        super.init(nibName: String(describing: ETBImageViewerViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageScrollView.setImageContentMode(.aspectFit)
        imageScrollView.setInitialOffset(.center)
        imageScrollView.display(image: image)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.remove()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.imageScrollView.refresh()
        })
    }
}

extension ETBImageViewerViewController {
    class func controller(with image: UIImage) -> ETBImageViewerViewController {
        return .init(with: image)
    }
}
