//
//  LogInViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/6/26.
//

import UIKit
import KeychainSwift

class LogInViewController: UIViewController {

    // MARK: - Properties

    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(named: "MainImage")

        return iconImageView
    }()

    private lazy var loginTextField: CustomTextField = {
        let loginTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        loginTextField.placeholder = "Email"
        loginTextField.backgroundColor = .systemGray6
        loginTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        loginTextField.textColor = .black
        loginTextField.autocapitalizationType = .none
        loginTextField.keyboardType = UIKeyboardType.default
        loginTextField.returnKeyType = UIReturnKeyType.done
        loginTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        loginTextField.layer.cornerRadius = 0
        loginTextField.layer.borderWidth = 0
        loginTextField.layer.borderColor = .none

        loginTextField.delegate = self

        loginTextField.addTarget(
            self,
            action: #selector(enableOrDisableLogInButton),
            for: .editingDidEnd
        )

        loginTextField.addTarget(
            self,
            action: #selector(disableLogInButton),
            for: .editingDidBegin
        )

        return loginTextField
    }()

    private lazy var passwordTextField: CustomTextField = {
        let passwordTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordTextField.textColor = .black
        passwordTextField.autocapitalizationType = .none
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.isSecureTextEntry = true

        passwordTextField.layer.cornerRadius = 0
        passwordTextField.layer.borderWidth = 0
        passwordTextField.layer.borderColor = .none

        passwordTextField.delegate = self

        passwordTextField.addTarget(
            self,
            action: #selector(enableOrDisableLogInButton),
            for: .editingDidEnd
        )

        passwordTextField.addTarget(
            self,
            action: #selector(disableLogInButton),
            for: .editingDidBegin
        )

        return passwordTextField
    }()

    private lazy var logInStackView: UIStackView = {
        let logInStackView = UIStackView()

        logInStackView.translatesAutoresizingMaskIntoConstraints = false
        logInStackView.axis = .vertical
        logInStackView.spacing = 0.5
        logInStackView.backgroundColor = .lightGray
        logInStackView.alignment = .fill
        logInStackView.distribution = .fillEqually

        logInStackView.clipsToBounds = true

        logInStackView.layer.borderColor = UIColor.lightGray.cgColor
        logInStackView.layer.borderWidth = 0.5
        logInStackView.layer.cornerRadius = 10

        logInStackView.addArrangedSubview(loginTextField)
        logInStackView.addArrangedSubview(passwordTextField)

        return logInStackView
    }()

    private lazy var logInButton: UIButton = {
        let logInButton = UIButton()

        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logInButton.backgroundColor = .main
        logInButton.alpha = 1.0

        logInButton.clipsToBounds = true

        logInButton.layer.cornerRadius = 10

        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)

        logInButton.isEnabled = false

        return logInButton
    }()

    private lazy var logInScrollView: UIScrollView = {
        let logInScrollView = UIScrollView()

        logInScrollView.translatesAutoresizingMaskIntoConstraints = false
        logInScrollView.showsHorizontalScrollIndicator = false
        logInScrollView.showsVerticalScrollIndicator = true
        logInScrollView.backgroundColor = .white

        return logInScrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white

        return contentView
    }()

    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()

        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("No profile", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signUpButton.backgroundColor = .main
        signUpButton.alpha = 1.0

        signUpButton.clipsToBounds = true

        signUpButton.layer.cornerRadius = 10

        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)

        signUpButton.isEnabled = true

        return signUpButton
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubviews()
        setupConstraints()

        CoreDataManager.shared.fetchObjectsFromCoreData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
    }

    // MARK: - Actions

    @objc func logInButtonTapped() {
        if let value = KeychainManager.shared.getValue(forKey: self.loginTextField.text ?? "") {
            if value == self.passwordTextField.text ?? "" {
                FirebaseAuthManager.shared.signIn(
                    email: self.loginTextField.text ?? "",
                    password: self.passwordTextField.text ?? ""
                )
            } else {
                let alertController = UIAlertController(
                    title: "Wrong login or password",
                    message: "Please try again",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                self.present(alertController, animated: true)
            }
        } else {
            FirebaseAuthManager.shared.signIn(
                email: self.loginTextField.text ?? "",
                password: self.passwordTextField.text ?? ""
            )
        }
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height

        logInScrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        logInScrollView.contentInset.bottom = 0.0
    }

    @objc func signUp() {
        let presentedController = SignUpViewController()

        self.present(presentedController, animated: true)
    }

    @objc func enableOrDisableLogInButton() {
        if (self.loginTextField.text != "" && self.passwordTextField.text != "") {
            logInButton.isEnabled = true
        } else {
            logInButton.isEnabled = false
        }
    }

    @objc func disableLogInButton() {
        logInButton.isEnabled = false
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            logInScrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            logInScrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            logInScrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            logInScrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            contentView.trailingAnchor.constraint(equalTo: logInScrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: logInScrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: logInScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: logInScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: logInScrollView.widthAnchor),

            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),

            logInStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInStackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 60),
            logInStackView.heightAnchor.constraint(equalToConstant: 100),

            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInButton.topAnchor.constraint(equalTo: logInStackView.bottomAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            signUpButton.heightAnchor.constraint(equalToConstant: 45),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func addSubviews() {
        self.view.addSubview(logInScrollView)

        logInScrollView.addSubview(contentView)

        contentView.addSubview(iconImageView)
        contentView.addSubview(logInStackView)
        contentView.addSubview(logInButton)
        contentView.addSubview(signUpButton)
    }

    private func setupView() {
        self.view.backgroundColor = .white
    }

    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate Protocol

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
