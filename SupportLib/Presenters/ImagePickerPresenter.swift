//
//  ImagePickerPresenter.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 09/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

public class ImagePickerPresenter: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private lazy var imagePicker = UIImagePickerController()
    private let viewController: UIViewController
    private let handler: (UIImage?) -> Void

    public init(viewController: UIViewController, getImageHandler: @escaping (UIImage?) -> Void) {
        self.viewController = viewController
        self.handler = getImageHandler
    }

    public func getImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }
    }

    public func getImageFromCamera() {
        #if targetEnvironment(simulator)
            self.getImageFromLibrary()
        #else
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.viewController.present(imagePicker, animated: true, completion: nil)
            }
        #endif
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        self.handler(info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
    }
}
