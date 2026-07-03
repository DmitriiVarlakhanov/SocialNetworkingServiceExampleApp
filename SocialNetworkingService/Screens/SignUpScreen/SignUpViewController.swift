//
//  SignUpViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/9/26.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties

    var genderValue: Int? = nil {
        didSet {
            if let genderValue = genderValue {
                if genderValue == 0 {
                    self.genderValueAsString = "male"

                    print(self.genderValueAsString)
                } else {
                    self.genderValueAsString = "female"

                    print(self.genderValueAsString)
                }
            }
        }
    }

    var genderValueAsString: String = ""

    var dateFromDatePicker: Date? = nil {
        didSet {
            if let dateFromDatePicker = dateFromDatePicker {
                let formatter = DateFormatter()

                formatter.dateFormat = "yyyy-MM-dd"

                dateFromDatePickerAsString = formatter.string(from: dateFromDatePicker)
            }
        }
    }

    var dateFromDatePickerAsString = ""

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
            action: #selector(enableOrDisableSignUpButton),
            for: .editingDidEnd
        )

        loginTextField.addTarget(
            self,
            action: #selector(disableSignUpButton),
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
            action: #selector(enableOrDisableSignUpButton),
            for: .editingDidEnd
        )

        passwordTextField.addTarget(
            self,
            action: #selector(disableSignUpButton),
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

    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()

        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signUpButton.backgroundColor = .main
        signUpButton.alpha = 1.0

        signUpButton.clipsToBounds = true

        signUpButton.layer.cornerRadius = 10

        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        signUpButton.isEnabled = false

        return signUpButton
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

    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = .main
        cancelButton.alpha = 1.0

        cancelButton.clipsToBounds = true

        cancelButton.layer.cornerRadius = 10

        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

        cancelButton.isEnabled = true

        return cancelButton
    }()

    private lazy var firstNameTextField: CustomTextField = {
        let firstNameTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        firstNameTextField.placeholder = "First name"
        firstNameTextField.backgroundColor = .systemGray6
        firstNameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        firstNameTextField.textColor = .black
        firstNameTextField.autocapitalizationType = .none
        firstNameTextField.keyboardType = UIKeyboardType.default
        firstNameTextField.returnKeyType = UIReturnKeyType.done
        firstNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        firstNameTextField.layer.cornerRadius = 0
        firstNameTextField.layer.borderWidth = 0
        firstNameTextField.layer.borderColor = .none

        firstNameTextField.delegate = self

        return firstNameTextField
    }()

    private lazy var lastNameTextField: CustomTextField = {
        let lastNameTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        lastNameTextField.placeholder = "Last name"
        lastNameTextField.backgroundColor = .systemGray6
        lastNameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lastNameTextField.textColor = .black
        lastNameTextField.autocapitalizationType = .none
        lastNameTextField.keyboardType = UIKeyboardType.default
        lastNameTextField.returnKeyType = UIReturnKeyType.done
        lastNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        lastNameTextField.layer.cornerRadius = 0
        lastNameTextField.layer.borderWidth = 0
        lastNameTextField.layer.borderColor = .none

        lastNameTextField.delegate = self

        return lastNameTextField
    }()

    private lazy var genderLabel: CustomUILabel = {
        let genderLabel = CustomUILabel(frame: .zero)

        genderLabel.text = "Gender"
        genderLabel.backgroundColor = .systemGray6
        genderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        genderLabel.textColor = .systemGray2
        genderLabel.textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        genderLabel.layer.cornerRadius = 0
        genderLabel.layer.borderWidth = 0
        genderLabel.layer.borderColor = .none

        return genderLabel
    }()

    private lazy var genderSegmentedControl: UISegmentedControl = {
        let genderSegmentedControl = UISegmentedControl(items: ["male", "female"])

        genderSegmentedControl.backgroundColor = .systemGray6
        genderSegmentedControl.selectedSegmentIndex = 0

        self.genderValue = genderSegmentedControl.selectedSegmentIndex

        genderSegmentedControl.addTarget(
            self,
            action: #selector(genderSegmentedControlValueChanged),
            for: .valueChanged
        )

        return genderSegmentedControl
    }()

    private lazy var genderStackView: UIStackView = {
        let genderStackView = UIStackView()

        genderStackView.translatesAutoresizingMaskIntoConstraints = false
        genderStackView.axis = .horizontal
        genderStackView.spacing = 0
        genderStackView.backgroundColor = .systemGray6
        genderStackView.alignment = .fill
        genderStackView.distribution = .fillEqually

        genderStackView.clipsToBounds = true

        genderStackView.addArrangedSubview(genderLabel)
        genderStackView.addArrangedSubview(genderSegmentedControl)

        return genderStackView
    }()

    private lazy var dateLabel: CustomUILabel = {
        let dateLabel = CustomUILabel(frame: .zero)

        dateLabel.text = "Birth date"
        dateLabel.backgroundColor = .systemGray6
        dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        dateLabel.textColor = .systemGray2
        dateLabel.textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        dateLabel.layer.cornerRadius = 0
        dateLabel.layer.borderWidth = 0
        dateLabel.layer.borderColor = .none

        return dateLabel
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()

        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .systemGray6

        self.dateFromDatePicker = datePicker.date

        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged),
            for: .valueChanged
        )

        return datePicker
    }()

    private lazy var dateStackView: UIStackView = {
        let dateStackView = UIStackView()

        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.axis = .horizontal
        dateStackView.spacing = 0
        dateStackView.backgroundColor = .lightGray
        dateStackView.alignment = .fill
        dateStackView.distribution = .fillEqually

        dateStackView.clipsToBounds = true

        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(datePicker)

        return dateStackView
    }()

    private lazy var hometownTextField: CustomTextField = {
        let hometownTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        hometownTextField.placeholder = "Hometown"
        hometownTextField.backgroundColor = .systemGray6
        hometownTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        hometownTextField.textColor = .black
        hometownTextField.autocapitalizationType = .none
        hometownTextField.keyboardType = UIKeyboardType.default
        hometownTextField.returnKeyType = UIReturnKeyType.done
        hometownTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        hometownTextField.layer.cornerRadius = 0
        hometownTextField.layer.borderWidth = 0
        hometownTextField.layer.borderColor = .none

        hometownTextField.delegate = self

        return hometownTextField
    }()

    private lazy var informationStackView: UIStackView = {
        let informationStackView = UIStackView()

        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        informationStackView.axis = .vertical
        informationStackView.spacing = 0.5
        informationStackView.backgroundColor = .lightGray
        informationStackView.alignment = .fill
        informationStackView.distribution = .fillEqually

        informationStackView.clipsToBounds = true

        informationStackView.layer.borderColor = UIColor.lightGray.cgColor
        informationStackView.layer.borderWidth = 0.5
        informationStackView.layer.cornerRadius = 10

        informationStackView.addArrangedSubview(firstNameTextField)
        informationStackView.addArrangedSubview(lastNameTextField)
        informationStackView.addArrangedSubview(genderStackView)
        informationStackView.addArrangedSubview(dateStackView)
        informationStackView.addArrangedSubview(hometownTextField)

        return informationStackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubviews()
        setupConstraints()
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

    @objc func signUpButtonTapped() {
        let key = self.loginTextField.text ?? ""

        let allKeys = KeychainManager.shared.getAllKeys()

        if !(allKeys.contains(key)) {
            FirebaseAuthManager.shared.createUser(
                firstName: firstNameTextField.text ?? "",
                lastName: lastNameTextField.text ?? "",
                email: self.loginTextField.text ?? "",
                password: self.passwordTextField.text ?? "",
                gender: self.genderValueAsString,
                birthDate: self.dateFromDatePickerAsString,
                hometown: self.hometownTextField.text ?? ""
            )
        } else {
            let alertController = UIAlertController(
                title: "Login is already in use",
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
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height

        logInScrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        logInScrollView.contentInset.bottom = 0.0
    }

    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func enableOrDisableSignUpButton() {
        if (self.loginTextField.text != "" && self.passwordTextField.text != "") {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
    }

    @objc func disableSignUpButton() {
        signUpButton.isEnabled = false
    }

    @objc func datePickerValueChanged() {
        self.dateFromDatePicker = self.datePicker.date

        self.presentedViewController?.dismiss(animated: true)
    }

    @objc func genderSegmentedControlValueChanged() {
        self.genderValue = self.genderSegmentedControl.selectedSegmentIndex
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

            informationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            informationStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            informationStackView.heightAnchor.constraint(equalToConstant: 250),

            logInStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInStackView.topAnchor.constraint(equalTo: informationStackView.bottomAnchor, constant: 50),
            logInStackView.heightAnchor.constraint(equalToConstant: 100),

            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.topAnchor.constraint(equalTo: logInStackView.bottomAnchor, constant: 16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cancelButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 45),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func addSubviews() {
        self.view.addSubview(logInScrollView)

        logInScrollView.addSubview(contentView)

        contentView.addSubview(informationStackView)
        contentView.addSubview(logInStackView)
        contentView.addSubview(cancelButton)
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

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
