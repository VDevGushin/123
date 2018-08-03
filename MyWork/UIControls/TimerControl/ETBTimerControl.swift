//
//  ETBTimerControl.swift
//  MyWork
//
//  Created by Vladislav Gushin on 02/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@IBDesignable
class ETBTimerControl: UIView {
    private let mode = ETBSimpleTimer.Format.full
    private let timer = ETBSimpleTimer(format: ETBSimpleTimer.Format.full)
    @IBOutlet weak var timeText: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        guard let view = self.loadFromNib(ETBTimerControl.self) else { return }
        self.addSubview(view)
        self.timer.eventUpdateTime = { [weak self] result in
            self?.timeText.text = result.text
        }
    }

    @IBAction func addTime(_ sender: Any) {
    }

    func addTime(seconds: Int) {
        self.timer.addTime(seconds: seconds)
    }

    func setupTime(min: Int, format: ETBSimpleTimer.Format, start: Bool = true) {
        self.timer.setupTime(min: min)
        self.timer.setMode(new: format)
        if start {
            self.timer.start()
        }
    }

    func start() {
        self.timer.start()
    }

    func stop() {
        self.timer.stop()
    }
}
