//
//  MemoryGame.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

protocol MemoryGameProtocol: class {
    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGameDidEnd(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showCards cards: [GameCard])
    func memoryGame(_ game: MemoryGame, hideCards cards: [GameCard])
}

class MemoryGame {

    // MARK: - Properties
    weak var delegate: MemoryGameProtocol?
    var isPlaying: Bool = false
    
    private var cards: [GameCard] = []
    private var cardsShown: [GameCard] = []
    
    // MARK: - Methods
    func newGame(cardsArray: [GameCard]) -> [GameCard] {
        self.cards = cardsArray
        self.cards.shuffle()
        self.isPlaying = true
        self.delegate?.memoryGameDidStart(self)
        return cards
    }

    func restartGame() {
        self.isPlaying = false
        self.cards.removeAll()
        self.cardsShown.removeAll()
    }

    subscript (index: Int) -> GameCard? {
        if self.cards.count > index {
            return self.cards[index]
        }
        return nil
    }

    func indexForCard(_ card: GameCard) -> Int? {
        for index in 0...cards.count - 1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }

    func didSelectCard(_ card: GameCard?) {
        guard let card = card else { return }

        delegate?.memoryGame(self, showCards: [card])

        if unmatchedCardShown() {
            let unmatched = unmatchedCard()!

            if card == unmatched {
                cardsShown.append(card)
            } else {
                let secondCard = cardsShown.removeLast()
                DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + 1.0) {
                    self.delegate?.memoryGame(self, hideCards: [card, secondCard])
                }
            }
        } else {
            cardsShown.append(card)
        }

        if cardsShown.count == cards.count {
            endGame()
        }
    }

    fileprivate func endGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self)
    }

    /**
     Indicates if the card selected is unmatched
     (the first one selected in the current turn).
     - Returns: An array of shuffled cards.
     */
    fileprivate func unmatchedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }

    /**
     Reads the last element in **cardsShown** array.
     - Returns: An unmatched card.
     */
    fileprivate func unmatchedCard() -> GameCard? {
        return cardsShown.last
    }
}
