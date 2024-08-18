//
//  MainViewModel.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import RxSwift
import RxCocoa
import UIKit

protocol MainViewModelProtocol: AnyObject {
    func loadData()
}

final class MainViewModel: MainViewModelProtocol {
    weak var coordinator: MainCoordinator?
    private weak var viewController: MainViewController?

    let dataSubject = PublishSubject<[Category]>()
    
    
    
    private let enabledButtonColor: UIColor = .black
    private let disabledButtonColor: UIColor = .lightGray
    
    func loadData() {
            if let model = DataLoader.loadCategories() {
                dataSubject.onNext(model)
            } else {
                print("Не удалось загрузить данные")
            }
        }
    

}
