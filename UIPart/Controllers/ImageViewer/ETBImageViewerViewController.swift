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

extension IImageShowController where Self: UIViewController {
    func showImage(with image: UIImage) {
        let imageView = ETBImageViewerViewController.controller(with: image)
        self.addImageViewer(imageView)
    }

    func closeImage() {
        self.removeWithAnimation()
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

    @IBAction func processImage(_ sender: Any) {
        let actions = [
            ("Percentage",
             { let vc = ImageColorViewController(image: self.image, colorGetter: ColorPercentageGetter())
                 self.addWithAnimaton(vc) }),
            ("Average color",
             { let vc = ImageColorViewController(image: self.image, colorGetter: AverageColorSupportPercentageGetter())
                 self.addWithAnimaton(vc) })
        ]
        
        let selectPresenter = SelectPresenter.init(actions: actions, message: "Please select an color getter", title: "Colors")
        selectPresenter.present(in: self)
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
        self.removeWithAnimation()
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
