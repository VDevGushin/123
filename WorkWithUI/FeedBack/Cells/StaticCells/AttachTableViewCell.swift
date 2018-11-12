//
//  AttachTableViewCell.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 12/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

class AttachTableViewCell: UITableViewCell, IFeedbackStaticCell {
    private let maxAttachFiles = 5
    weak var viewController: UIViewController?
    @IBOutlet weak var fileSource: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    private var imagePicker: ImagePickerPresenter?
    var action: FeedBackCellAction?
    var initialSource: FeedBackCellIncomeData?
    var isReady: Bool = false
    private var images = Set<UIImage>()

    func config(value: String, action: FeedBackCellAction, viewController: UIViewController) {
        if isReady { return }
        self.isReady.toggle()
        self.viewController = viewController
        self.titleLabel.text = value
        self.action = action
        FeedBackStyle.titleLabel(self.titleLabel)
        self.imagePicker = ImagePickerPresenter.init(viewController: self.viewController!, getImageHandler: get)

        //config table
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.fileSource.collectionViewLayout = layout
        self.fileSource.showsHorizontalScrollIndicator = false
        self.fileSource.translatesAutoresizingMaskIntoConstraints = false
        self.fileSource.backgroundColor = UIColor.clear
        self.fileSource.allowsMultipleSelection = false
        self.fileSource.delegate = self
        self.fileSource.dataSource = self
        self.fileSource.registerWithNib(FeedBackImageCollectionViewCell.self)
    }

    func check() { return }
    func setValue(with: String) { return }

    @IBAction func addAction(_ sender: Any) {
        if self.images.count < maxAttachFiles {
            self.imagePicker?.getImageFromLibrary()
        }
    }

    private func get(selected image: UIImage?) {
        guard let image = image else { return }
        self.images.insert(image)
        self.fileSource.reloadData()
    }
}

extension AttachTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: FeedBackImageCollectionViewCell.self, indexPath: indexPath)!
        cell.fileImage?.image = Array(images)[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.images.isEmpty {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: 60, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
