//
//  ETBSimpleTimer.swift
//  MyWork
//
//  Created by Vladislav Gushin on 02/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

class ETBSimpleTimer {
    enum Format {
        case full
        case short

        func getTimeString(time: Int, total: Int) -> String {
            switch self {
            case .full:
                return ("\(makeTime(seconds: time))/\(makeTime(seconds: total))")
            case .short:
                return ("\(makeTime(seconds: time))")
            }
        }

        private func makeTime(seconds: Int) -> String {
            let nMin = Int(seconds / 60) % 60
            let nSec = seconds % 60
            let sMin = "\(nMin < 10 ? "0\(nMin)" : "\(nMin)")"
            let sSec = "\(nSec < 10 ? "0\(nSec)" : "\(nSec)")"
            return "\(sMin):\(sSec)"
        }
    }
    private var format = Format.full
    typealias TimeValue = (text: String, remainingTime: Int)
    private var maxSec = 45 * 60
    private var totalSeconds = 45 * 60

    private var isStop = true
    private var timeDispatch: DispatchQueue?
    var eventUpdateTime: ((TimeValue) -> Void)? // remainingTime

    init(format: Format = Format.full) {
        self.format = format
    }

    func setupTime(min: Int) {
        self.maxSec = min * 60
        self.totalSeconds = min * 60
    }

    func start() {
        if isStop {
            timeDispatch = DispatchQueue.main
            isStop = false
            timer()
        }
    }

    func stop() {
        timeDispatch = nil
        isStop = true
    }

    private func timer() {
        timeDispatch?.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let sSelf = self, sSelf.isStop == false else {
                return
            }
            sSelf.timer()
            sSelf.maxSec -= 1
            if sSelf.maxSec <= 0 || sSelf.maxSec > sSelf.totalSeconds {
                let timeStr = sSelf.format.getTimeString(time: 0, total: sSelf.totalSeconds)
                sSelf.eventUpdateTime?((timeStr, 0))
                return
            }
            let timeString = sSelf.format.getTimeString(time: sSelf.maxSec, total: sSelf.totalSeconds)
            sSelf.eventUpdateTime?((timeString, sSelf.maxSec))
        }
    }
}

extension ETBSimpleTimer {
    func addTime(seconds time: Int) {
        self.maxSec += time
        self.totalSeconds += time
    }

    func setMode(new mode: Format) {
        self.format = mode
    }
}
