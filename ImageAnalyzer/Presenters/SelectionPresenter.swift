//
//  SelectionPresenter.swift
//  ImageAnalyzer
//
//  Created by Vladislav Gushin on 30/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//
import UIKit

struct SelectionPresenter {
    typealias ActionClosure = () -> Void
    typealias ActionModel = (title: String, action: ActionClosure)
    typealias Style = UIAlertController.Style
    weak var senderView: UIView?
    let actions: [ActionModel]
    let message: String
    let title: String
    let style: Style
    
    func present(in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: self.style)
        
        for action in actions {
            let newAlertAction = UIAlertAction(title: action.title, style: .default) { _ in
                action.action()
            }
            alert.addAction(newAlertAction)
        }
        
        if let popoverController = alert.popoverPresentationController, let view = self.senderView {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        let rejectAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(rejectAction)
        viewController.present(alert, animated: true)
    }
}
