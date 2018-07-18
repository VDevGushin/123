//
//  DependencyInjectionWithFunctions.swift
//  MyWork
//
//  Created by Vladislav Gushin on 17/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
//support
class Deck {
    var count: UInt32 = 5
    subscript(index: UInt32) -> Card {
        get {
            return Card()
        }
    }
}
class Card { }
//
/*
 Теперь мы заменили Randomizerпротокол с простым typealias, и передаем функцию arc4random_uniform непосредственно в качестве аргумента по умолчанию randomizer. Нам больше не нужен класс в реализации по умолчанию, и мы все еще можем легко насмехаться над рандомизации в тесте:*/
//protocol Randomizer {
//    func randomNumber(upperBound: UInt32) -> UInt32
//}
//
//class DefaultRandomizer: Randomizer {
//    func randomNumber(upperBound: UInt32) -> UInt32 {
//        return arc4random_uniform(upperBound)
//    }
//}


class CardGame {
    typealias Randomizer = (UInt32) -> UInt32
    private let deck: Deck
    private let randomizer: Randomizer

    init(deck: Deck, randomizer: @escaping Randomizer = arc4random_uniform) {
        self.deck = deck
        self.randomizer = randomizer
    }

    func drawRandomCard() -> Card {
        let index = randomizer(deck.count)
        let card = deck[index]
        return card
    }
}
