//
//  MainViewController.swift
//  Test-vacc-AlexanderSuprun
//
//  Created by Alexander Suprun on 17.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainViewControllerProtocol: AnyObject {
    func setupBindings()
}


final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    // MARK: - Variables
    private var elements : [Category] = []
    private lazy var checkBoxAll : CheckboxAllButton = setupCheckBoxAllButton()
    private lazy var checkStackView : UIStackView = setupCheckStackView()
    private lazy var headLabel: UILabel = setupHeadLabel()
    private lazy var button: UIButton = setupButtonLabel()
    
    // MARK: - State
    private let disposeBag = DisposeBag()
    private let selectAllRelay = PublishRelay<Bool>()
    private let tappedAll = PublishRelay<Bool>()


    // MARK: - depency
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
        setupMainView()
    }
    
    
    // MARK: - Uptade Data
    func setupBindings() {
        viewModel.dataSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                self?.elements = model
                self?.updateCheckboxes()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - @obj func action
extension MainViewController {
    @objc func action() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
}

extension MainViewController {
    func setupMainView() {
        view.backgroundColor = .white
        setupLayout()
        updateCheckboxes()
    }
}

// MARK: - Сonnections checkBoxes
extension MainViewController {
    private func updateCheckboxes() {
        checkStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        let checkboxObservables: [Observable<(Bool, Bool)>] = elements.map { category in
            let checkbox = CheckboxButton(
                title: category.title,
                required: category.required,
                tappedAll: category.tappedOnSelectAll
            )
            checkStackView.addArrangedSubview(checkbox)
            
            // uptade tap on checkboxAll
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

        // if alltapped true then change CheckBoxAll state
        Observable.combineLatest(checkboxObservables) { states in
            let allTappedAll = states.allSatisfy { $0.0 }
            return allTappedAll
        }
        .bind(to: checkBoxAll.rx.isChecked)
        .disposed(by: disposeBag)
        
        
        // if required true then change button enabled
        Observable.combineLatest(checkboxObservables) { states in
            let allRequired = states.allSatisfy { $0.1 }
            return allRequired
        }
        .bind(to: button.rx.isEnabled)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(checkboxObservables) { states in
            let allRequired = states.allSatisfy { $0.1 }
            return allRequired ? UIColor.black : UIColor.gray
        }
        .bind(to: button.rx.backgroundColor)
        .disposed(by: disposeBag)
        

    }
}

// MARK: - Setup
extension MainViewController {
    func setupCheckStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        return stackView
    }
    
    func setupHeadLabel() -> UILabel {
        let label = UILabel()
        label.text = "CheckBox"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 32, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        return label
    }
    
    func setupButtonLabel() -> UIButton {
        let button = UIButton()
        button.setTitle(
            "Показать все",
            for: .normal
        )
        button.layer.cornerRadius = 8
        button.isEnabled = true
        button.backgroundColor = button.isEnabled ? .black : .gray
        button.addTarget(
            self,
            action: #selector(action),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        return button
    }
    
    func setupCheckBoxAllButton() -> CheckboxAllButton {
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
// MARK: - Contraints
extension MainViewController {
    func setupLayout() {
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
            button.topAnchor.constraint(equalTo: checkStackView.bottomAnchor, constant: 32),
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
