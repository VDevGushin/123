//
//  FeedBackStyle.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class FeedBackStyle {
    static let whiteColor = UIColor.white
    static let textFieldBorderColor = UIColor.lightGray
    static let styleColor = UIColor.init(hex: "#8fb5bd")
    static let titleFont = UIFont.systemFont(ofSize: 17.0)
    static let textColor = UIColor.black
    static let errorInputFormColor = UIColor.red

    static let sendButton: Decoration<UIButton> = { (button: UIButton) -> Void in
        button.tintColor = FeedBackStyle.whiteColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = FeedBackStyle.styleColor
    }

    static let textView: Decoration<UITextView> = { (textView: UITextView) -> Void in
        textView.font = FeedBackStyle.titleFont
        textView.textColor = FeedBackStyle.textColor
        textView.layer.borderWidth = 0.2
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.layer.borderColor = FeedBackStyle.textFieldBorderColor.cgColor
    }

    static let textViewWithError: Decoration<UITextView> = { (textView: UITextView) -> Void in
        textView.font = FeedBackStyle.titleFont
        textView.textColor = FeedBackStyle.errorInputFormColor
        textView.layer.borderWidth = 0.2
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.layer.borderColor = FeedBackStyle.errorInputFormColor.cgColor
    }

    static let indicator: Decoration<UIActivityIndicatorView> = { (indicator: UIActivityIndicatorView) -> Void in
        indicator.color = FeedBackStyle.styleColor
    }

    static let titleLabel: Decoration<UILabel> = { (label: UILabel) -> Void in
        label.font = FeedBackStyle.titleFont
        label.numberOfLines = 3
        label.textColor = FeedBackStyle.textColor
    }

    static let titleLabelWithError: Decoration<UILabel> = { (label: UILabel) -> Void in
        label.font = FeedBackStyle.titleFont
        label.numberOfLines = 3
        label.textColor = FeedBackStyle.errorInputFormColor
    }

    static let textField: Decoration<UITextField> = { (textField: UITextField) -> Void in
        textField.font = FeedBackStyle.titleFont
        textField.textColor = FeedBackStyle.textColor
        textField.layer.borderWidth = 0.2
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderColor = FeedBackStyle.textFieldBorderColor.cgColor
    }

    static let textFieldWithError: Decoration<UITextField> = { (textField: UITextField) -> Void in
        textField.font = FeedBackStyle.titleFont
        textField.textColor = FeedBackStyle.errorInputFormColor
        textField.layer.borderWidth = 0.2
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderColor = FeedBackStyle.errorInputFormColor.cgColor
    }

    static let tableView: TableDecoration = { (_ table: UITableView, delegate: UITableViewDelegate&UITableViewDataSource, cellTypes: [UITableViewCell.Type]) -> Void in
        cellTypes.forEach {
            table.registerNib($0)
        }

        table.delegate = delegate
        table.dataSource = delegate
        table.separatorStyle = .none
        table.backgroundColor = FeedBackStyle.whiteColor

        if let delegate = delegate as? IPullToRefresh {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(delegate, action: #selector(delegate.handleRefresh(_:)), for: UIControl.Event.valueChanged)
            refreshControl.tintColor = FeedBackStyle.styleColor
            table.addSubview(refreshControl)
        }
    }

    static let serachController: SearchControllerDecoration = { (_ serachController: UISearchController, delegate: UISearchResultsUpdating) -> Void in
        serachController.searchResultsUpdater = delegate
        serachController.hidesNavigationBarDuringPresentation = false
        serachController.dimsBackgroundDuringPresentation = false
        serachController.searchBar.barTintColor = FeedBackStyle.styleColor
        serachController.searchBar.searchBarStyle = .default
        serachController.searchBar.sizeToFit()

        if let textfield = serachController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = FeedBackStyle.whiteColor
            textfield.layer.cornerRadius = 16.0
            textfield.clearButtonMode = UITextField.ViewMode.whileEditing
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            textfield.layer.masksToBounds = true
            textfield.layer.borderColor = FeedBackStyle.styleColor.cgColor
            textfield.layer.borderWidth = 1.5
            textfield.textColor = FeedBackStyle.styleColor
        }
    }

    static let collectionView: CollectionDecoration = { (_ collection: UICollectionView, delegate: UICollectionViewDelegate&UICollectionViewDataSource, cellTypes: [UICollectionViewCell.Type]) -> Void in
        cellTypes.forEach {
            collection.registerWithNib($0)
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collection.collectionViewLayout = layout
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.clear
        collection.allowsMultipleSelection = false
        collection.delegate = delegate
        collection.dataSource = delegate
    }
}
