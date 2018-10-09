//
//  ImageCaptureViewController.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class ImageCaptureViewController: AppRootViewController {
    @IBOutlet private weak var imageScrollView: ImageScrollView!
    private var imagePicker: ImagePickerPresenter?

    private var selectedImage: UIImage? {
        didSet {
            if let selectedImage = selectedImage {
                imageScrollView.setImageContentMode(.aspectFit)
                imageScrollView.setInitialOffset(.center)
                imageScrollView.display(image: selectedImage)
            }
        }
    }

    init(navigator: Coordinator) {
        let bundle = Bundle(for: type(of: self))
        super.init(navigator: navigator, title: AppText.ImageCaptureViewController.title.text, nibName: String(describing: ImageCaptureViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = .init(viewController: self, getImageHandler: get)
    }

    fileprivate func processImage() {
        guard let image = self.selectedImage else { return }
        let actions = [
            ("Percentage",
             { self.navigator.navigate(to: .imageColors(selectedImage: image, imageGetter: ColorPercentageGetter())) }),
            ("Avatage color",
             { self.navigator.navigate(to: .imageColors(selectedImage: image, imageGetter: AvarageColorImageGetter())) }),
        ]
        let selectPresenter = SelectionPresenter(senderView: self.view, actions: actions, message: "Please select an color getter", title: "Colors", style: .actionSheet)
        selectPresenter.present(in: self)
    }

    override func buildUI() {
        let button1 = UIBarButtonItem.init(title: "Library", style: .done, target: self,
                                           action: #selector(getImageFromLibraryHandler))
        let button2 = UIBarButtonItem.init(title: "Camera", style: .done, target: self,
                                           action: #selector(getImageFromCameraHandler))
        self.navigationItem.leftBarButtonItems = [button1, button2]
        let button3 = UIBarButtonItem.init(title: "Process", style: .done, target: self,
                                           action: #selector(processImageHandler))
        self.navigationItem.rightBarButtonItems = [button3]
    }
}

//MARK: - Build ui
fileprivate extension ImageCaptureViewController {
    @objc func getImageFromLibraryHandler() {
        self.imagePicker?.getImageFromLibrary()
    }

    @objc func getImageFromCameraHandler() {
        self.imagePicker?.getImageFromCamera()
    }

    @objc func processImageHandler() {
        self.processImage()
    }

    private func get(selected image: UIImage?) {
        self.selectedImage = image
    }
}
