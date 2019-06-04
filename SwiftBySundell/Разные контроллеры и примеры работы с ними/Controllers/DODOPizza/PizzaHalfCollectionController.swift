//
//  PizzaHalfCollectionController.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 27/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

class PizzaHalfCollectionController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    private var side: PizzaHalfOrientation
    var halves: [PizzaHalvesViewModel] = []

    private var mainPizzaSize: CGFloat {
        let isBigDevice = UIScreen.main.bounds.width > 320
        if isBigDevice {
            return 300.0
        } else {
            return 230.0
        }
    }

    init(side: PizzaHalfOrientation) {
        self.side = side
        super.init(nibName: "PizzaHalfCollectionController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? PizzaHalfSelectorLayout {
            layout.setupSizeAndInsets(pizzaSize: mainPizzaSize)
        }

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCellFromNib(ofType: PizzaHalfCell.self)
        self.collectionView.registerSupplementaryFromNib(
            ofType: PizzaHalfTitleHeader.self,
            kind: UICollectionView.elementKindSectionHeader)
    }
}

extension PizzaHalfCollectionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.halves.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let halfModel = self.halves[indexPath.row]
        let cell = collectionView.dequeueCellOf(type: PizzaHalfCell.self, for: indexPath)
        cell.setup(halfOrientation: side, pizzaHalf: halfModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let halfModel = halves[indexPath.row]

        let header = collectionView.dequeueSupplementaryOf(
            type: PizzaHalfTitleHeader.self,
            for: indexPath,
            kind: UICollectionView.elementKindSectionHeader)

        header.setup(title: halfModel.name, subtitle: "price", halfOrientation: side)
        return header
    }
}


fileprivate extension UICollectionView {
    func registerCellFromNib<CellType>(ofType: CellType.Type) where CellType: UICollectionViewCell {
        let classString = String(describing: CellType.self)
        let nib = UINib(nibName: classString, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: classString)
    }

    func dequeueCellOf<CellType>(type: CellType.Type, for indexPath: IndexPath) -> CellType where CellType: UICollectionViewCell {
        let cellId = String(describing: type.self)
        return dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellType
    }


    // MARK: - Supplementary
    func registerSupplementaryFromNib<CellType>(ofType: CellType.Type, kind: String)
    where CellType: UICollectionReusableView {
        let classString = String(describing: CellType.self)
        let nib = UINib(nibName: classString, bundle: nil)

        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: classString)
    }

    func dequeueSupplementaryOf<CellType>(type: CellType.Type, for indexPath: IndexPath, kind: String) -> CellType
    where CellType: UICollectionReusableView {
        let cellId = String(describing: type.self)
        let supplementary = dequeueReusableSupplementaryView(ofKind: kind,
            withReuseIdentifier: cellId,
            for: indexPath)
        return supplementary as! CellType
    }
}

