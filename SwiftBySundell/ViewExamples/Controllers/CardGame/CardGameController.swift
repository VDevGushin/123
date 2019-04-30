//
//  CardGameController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 30/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class CardGameController: CoordinatorViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var timer: UILabel!

    private var counter = 0
    private var time = Timer()
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)

    private let game = MemoryGame()
    private var cards = [GameCard]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.game.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        self.collectionView.register(UINib(nibName: String(describing: CardCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CardCell.self))

        GameApiClient.shared.getCardImages { (cardsArray, error) in
            if let _ = error {
                // show alert
            }
            self.cards = cardsArray!
            self.setupNewGame()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.game.isPlaying {
            self.resetGame()
        }
    }

    func setupNewGame() {
        self.cards = self.game.newGame(cardsArray: self.cards)
        self.collectionView.reloadData()
    }

    func resetGame() {
        self.game.restartGame()
        self.setupNewGame()
    }

    @IBAction private func onStartGame(_ sender: Any) {
        self.collectionView.isHidden = false
        self.counter = 0
        self.timer.text = "0:00"
        self.time.invalidate()
        self.time = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func timerAction() {
        self.counter += 1
        self.timer.text = "0:\(counter)"
    }
}

// MARK: - CollectionView Delegate Methods
extension CardGameController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCell.self), for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        guard let card = game[indexPath.item] else { return cell }
        cell.card = card
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        if cell.shown { return }
        self.game.didSelectCard(cell.card)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension CardGameController: UICollectionViewDelegateFlowLayout {
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * 4
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / 4

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - MemoryGameProtocol Methods
extension CardGameController: MemoryGameProtocol {
    func memoryGameDidStart(_ game: MemoryGame) {
        collectionView.reloadData()
    }

    func memoryGame(_ game: MemoryGame, showCards cards: [GameCard]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! CardCell
            cell.showCard(true, animted: true)
        }
    }

    func memoryGame(_ game: MemoryGame, hideCards cards: [GameCard]) {
        for card in cards {
            guard let index = game.indexForCard(card) else { continue }
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! CardCell
            cell.showCard(false, animted: true)
        }
    }

    func memoryGameDidEnd(_ game: MemoryGame) {
        time.invalidate()

        let alertController = UIAlertController(
            title: defaultAlertTitle,
            message: defaultAlertMessage,
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Nah", style: .cancel) { [weak self] (action) in
            self?.collectionView.isHidden = true
        }
        let playAgainAction = UIAlertAction(title: "Dale!", style: .default) { [weak self] (action) in
            self?.collectionView.isHidden = true
            self?.resetGame()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)

        self.present(alertController, animated: true) { }

        resetGame()
    }
}
