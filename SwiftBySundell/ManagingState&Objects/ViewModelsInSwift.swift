//
//  ViewModelsInSwift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 06/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK : - Моделька для работы
fileprivate struct Book: Hashable {
    struct Review {
        var title: String
        var text: String
        var numberOfStars: Int
    }
    var name: String
    var surname: String
    var isAvailable: Bool
    var price: String

    var hashValue: Int {
        return name.hashValue
    }
}

// MARK: - как было до введения шаблона
/*
 Предположим, что мы создаем приложение, которое позволяет пользователю просматривать и покупать книги.
 Один из наших контроллеров просмотра
 BookDetailsViewController - используется для отображения сведений о данной книге и в настоящее время получает информацию из введенного экземпляра книги (которая является одной из наших основных моделей):
 */

fileprivate class BookDetailsViewController: UIViewController {
    private let model: Book

    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
     Однако мы не можем просто визуализировать все свойства Book напрямую - некоторые из них требуют логики,
     специфичной для нашего представления, а некоторые требуют преобразований.
     Нет ничего неправильного с точки зрения пользовательского интерфейса, но это будет очень сложно проверить (поскольку нам нужно будет полагаться на частные методы контроллера),
     и наша реализация viewDidLoad также может стать большой и трудно следоваемой, если мы добавим еще несколько свойств или условий.
 */
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.text = "\(model.name), by \(model.surname)"
        //...
        // Setup subtitle label
        let subtitleLabel = UILabel()

        if model.isAvailable {
            subtitleLabel.text = "Available now for \(model.price)"
        } else {
            subtitleLabel.text = "Coming soon"
        }
        //...
    }

}

// MARK: - Введение шаблона

// MARK: Просто возможность использования нескольких viewmodels в одном контроллере
//Вместо этого давайте посмотрим, как мы можем инкапсулировать приведенную выше логику преобразования модели в модель представления.(models -> viewModels)
fileprivate struct BookDetailsViewModel {
    /*
     Обратите внимание на то, что основная модель книги хранится в закрытом режиме, что предотвратит доступ напрямую.
     Контроллер запросит у нашего  BookDetailsViewModel всю необходимую ему информацию, используя специальные свойства для каждого варианта использования.
     В рамках реализации каждого свойства мы можем использовать ту же логику преобразования модели, которую мы ранее выполняли в нашем контроллере.
 */
    private let model: Book
    init(model: Book) {
        self.model = model
    }

    var title: String {
        return "\(model.name), by \(model.surname)"
    }

    var subtitle: String {
        guard model.isAvailable else { return "Coming soon" }
        return "Available now for \(model.price)"
    }
}

//Еще одна viewmodel для редактирования чего либо
fileprivate class BookEditorViewModel {
    typealias Changes = (name: String, price: String, isAvailable: Bool)
    private var model: Book

    init(model: Book) {
        self.model = model
    }

    func update(with changes: Changes,
                then handler: @escaping (Book) -> Void) {
        // Apply changes
        var updatedModel = model
        updatedModel.name = changes.name
        updatedModel.price = changes.price
        updatedModel.isAvailable = changes.isAvailable
        self.model = updatedModel
    }
}

//Получаем такой controller:
fileprivate class BookDetailsViewControllerWithViewModel: UIViewController {
    private let viewModel: BookDetailsViewModel
    private let editViewModel: BookEditorViewModel

    init(viewModel: BookDetailsViewModel, editViewModel: BookEditorViewModel) {
        self.editViewModel = editViewModel
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
        //...

        let subtitleLabel = UILabel()
        subtitleLabel.text = viewModel.subtitle
        //...
    }
}

//Изменение значений через viewmodels
extension BookDetailsViewControllerWithViewModel {
    func save(title: String, price: String, isAvailable: Bool) {
        let changes = (title, price, isAvailable)
        self.editViewModel.update(with: changes) {
            print($0)
        }
    }
}

//MARK: - Two way
//Идея проста - у нас есть вью контролеер в котором есть кнжика и мы пытаемся достать для нее ревьеверов из менеджера
//у менеджера есть кучу книг и к каждой книге есть несколько ревьюверов
//При изменении списка мы оповещаем подписчиков

fileprivate class BookReviewManager {
    class Observer: Hashable, Equatable {
        let id: Int
        let handler: ((BookReviewsViewModel, [Book.Review]) -> Void)?
        let viewModel: BookReviewsViewModel
        let bookName: String?
        var hashValue: Int { return id }

        init(viewModel: BookReviewsViewModel, bookName: String? = nil, handler: ((BookReviewsViewModel, [Book.Review]) -> Void)? = nil) {
            self.id = ObjectIdentifier(viewModel).hashValue
            self.bookName = bookName
            self.viewModel = viewModel
            self.handler = handler
        }

        static func == (lhs: Observer, rhs: Observer) -> Bool {
            return lhs.id == rhs.id
        }
    }
    var source = [String: [Book.Review]]()
    private var observations = Set<Observer>()

    func addObserver(_ viewModel: BookReviewsViewModel) {
        let observer = Observer(viewModel: viewModel)
        self.observations.remove(observer)
    }

    func addObserver(_ viewModel: BookReviewsViewModel, forBookWithName: String, closure: @escaping (BookReviewsViewModel, [Book.Review]) -> Void) {
        self.observations.insert(Observer(viewModel: viewModel, bookName: forBookWithName, handler: closure))
    }

    @discardableResult
    func add(_ review: Book.Review, forBookWithName: String) -> Bool {
        self.source[forBookWithName]?.append(review)
        guard let bookReviews = self.source[forBookWithName] else { return false }
        let observers = self.observations.filter { $0.bookName == forBookWithName }
        observers.forEach {
            let viewModel = $0.viewModel
            $0.handler?(viewModel, bookReviews)
        }
        return true
    }

    func reviewsForBook(withName: String) -> [Book.Review] {
        guard let reviews = self.source[withName] else { return [] }
        return reviews
    }
}

fileprivate class BookReviewsViewModel {
    var updateHandler: () -> Void = { }
    var numberOfReviews: Int { return reviews.count }

    private let book: Book
    private let manager: BookReviewManager
    private var reviews: [Book.Review]

    init(book: Book, manager: BookReviewManager) {
        self.book = book
        self.manager = manager
        self.reviews = manager.reviewsForBook(withName: book.name)
        self.startManagerObservation()
    }

    deinit { self.endManagerObservation() }

    func startManagerObservation() {
        manager.addObserver(self, forBookWithName: book.name) { viewModel, reviews in
            viewModel.reviews = reviews
            viewModel.updateHandler()
        }
    }

    func endManagerObservation() { }

    func titleForReview(at index: Int) -> String {
        let review = reviews[index]
        let stars = String(repeating: "⭐️", count: review.numberOfStars)
        return "\(stars) \"\(review.title)\""
    }

    func addReview(withTitle title: String,
                   text: String,
                   numberOfStars: Int) {
        let review = Book.Review(
            title: title,
            text: text,
            numberOfStars: numberOfStars
        )
        self.manager.add(review, forBookWithName: book.name)
    }
}

fileprivate class BookReviewsViewController: UITableViewController {
    private var titleView: SpecialView!
    private var textView: SpecialView!
    private var starsView: SpecialView!

    private let viewModel: BookReviewsViewModel
    init(viewModel: BookReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /*Используя вышеизложенное, давайте реализуем наш контроллер представлений - начиная с включения автоматических обновлений пользовательского интерфейса,
     привязывая метод reloadData нашего табличного представления к свойству updateHandler нашего представления модели, что приведет к его вызову при каждом добавлении или удалении обзора*/
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateHandler = tableView.reloadData
    }

    func submitReview() {
        viewModel.addReview(withTitle: titleView.text,
                            text: textView.text,
                            numberOfStars: starsView.value)
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfReviews
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "review", for: indexPath)

        cell.textLabel?.text = viewModel.titleForReview(at: indexPath.row)
        cell.detailTextLabel?.text = viewModel.titleForReview(at: indexPath.row)

        return cell
    }
}

fileprivate class SpecialView: UIView {
    let text: String = ""
    let value: Int = 4
}

// MARK : - MVVM with delegate vs noDelegate

@objc fileprivate protocol ViewModelWithClosureDelegate: class {
    @objc optional func updateHandler0()
    @objc optional func updateHandler1()
    @objc optional func updateHandler2()
    @objc optional func updateHandler3()
    @objc optional func updateHandler4()
    @objc optional func updateHandler5()
}

fileprivate class ViewModelWithClosure {
    weak var delegate: ViewModelWithClosureDelegate?

    var updateHandler0: () -> Void = { }
    var updateHandler1: () -> Void = { }
    var updateHandler2: () -> Void = { }
    var updateHandler3: () -> Void = { }
    var updateHandler4: () -> Void = { }
    var updateHandler5: () -> Void = { }

    func test() {
        self.updateHandler0()
        self.delegate?.updateHandler0?()
        self.updateHandler1()
        self.delegate?.updateHandler1?()
        self.updateHandler2()
        self.delegate?.updateHandler2?()
        self.updateHandler3()
        self.delegate?.updateHandler3?()
        self.updateHandler4()
        self.delegate?.updateHandler4?()
        self.updateHandler5()
        self.delegate?.updateHandler5?()
    }
}

fileprivate class TestViewController: UIViewController {
    private let viewModel1: ViewModelWithClosure
    init(viewModel1: ViewModelWithClosure) {
        self.viewModel1 = viewModel1
        super.init(nibName: nil, bundle: nil)
        self.subscribe()

        self.viewModel1.delegate = self
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func subscribe() {
        self.viewModel1.updateHandler0 = { [weak self] in self?.make() }
        self.viewModel1.updateHandler1 = { [weak self] in self?.make() }
        self.viewModel1.updateHandler2 = { [weak self] in self?.make() }
        self.viewModel1.updateHandler3 = { [weak self] in self?.make() }
        self.viewModel1.updateHandler4 = { [weak self] in self?.make() }
        self.viewModel1.updateHandler5 = { [weak self] in self?.make() }
    }

    func make() { }
}

extension TestViewController: ViewModelWithClosureDelegate { }

