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
    private var images = [FeedBackAttachModel]()

    func config(value: String, action: FeedBackCellAction, viewController: UIViewController) {
        if isReady { return }
        self.isReady.toggle()
        self.viewController = viewController
        self.titleLabel.text = value
        self.action = action
        FeedBackStyle.titleLabel(self.titleLabel)
        self.imagePicker = ImagePickerPresenter.init(viewController: self.viewController!, getImageHandler: get)

        //config table
        FeedBackStyle.collectionView(self.fileSource, self, [FeedBackImageCollectionViewCell.self])
    }

    func check() { self.handle() }

    func setValue(with: String) { return }

    @IBAction func addAction(_ sender: Any) {
        if self.images.count < maxAttachFiles {
            self.imagePicker?.getImageFromLibrary()
        }
    }

    private func get(selected image: UIImage?) {
        guard let image = image else { return }
        self.images.append(FeedBackAttachModel(image: image))
        self.fileSource.reloadData()
        self.checkAddButtonEnabled()
        self.handle()
    }

    private func deleteAttach(id: ObjectIdentifier) {
        self.images.removeAll { $0.id == id }
        self.fileSource.reloadData()
        self.checkAddButtonEnabled()
        self.handle()
    }

    private func handle() {
        guard let action = self.action else { return }
        if !images.isEmpty {
            if case .attach(let handler) = action {
                handler(.attach(with: self.images))
            }
        }
    }

    private func checkAddButtonEnabled() {
        self.addButton.isEnabled = true
        if self.images.count >= self.maxAttachFiles {
            self.addButton.isEnabled = false
        }
    }
}

extension AttachTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: FeedBackImageCollectionViewCell.self, indexPath: indexPath)!
        cell.configure(with: Array(images)[indexPath.row], deleteHandler: deleteAttach)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
