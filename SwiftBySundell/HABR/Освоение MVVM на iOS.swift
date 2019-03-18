//
//  Освоение MVVM на iOS.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 18/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit
import Bond

/*В Интернете есть множество публикаций об архитектурах приложений в мире разработки для iOS. Сегодня я покажу несколько советов по использованию архитектуры MVVM при разработке приложений для iOS. Я не собираюсь показывать другие архитектуры, если они вам нужны, есть отличный пост. Основной проблемой Apple MVC является смешанная ответственность, которая приводит к появлению некоторых видов проблем, таких как Massive-View-Controller.
 
 Почему МВВМ?
 
 Мы должны согласиться с тем, что UIViewController является основным компонентом Apple SDK для iOS, и все действия запускаются и строятся в рамках этой сущности. Несмотря на название, это больше View, чем классический контроллер (или Presenter) из MVC (или MVP), из-за обратных вызовов, таких как viewDidLoad, viewWillLayoutSubviews и других методов, связанных с представлением. Вот почему мы должны игнорировать ключевое слово Controller в имени и использовать его в качестве View, где роль реального Controller принимает ViewModel.
 
 ViewModel - это полное представление данных представления. Каждое представление должно содержать только один экземпляр ViewModel. Как правило, ViewModel использует менеджер для извлечения данных и преобразования их в необходимый формат. Давайте погрузимся в примеры:*/
fileprivate struct Item { }
fileprivate struct DataManager {
    func fetchItems(then: ([Item]?, Error?) -> Void) {

    }
}

fileprivate class ItemsViewModel {
    let items = Observable<[Item]>([])
    let error = Observable<Error?>(nil)
    let refreshing = Observable<Bool>(false)

    private let dataManager: DataManager

    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }

    func fetch() {
        refreshing.value = true
        dataManager.fetchItems { [weak self] (items, error) in
            self?.items.value = items ?? []
            self?.error.value = error
            self?.refreshing.value = false
        }
    }
}


class ItemsViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: ItemsViewModel
    private let activityIndicator = UIActivityIndicatorView()

    fileprivate init(viewModel: ItemsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        bindViewModel()
        viewModel.fetch()
    }
    
    func bindViewModel() {
        viewModel.refreshing.bind(to: activityIndicator.reactive.isAnimating)
        viewModel.items.bind(to: self) { strongSelf, _ in
            strongSelf.tableView.reloadData()
        }
    }
}
