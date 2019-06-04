//
//  CategoryHeaderView.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 16/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CategoryHeaderView: UIView {
    var imageView: UIImageView!
    var colorView: UIView!
    var bgColor = UIColor(red: 235 / 255, green: 96 / 255, blue: 91 / 255, alpha: 1)
    var titleLabel = UILabel()
    
    init(frame: CGRect, title: String) {
        self.titleLabel.text = title.uppercased()
        super.init(frame: frame)
        self.setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel.text = "test"
        self.setUpView()
    }

    func setUpView() {
        self.backgroundColor = .white
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorView)

        let constraints: [NSLayoutConstraint] = [
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorView.topAnchor.constraint(equalTo: self.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        imageView.image = UIImage(named: "Inspiration-3")
        imageView.contentMode = .scaleAspectFit

        colorView.backgroundColor = bgColor
        colorView.alpha = 0.6

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)

        let titlesConstraints: [NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
        ]

        NSLayoutConstraint.activate(titlesConstraints)

        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textAlignment = .center
    }

    func decrementColorAlpha(offset: CGFloat) {
        if self.colorView.alpha <= 1 {
            let alphaOffset = (offset / 500) / 85
            self.colorView.alpha += alphaOffset
        }
    }

    func incrementColorAlpha(offset: CGFloat) {
        if self.colorView.alpha >= 0.6 {
            let alphaOffset = (offset / 200) / 85
            self.colorView.alpha -= alphaOffset
        }
    }
}
