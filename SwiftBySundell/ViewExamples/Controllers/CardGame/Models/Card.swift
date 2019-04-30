//
//  Card.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class GameCard: Equatable {
    let id: UUID
    var shown: Bool = false
    var artworkURL: UIImage!

    static var allCards = [GameCard]()

    init(card: GameCard) {
        self.id = card.id
        self.shown = card.shown
        self.artworkURL = card.artworkURL
    }

    init(image: UIImage) {
        self.id = UUID()
        self.shown = false
        self.artworkURL = image
    }

    static func == (lhs: GameCard, rhs: GameCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    func copy() -> GameCard {
        return GameCard(card: self)
    }
}
