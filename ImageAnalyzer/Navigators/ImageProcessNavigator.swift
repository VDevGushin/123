//
//  ImageProcessNavigator.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

final class ImageProcessNavigator: INavigator {
    enum Destination {
        case imageColors(selectedImage: UIImage, imageGetter: IColorGetter)
        case imageColorsScheme(colors: [UIColor])
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
        case .imageColors(selectedImage: let image, imageGetter: let getter):
            return ImageGetColorsViewController(image: image, colorGetter: getter)
        case .imageColorsScheme(colors: let colors):
            break
        }
        //FIXME: - temp
        return UIViewController(nibName: nil, bundle: nil)
    }
}

extension ImageProcessNavigator {
    static func makeRootWindow() -> UIWindow {
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        let appNavigationController = AppNavigationViewController()
        appNavigationController.setViewControllers([ImageCaptureViewController()], animated: true)
        window.rootViewController = appNavigationController
        window.makeKeyAndVisible()
        return window
    }
}

