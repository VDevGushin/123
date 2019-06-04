//
//  TinderViewController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 24/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class TinderViewController: CoordinatorViewController {
    var viewModelData = [CardsDataModel(bgColor: UIColor(red: 0.96, green: 0.81, blue: 0.46, alpha: 1.0), text: "Hamburger", image: "hamburger"),
        CardsDataModel(bgColor: UIColor(red: 0.29, green: 0.64, blue: 0.96, alpha: 1.0), text: "Puppy", image: "puppy"),
        CardsDataModel(bgColor: UIColor(red: 0.29, green: 0.63, blue: 0.49, alpha: 1.0), text: "Poop", image: "poop"),
        CardsDataModel(bgColor: UIColor(red: 0.69, green: 0.52, blue: 0.38, alpha: 1.0), text: "Panda", image: "panda"),
        CardsDataModel(bgColor: UIColor(red: 0.90, green: 0.99, blue: 0.97, alpha: 1.0), text: "Subway", image: "subway"),
        CardsDataModel(bgColor: UIColor(red: 0.83, green: 0.82, blue: 0.69, alpha: 1.0), text: "Robot", image: "robot")]

    var stackContainer: StackContainterView!

    override func viewDidLoad() {
        super.viewDidLoad()
        stackContainer = StackContainterView()
        view.addSubview(stackContainer)
        self.configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        self.configureNavigationBarButtonItem()
        stackContainer.dataSource = self
    }

    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }

    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }

    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
    }
}

extension TinderViewController: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }

    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
}
