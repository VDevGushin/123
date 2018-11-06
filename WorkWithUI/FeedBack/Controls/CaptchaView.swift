//
//  CaptchaView.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 06/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import SupportLib

final class CaptchaView: UIView {
    @IBOutlet private weak var refresh: UIButton!
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var activity: UIActivityIndicatorView!

    private var isInRequest: Bool = false {
        didSet {
            self.setUI(isInLoad: isInRequest)
        }
    }

    private let serivce = CaptchaService()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        defer {
            self.refreshAction(self)
        }
        guard let view = self.loadFromNib(CaptchaView.self) else { return }
        self.addSubview(view)
        FeedBackStyle.indicator(self.activity)
        self.setUI()
    }

    @IBAction private func refreshAction(_ sender: Any) {
        guard !self.isInRequest else { return }
        self.isInRequest.toggle()

        self.serivce.getCaptcha { [weak self]res in
            DispatchQueue.main.async {
                if case Result.result(let image) = res {
                    self?.image.image = image
                }
                self?.isInRequest.toggle()
            }
        }
    }
}

fileprivate extension CaptchaView {
    func setUI(isInLoad: Bool = false) {
        if isInLoad {
            refresh.isEnabled = false
            refresh.isHidden = true
            activity.startAnimating()
            activity.isHidden = false
        } else {
            refresh.isEnabled = true
            refresh.isHidden = false
            activity.stopAnimating()
            activity.isHidden = true
        }
    }
}

