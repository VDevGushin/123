//
//  CardCell.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet private weak var frontImageView: UIImageView!
    @IBOutlet private weak var backImageView: UIImageView!

    var shown: Bool = false

    var card: GameCard? {
        didSet {
            guard let card = card else { return }

            self.frontImageView.image = card.artworkURL

            self.frontImageView.layer.cornerRadius = 5.0
            self.backImageView.layer.cornerRadius = 5.0

            self.frontImageView.layer.masksToBounds = true
            self.backImageView.layer.masksToBounds = true
        }
    }

    func showCard(_ show: Bool, animted: Bool) {
        self.frontImageView.isHidden = false
        self.backImageView.isHidden = false
        self.shown = show

        if animted {
            if show {
                UIView.transition(
                    from: self.backImageView,
                    to: self.frontImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion: { (finished: Bool) -> () in
                    })
            } else {
                UIView.transition(
                    from: self.frontImageView,
                    to: self.backImageView,
                    duration: 0.5,
                    options: [.transitionFlipFromRight, .showHideTransitionViews],
                    completion: { (finished: Bool) -> () in
                    })
            }
        } else {
            if show {
                self.bringSubviewToFront(self.frontImageView)
                self.backImageView.isHidden = true
            } else {
                self.bringSubviewToFront(self.backImageView)
                self.frontImageView.isHidden = true
            }
        }
    }
}
