//
//  SwipeCardView.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 23/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol SwipeCardsDelegate: class {
    func swipeDidEnd(on view: SwipeCardView)
}

class SwipeCardView: UIView {
    //MARK: - Properties
    private var swipeView: UIView!
    private var shadowView: UIView!
    private var imageView: UIImageView!
    private var label: UILabel!
    private var moreButton: UIButton!
    weak var delegate: SwipeCardsDelegate?

    var dataSource: CardsDataModel? {
        didSet {
            self.swipeView?.backgroundColor = dataSource?.bgColor
            self.label?.text = dataSource?.text
            if let image = dataSource?.image {
                imageView?.image = UIImage(named: image)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureShadowView()
        self.configureSwipeView()
        self.configureLabelView()
        self.configureImageView()
        self.configureButton()
        self.addPanGestureOnCards()
        self.configureTapGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //Private
    private func configureShadowView() {
        self.shadowView = UIView()
        self.shadowView.backgroundColor = .clear
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.shadowRadius = 4.0
        self.addSubview(self.shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowView.leftAnchor.constraint(equalTo: leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }

    private func configureSwipeView() {
        self.swipeView = UIView()
        self.swipeView.layer.cornerRadius = 15
        self.swipeView.clipsToBounds = true
        self.shadowView.addSubview(self.swipeView)

        self.swipeView.translatesAutoresizingMaskIntoConstraints = false
        self.swipeView.leftAnchor.constraint(equalTo: self.shadowView.leftAnchor).isActive = true
        self.swipeView.rightAnchor.constraint(equalTo: self.shadowView.rightAnchor).isActive = true
        self.swipeView.bottomAnchor.constraint(equalTo: self.shadowView.bottomAnchor).isActive = true
        self.swipeView.topAnchor.constraint(equalTo: self.shadowView.topAnchor).isActive = true
    }

    private func configureLabelView() {
        self.swipeView.addSubview(label)
        self.label.backgroundColor = .white
        self.label.textColor = .black
        self.label.textAlignment = .center
        self.label.font = UIFont.systemFont(ofSize: 18)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leftAnchor.constraint(equalTo: self.swipeView.leftAnchor).isActive = true
        self.label.rightAnchor.constraint(equalTo: self.swipeView.rightAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.swipeView.bottomAnchor).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 85).isActive = true

    }

    private func configureImageView() {
        self.imageView = UIImageView()
        self.swipeView.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false

        self.imageView.centerXAnchor.constraint(equalTo: self.swipeView.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.swipeView.centerYAnchor, constant: -30).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    func configureButton() {
        self.label.addSubview(moreButton)
        self.moreButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus-tab")?.withRenderingMode(.alwaysTemplate)
        self.moreButton.setImage(image, for: .normal)
        self.moreButton.tintColor = UIColor.red

        self.moreButton.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -15).isActive = true
        self.moreButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        self.moreButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.moreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // Gesture
    private func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }

    private func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }

    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
    }

    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            } else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            print(card.transform)
        default:
            break
        }
    }

}
