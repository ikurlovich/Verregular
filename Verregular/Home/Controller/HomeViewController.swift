//
//  HomeViewController.swift
//  Verregular
//
//  Created by Илья Курлович on 03.12.2023.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Verregular".uppercased()
        label.font = .boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Select verbs".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(gotoSelectViewController), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Train verbs".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(gotoTrainViewController), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Properties
    private let cornerRadius: CGFloat = 20
    private let heightButtons: CGFloat = 80

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Private methods
    @objc
    private func gotoSelectViewController() {
        navigationController?.pushViewController(SelectVerbsViewController(), animated: true)
    }
    
    @objc
    private func gotoTrainViewController() {
        navigationController?.pushViewController(TrainViewController(), animated: true)
    }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(firstButton)
        view.addSubview(secondButton)
        
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        firstButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        firstButton.heightAnchor.constraint(equalToConstant: heightButtons).isActive = true
        firstButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: firstButton.topAnchor, constant: -80).isActive = true
        
        secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 40).isActive = true
        secondButton.heightAnchor.constraint(equalToConstant: heightButtons).isActive = true
        secondButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
    }
}

