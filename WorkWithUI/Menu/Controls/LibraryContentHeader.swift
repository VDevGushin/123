//
//  LibraryContentHeader.swift
//  WorkWithUI
//
//  Created by Vladislav Gushin on 26/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol LibraryContentHeaderDelegate: class {
    func enterText()
}

class LibraryContentHeader: UIView {
    weak var delegate: LibraryContentHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        guard let view = self.loadFromNib(LibraryContentHeader.self) else { return }
        self.addSubview(view)
    }

    @IBAction func enterTextAction(_ sender: Any) {
        self.delegate?.enterText()
    }
}
