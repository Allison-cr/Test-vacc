//
//  MainViewModel.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import RxSwift
import RxCocoa
import UIKit

// MARK: - MainViewControllerProtocol

protocol MainViewModelProtocol: AnyObject {
    func loadData()
}

// MARK: - MainViewControllerProtocol

final class MainViewModel: MainViewModelProtocol {
    
    // MARK: - Properties

    weak var coordinator: MainCoordinator?
    private weak var viewController: MainViewController?

    // MARK: - State
    
    let dataSubject = PublishSubject<[Category]>()

    // MARK: - loading data from local JSON
    func loadData() {
        if let model = DataLoader.loadCategories() {
            dataSubject.onNext(model)
        } else {
            print("Не удалось загрузить данные")
        }
    }
}
