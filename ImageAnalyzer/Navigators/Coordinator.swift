//
//  ImageProcessNavigator.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class Coordinator: ICoordinator {
    enum Destination {
        case imageCaptureViewController
        case imageColors(selectedImage: UIImage, imageGetter: IColorGetter)
        case imageColorsScheme(colors: [UIColor])
    }

    enum DataFor {
        case imageCaptureViewController(with: Any)
    }

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .imageCaptureViewController:
            return ImageCaptureViewController(navigator: self)
        case .imageColors(selectedImage: let image, imageGetter: let getter):
            return ImageGetColorsViewController(navigator: self, image: image, colorGetter: getter)
        case .imageColorsScheme(colors: let colors):
            break
        }
        //FIXME: - temp
        return UIViewController(nibName: nil, bundle: nil)
    }

//    func send(messageFor: DataFor) {
//        guard let controllers = self.navigationController?.viewControllers else { return }
//        for receiver in controllers {
//            guard let receiver = receiver as? AppRootViewController else { return }
//            switch messageFor {
//            case .imageCaptureViewController(let data) where receiver is ImageCaptureViewController:
//                receiver.getMessage(message: data)
//            default:
//                break
//            }
//        }
//    }
}
