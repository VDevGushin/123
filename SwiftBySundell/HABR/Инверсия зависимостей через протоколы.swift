//
//  Dependency Injection in Swift with Protocols.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 11/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate class HKHealthStore { }

fileprivate protocol HasUserDefaults {
    var userDefaults: UserDefaults { get }
}

fileprivate protocol HasUrlSession {
    var session: URLSession { get }
}

fileprivate protocol HasHealthStore {
    var store: HKHealthStore { get }
}

fileprivate struct Dependencies: HasUserDefaults, HasUrlSession, HasHealthStore {
    let userDefaults: UserDefaults
    let session: URLSession
    let store: HKHealthStore

    init(
        userDefaults: UserDefaults = .standard,
        session: URLSession = .shared,
        store: HKHealthStore = .init()
    ) {
        self.userDefaults = userDefaults
        self.session = session
        self.store = store
    }
}

fileprivate class ViewController: UIViewController {
    typealias Dependencies = HasUserDefaults & HasUrlSession

    private let userDefaults: UserDefaults
    private let session: URLSession

    init(dependencies: Dependencies) {
        userDefaults = dependencies.userDefaults
        session = dependencies.session
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - mock
extension Dependencies {
    class MockedUrlSession: URLSession { }
    class MockedHealthStore: HKHealthStore { }

    static var mocked: Dependencies {
        return Dependencies(
            userDefaults: UserDefaults(),
            session: MockedUrlSession(),
            store: MockedHealthStore()
        )
    }
}

// MARK: - Abstract Factory

fileprivate class HealthService {
    private let store: HKHealthStore
    init(store: HKHealthStore) {
        self.store = store
    }
}
fileprivate class SettingsService {
    private let userDefaults: UserDefaults
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

fileprivate protocol DependencyFactory {
    func makeHealthService() -> HealthService
    func makeSettingsSevice() -> SettingsService
}

fileprivate struct Dependencies1 {
    private let healthStore: HKHealthStore
    private let userDefaults: UserDefaults

    init(
        healthStore: HKHealthStore = .init(),
        userDefaults: UserDefaults = .standard
    ) {
        self.healthStore = healthStore
        self.userDefaults = userDefaults
    }
}

extension Dependencies1: DependencyFactory {
    func makeHealthService() -> HealthService {
        return HealthService(store: healthStore)
    }

    func makeSettingsSevice() -> SettingsService {
        return SettingsService(userDefaults: userDefaults)
    }
}

/// Пример работы с протоклом фабрики контроллеров
/*protocol ViewControllerFactory {
    func makeCalendarViewController() -> CalendarViewController
    func makeDayViewController() -> DayViewController
    func makeSettingsViewController() -> SettingsViewController
}

extension Dependencies: ViewControllerFactory {
    func makeCalendarViewController() -> CalendarViewController {
        return CalendarViewController(
            healthService: makeHealthService()
        )
    }
    
    func makeDayViewController() -> DayViewController {
        return DayViewController(
            healthService: makeHealthService(),
            settingsService: makeSettingsSevice()
        )
    }
    
    func makeSettingsViewController() -> SettingsViewController {
        return SettingsViewController(
            settingsService: makeSettingsSevice()
        )
    }
}*/
