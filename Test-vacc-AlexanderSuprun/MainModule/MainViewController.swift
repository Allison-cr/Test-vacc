//
//  MainViewController.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

protocol IMainViewController: AnyObject {
//    func viewReady(model: [Category])
}


final class MainViewController: UIViewController {
    
    // MARK: - Variables
    private var elements = MokData().category()
    private lazy var checkBoxAll : CheckboxAllButton = settingCheckBoxAll()
    private lazy var checkStackView : UIStackView = settingCheckVstack()
    private lazy var headLabel: UILabel = settingHeadLabel()
    private lazy var button: UIButton = settingButtonLabel()
    private let disposeBag = DisposeBag()
    private let selectAllRelay = PublishRelay<Bool>()
    private let tappedAll = PublishRelay<Bool>()

    // MARK: - depency
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        settingMainView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - obj func action
extension MainViewController {
    @objc func pushViewController() {
        viewModel.goNext()
    }
}


extension MainViewController {
    func settingMainView() {
        view.backgroundColor = .cyan
        settingLayout()
        updateCheckboxes()
    }
    

    private func updateCheckboxes() {
        checkStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let checkboxObservables: [Observable<(Bool, Bool)>] = elements.map { category in
        let checkbox = CheckboxButton(
            title: category.title,
            required: category.reqired,
            tappedAll: category.tapped_on_select_all
        )
            checkStackView.addArrangedSubview(checkbox)
             
            // MARK: - uptade tap on checkboxAll
            selectAllRelay
                .subscribe(onNext: { [weak checkbox] state in
                    if checkbox?.tappedAll == true {
                        checkbox?.updateState(isChecked: state)
                    }
                })
                .disposed(by: disposeBag)
            
                // Combine state
                let combinedState = Observable.combineLatest(
                    checkbox.stateTappedOnSelectAll.asObservable(),
                    checkbox.stateRequired.asObservable()
                )
                return combinedState
            }
        
 
        
        
        // MARK: - если выбраны нужные чекбоксы для тап алл то меняет тап алл состояние
        // MARK: - work
       // if alltapped true then
        Observable.combineLatest(checkboxObservables) { states in
            let allTappedAll = states.allSatisfy { $0.0 } 
            return allTappedAll
        }
        .bind(to: checkBoxAll.rx.isChecked)
        .disposed(by: disposeBag)
        
        
        // MARK: - если выбраны нужные чекбоксы для required то disable button
        // MARK: - work
        Observable.combineLatest(checkboxObservables) { states in
            // Возвращаем общее состояние для checkBoxAll
            let allRequired = states.allSatisfy { $0.1 }
            return allRequired
        }
        .bind(to: button.rx.isEnabled)
        .disposed(by: disposeBag)
    
            
      }




    // MARK: - contraints
    func settingLayout() {
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            headLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            headLabel.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            checkStackView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 12),
            checkStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            checkStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: checkStackView.bottomAnchor, constant: 12),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            button.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        
       
        NSLayoutConstraint.activate([
            checkBoxAll.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 12),
            checkBoxAll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            checkBoxAll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            checkBoxAll.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}


    // MARK: - Setup settings
extension MainViewController {
    func settingCheckVstack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        return stackView
    }
    
    func settingHeadLabel() -> UILabel {
        let label = UILabel()
        label.text = "CheckBox"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func settingButtonLabel() -> UIButton {
        let button = UIButton()
        button.setTitle(
            "Показать все",
            for: .normal
        )
        button.backgroundColor = .gray
        button.isEnabled = true
        button.addTarget(
            self,
            action: #selector(pushViewController),
            for: .touchUpInside
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    func settingCheckBoxAll() -> CheckboxAllButton {
        let checkBox = CheckboxAllButton()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.rx.tap
            .map{ checkBox.isSelected }
            .bind(to: selectAllRelay)
            .disposed(by: disposeBag)
        view.addSubview(checkBox)
        return checkBox
    }

}

