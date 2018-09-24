//
//  SubclassFreeViewControllers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 24/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct Event {
    let title: String
    let location: String
    let image: UIImage
}

// MARK: - Bad variant
fileprivate class EventDetailsViewController: UIViewController {
    private let event: Event

    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        //...

        let subtitleLabel = UILabel()
        //...

        let imageView = UIImageView()
        //...
    }
}

// MARK: - work variant

fileprivate class EventDetailsView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let imageView = UIImageView()
}


fileprivate class EventHeaderView: UIView {
    let titleLabel = UILabel()
}

fileprivate class TestFactory {
    let navigationController = UINavigationController(nibName: nil, bundle: nil)
    func factoryMethod() {
        let vc = UIViewController(nibName: nil, bundle: nil)
        vc.view = EventDetailsView()
        navigationController.pushViewController(vc, animated: true)
    }
}

// MARK: - Factory methods
fileprivate class EventViewControllerFactory {
    func makeDetailViewController(for event: Event) -> UIViewController {
        let view = EventDetailsView()
        view.titleLabel.text = event.title
        view.subtitleLabel.text = event.location
        view.imageView.image = event.image
        let vc = UIViewController()
        vc.view = view
        return vc
    }
}

// MARK: - Presenters
fileprivate struct EventDetailsPresenter {
    let event: Event
    let factory: EventViewControllerFactory
    func present(in container: UIViewController) {
        let vc = factory.makeDetailViewController(for: event)
        container.present(vc, animated: true)
    }
}

// MARK: - Using on vc
fileprivate class TestingVC: UIViewController {
    let containter = UIViewController(nibName: nil, bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView = EventHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        containter.view.addSubview(headerView)
        
        let detailView = EventDetailsView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        containter.view.addSubview(detailView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containter.view.topAnchor),
            headerView.widthAnchor.constraint(equalTo: containter.view.widthAnchor),
            headerView.heightAnchor.constraint(equalTo: containter.view.heightAnchor, multiplier: 0.3),
            detailView.widthAnchor.constraint(equalTo: containter.view.widthAnchor),
            detailView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            detailView.bottomAnchor.constraint(equalTo: containter.view.bottomAnchor)
            ])
    }
}
