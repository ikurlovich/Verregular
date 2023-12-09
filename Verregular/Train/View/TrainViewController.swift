//
//  TrainViewController.swift
//  Verregular
//
//  Created by Илья Курлович on 05.12.2023.
//

import UIKit
import SnapKit

final class TrainViewController: UIViewController {
    
    // MARK: - GUI Variables
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var countVerbsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var scoreVerbsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var pastSimpleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Simple"
        
        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Past Participle"
        
        return label
    }()
    
    private lazy var pastSimpleTextField: UITextField = {
        let field = UITextField()
        
        field.borderStyle = .roundedRect
        field.delegate = self
        
        return field
    }()
    
    private lazy var participleTextField: UITextField = {
        let field = UITextField()
        
        field.borderStyle = .roundedRect
        field.delegate = self
        
        return field
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray5
        button.setTitle("Check".localized, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray5
        button.setTitle("Skip".localized, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        
        return button
    }()
    
    
    // MARK: - Properties
    private var score = 0
    private let edgeInsets = 30
    private let dataSource = IrregularVerbs.shared.selectedVerbs
    private var currentVerb: Verb? {
        guard dataSource.count > count else { return nil }
        return dataSource[count]
    }
    private var count = 0 {
        didSet {
            infinitiveLabel.text = currentVerb?.infinitive
            pastSimpleTextField.text = ""
            participleTextField.text = ""
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Train verbs".localized
        setupUI()
        hideKeyboardWhenTappedAround()
        showLabelInfinitiVerbs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scoreVerbsLabel.text = "Score".localized + ": \(score)"
        countVerbsLabel.text = "Verbs".localized + ": \(count + 1)/\(dataSource.count)"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Private methods
    @objc
    private func skipAction() {
        let alertController = UIAlertController(title: "Right answer".localized, message: "Past Simple: \(currentVerb?.pastSimple ?? "")" + "\n" + "Past Participle: \(currentVerb?.participle ?? "")", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if self.currentVerb?.infinitive == self.dataSource.last?.infinitive {
                self.checkButton.backgroundColor = .systemGray5
                self.checkButton.setTitle("Check".localized, for: .normal)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.count += 1
                self.checkButton.backgroundColor = .systemGray5
                self.checkButton.setTitle("Check".localized, for: .normal)
            }
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showCheckAlert() {
        let alertController = UIAlertController(title: "The training is over".localized, message: "Your account of the relevant responses".localized + ": \(score)", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showLabelInfinitiVerbs() {
        if dataSource.first?.infinitive == nil {
            infinitiveLabel.text = "Choose the verbs".localized
        } else {
            infinitiveLabel.text = dataSource.first?.infinitive
        }
    }
    
    @objc
    private func checkAction() {
        if checkAnswer() {
            if currentVerb?.infinitive == dataSource.last?.infinitive {
                score += 1
                showCheckAlert()
            } else {
                count += 1
                score += 1
                checkButton.backgroundColor = .systemGray5
                checkButton.setTitle("Check".localized, for: .normal)
            }
        } else {
            checkButton.backgroundColor = .red
            checkButton.setTitle("Try again".localized, for: .normal)
        }
    }
    
    private func checkAnswer() -> Bool {
        pastSimpleTextField.text?.lowercased() == currentVerb?.pastSimple.lowercased() &&
        participleTextField.text?.lowercased() == currentVerb?.participle.lowercased()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            countVerbsLabel,
            scoreVerbsLabel,
            infinitiveLabel,
            pastSimpleLabel,
            pastSimpleTextField,
            participleLabel,
            participleTextField,
            checkButton,
            skipButton])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        countVerbsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(infinitiveLabel.snp.top).offset(-50)
            make.leading.equalToSuperview().inset(30)
        }
        
        scoreVerbsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(infinitiveLabel.snp.top).offset(-50)
            make.trailing.equalToSuperview().inset(30)
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(60)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleTextField.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleTextField.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleTextField.snp.makeConstraints { make in
            make.top.equalTo(participleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(participleTextField.snp.bottom).offset(100)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(checkButton.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TrainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pastSimpleTextField.isFirstResponder {
            participleTextField.becomeFirstResponder()
        } else {
            scrollView.endEditing(true)
        }
        
        return true
    }
}

// MARK: - Keyboard events
private extension TrainViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = frame.height + 50
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero - 50
    }
    
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
