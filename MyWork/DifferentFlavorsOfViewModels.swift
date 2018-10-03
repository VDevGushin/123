//
//  DifferentFlavorsOfViewModels.swift
//  MyWork
//
//  Created by Vladislav Gushin on 01/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct Author {
    var name: String
}

fileprivate struct Book {
    var isAvailable: Bool
    var name: String
    var author: Author
    var price: Int
}

//MARK : - Model transformations
fileprivate class BookDetailsVC: UIViewController {
    private let model: Book

    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.text = "\(model.name), by \(model.author.name)"
        let subtitleLabel = UILabel()
        if model.isAvailable {
            subtitleLabel.text = "Available now for \(model.price)"
        } else {
            subtitleLabel.text = "Coming soon"
        }
    }
}

//MARK: - Read-only structs

fileprivate struct BookDetailsViewModel {
    private let model: Book

    init(model: Book) {
        self.model = model
    }
}

extension BookDetailsViewModel {
    var title: String {
        return "\(model.name), by \(model.author.name)"
    }

    var subtitle: String {
        guard model.isAvailable else {
            return "Coming soon"
        }

        return "Available now for \(model.price)"
    }
}

//using view model
fileprivate class BookDetailsViewControllerV1: UIViewController {
    private let viewModel: BookDetailsViewModel

    init(viewModel: BookDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.text = viewModel.title

        let subtitleLabel = UILabel()
        subtitleLabel.text = viewModel.subtitle
    }
}

//MARK: - Performing updates
extension BookDetailsViewModel {
    func save(title: String, price: Int, isAvailable: Bool) {
        // Send the updated book data to the server
    }
}
