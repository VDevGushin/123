//
//  GameApiClient.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

typealias CardsArray = [GameCard]

class GameApiClient {
    static let shared = GameApiClient()

    static var defaultCardImages: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!
    ];

    func getCardImages(completion: ((CardsArray?, Error?) -> ())?) {
        var cards = CardsArray()
        let cardImages = GameApiClient.defaultCardImages

        for image in cardImages {
            let card = GameCard(image: image)
            let copy = card.copy()

            cards.append(card)
            cards.append(copy)
        }

        completion!(cards, nil)
    }
}
