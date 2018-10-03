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
    @IBOutlet weak var imageScrollView: ImageScrollView!
    private let imageNavigator: ImageProcessNavigator
    private lazy var imagePicker = UIImagePickerController()

    private var selectedImage: UIImage? {
        didSet {
            if let selectedImage = selectedImage {
                imageScrollView.setImageContentMode(.aspectFit)
                imageScrollView.setInitialOffset(.center)
                imageScrollView.display(image: selectedImage)
            }
        }
    }

    init(navigator: ImageProcessNavigator) {
        self.imageNavigator = navigator
        let bundle = Bundle(for: type(of: self))
        super.init(title: "Image", nibName: String(describing: ImageCaptureViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Functional
    fileprivate func getImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    fileprivate func getImageFromCamera() {
        #if targetEnvironment(simulator)
            self.getImageFromLibrary()
        #else
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        #endif
    }

    fileprivate func processImage() {
        guard let image = self.selectedImage else { return }
        let actions = [
            ("Percentage",
             { self.imageNavigator.navigate(to: .imageColors(selectedImage: image, imageGetter: ColorPercentageGetter())) }),
            ("Avatage color",
             { self.imageNavigator.navigate(to: .imageColors(selectedImage: image, imageGetter: AvarageColorImageGetter())) }),
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
        self.getImageFromLibrary()
    }

    @objc func getImageFromCameraHandler() {
        self.getImageFromCamera()
    }

    @objc func processImageHandler() {
        self.processImage()
    }
}

//MARK: - UIImagePickerController delegate
extension ImageCaptureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
}
