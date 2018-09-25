//
//  ImageColorViewController.swift
//  UIPart
//
//  Created by Vladislav Gushin on 25/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class ImageColorViewController: UIViewController {
    var imageColors: UIImageColors?
    let image: UIImage


    @IBOutlet weak var backroundColor: UIView!

    @IBOutlet weak var primaryColor: UIView!

    @IBOutlet weak var secondaryColor: UIView!

    @IBOutlet weak var detailColor: UIView!

    init(image: UIImage) {
        self.image = image
        let bundle = Bundle(for: type(of: self))
        super.init(nibName: String(describing: ImageColorViewController.self), bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func back(_ sender: Any) {
        self.remove()
    }

    private func processColorsFromImage(_ imageColors: UIImageColors?) {
        guard let imageColors = imageColors else { return }
        backroundColor.backgroundColor = imageColors.background
        primaryColor.backgroundColor = imageColors.primary
        secondaryColor.backgroundColor = imageColors.secondary
        detailColor.backgroundColor = imageColors.detail
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .utility).async { [weak self] in
            let colors = self?.image.getColors()
            DispatchQueue.main.async {
                self?.processColorsFromImage(colors)
            }
        }
    }
}
