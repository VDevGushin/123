//
//  StackContainterView.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 23/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
}

class StackContainterView: UIView {
    private var numberOfCardsToShow: Int = 0
    private var cardsToBeVisible: Int = 3
    private var remainingcards: Int = 0
    private let horizontalInset: CGFloat = 10.0
    private let verticalInset: CGFloat = 10.0

    private var cardViews: [SwipeCardView] = []

    private var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }

    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        self.removeAllCardViews()
        guard let datasource = dataSource else { return }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.numberOfCardsToShow = datasource.numberOfCardsToShow()
        self.remainingcards = numberOfCardsToShow
        for i in 0..<min(self.numberOfCardsToShow, self.cardsToBeVisible) {
            self.addCardView(cardView: datasource.card(at: i), atIndex: i)
        }
    }

    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        self.addCardFrame(index: index, cardView: cardView)
        self.cardViews.append(cardView)
        self.insertSubview(cardView, at: 0)
        self.remainingcards -= 1
    }

    private func addCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = CGFloat(index) * self.horizontalInset
        let verticalInset = CGFloat(index) * self.verticalInset
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        cardView.frame = cardViewFrame
    }

    private func removeAllCardViews() {
        for cardView in self.visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
}

extension StackContainterView: SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()

        if self.remainingcards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - self.remainingcards

            self.addCardView(cardView: datasource.card(at: newIndex),
                             atIndex: min(self.numberOfCardsToShow, self.cardsToBeVisible) - 1)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
    }
}
