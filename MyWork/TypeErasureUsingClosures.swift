//
//  TypeErasureUsingClosures.swift
//  MyWork
//
//  Created by Vladislav Gushin on 17/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import Unbox

class MyModel { }

class ModelLoadingError {
    static func unboxingFailed(_ error: Error) -> Error {
        return error
    }
}
protocol Requestable {
    static var requestURL: URL { get set }
}

protocol ModelLoading {
    associatedtype Model
    func load(completionHandler: (Result<Model>) -> Void)
}

class ModelLoader < T: Unboxable & Requestable >: ModelLoading {
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func load(completionHandler: (Result<T>) -> Void) {
        networkService.loadData(from: T.requestURL) { data in
            do {
                try completionHandler(Result.result(unbox(data: data)))
            } catch {
                let error = ModelLoadingError.unboxingFailed(error)
                completionHandler(.error(error))
            }
        }
    }
}

//Используем через DI
fileprivate class TestViewController: UIViewController {
    

    init<T: ModelLoading>(modelLoader: T) where T.Model == MyModel {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AnyModelLoader<T>: ModelLoading {
    typealias CompletionHandler = (Result<T>) -> Void
    
    private let loadingClosure: (CompletionHandler) -> Void
    
    init<L: ModelLoading>(loader: L) where L.Model == T {
        loadingClosure = loader.load
    }
    
    func load(completionHandler: CompletionHandler) {
        loadingClosure(completionHandler)
    }
}
//using view controller with any model loader
fileprivate class Test2ViewController: UIViewController {
    private let modelLoader: AnyModelLoader<MyModel>
    
    init<T: ModelLoading>(modelLoader: T) where T.Model == MyModel {
        self.modelLoader = AnyModelLoader(loader: modelLoader)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Еще меньше кода
fileprivate class Test3ViewController: UIViewController {
    private let loadModel: ((Result<MyModel>) -> Void) -> Void
    
    init<T: ModelLoading>(modelLoader: T) where T.Model == MyModel {
        loadModel = modelLoader.load
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadModel { result in
            switch result {
            case .result( _): break
               // render(model)
            case .error( _): break
               // render(error)
            }
        }
    }
}




