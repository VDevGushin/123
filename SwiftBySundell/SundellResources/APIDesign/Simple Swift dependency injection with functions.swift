//
//  Simple Swift dependency injection with functions.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 24/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate struct Deck {
    private var arrayOfCards = [Card]()
    let count: Int

    subscript(index: Int) -> Card {
        get {
            return arrayOfCards[index]
        }
    }
}

fileprivate struct Card { }

fileprivate protocol Randomizer {
    func randomNumber(upperBound: Int) -> Int
}

fileprivate struct DefaultRandomizer: Randomizer {
    func randomNumber(upperBound: Int) -> Int {
        return upperBound + 123
    }
}

fileprivate class CardGame {
    private let deck: Deck
    private var randomizer: Randomizer?

    init(deck: Deck, randomizer: Randomizer = DefaultRandomizer()) {
        self.deck = deck
        self.randomizer = randomizer
    }

    //Второй вариант более гибкий
    typealias RandomizerFunc = (UInt32) -> UInt32

    init(deck: Deck, randomizer: @escaping RandomizerFunc = arc4random_uniform) {
        self.deck = deck
        //...

    }

    func drawRandomCard() -> Card? {
        guard let index = randomizer?.randomNumber(upperBound: deck.count) else { return nil }
        let card = deck[index]
        return card
    }
}
