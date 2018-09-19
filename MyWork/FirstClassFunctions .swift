//
//  FirstClassFunctions .swift
//  MyWork
//
//  Created by Vladislav Gushin on 10/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//First class functions

private class FirstClassFuntion {
    weak var button: UIButton!
    weak var label: UILabel!
    weak var imageView: UIImageView!

    weak var view: UIView!

    var images = [UIImage]()

    var views = [UIView]()
    func test() {
        let subviews: [UIView] = [button, label, imageView]

        subviews.forEach { subview in
            view!.addSubview(subview)
        }

        //Test1
        subviews.forEach(view!.addSubview)

        //Test2
        images.map(UIImageView.init).forEach(view!.addSubview)
    }
}

// TODO: - IMPLEMENTING TARGET/ACTION WITHOUT OBJECTIVE-C
typealias Action<Type, Input> = (Type) -> (Input) -> Void

private class ColorPicker: UIView {
    private(set) var selectedColor = UIColor.black
    private var observations = [(ColorPicker) -> Void]()
    func addTarget<T: AnyObject>(_ target: T, action: @escaping Action<T, ColorPicker>) {
        observations.append { [weak target] view in
//            guard let target = target else { return }
//            action(target)(view)
            target.map(action)?(view)
        }
    }

    func colorSelected(new color: UIColor) {
        self.selectedColor = color
        for observer in self.observations {
            observer(self)
        }
    }
}

private class CanvasViewController: UIViewController {
    private var drawingColor = UIColor.black
    func presentColorPicker() {
        let picker = ColorPicker()
        picker.addTarget(self, action: CanvasViewController.colorPicked)
    }

    private func colorPicked(using picker: ColorPicker) {
        drawingColor = picker.selectedColor
    }
}
