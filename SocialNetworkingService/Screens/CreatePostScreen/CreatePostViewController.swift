//
//  CreatePostViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 7/7/26.
//

import UIKit
import Photos
import PhotosUI

class CreatePostViewController: UIViewController {

    // MARK: - Properties

    weak var previousController: UIViewController?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 10

        return imageView
    }()

    private lazy var choseImageButton: UIButton = {
        let choseImageButton = UIButton()

        choseImageButton.translatesAutoresizingMaskIntoConstraints = false
        choseImageButton.setTitle("Load image", for: .normal)
        choseImageButton.setTitleColor(.white, for: .normal)
        choseImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        choseImageButton.backgroundColor = .main
        choseImageButton.alpha = 1.0

        choseImageButton.clipsToBounds = true

        choseImageButton.layer.cornerRadius = 10

        choseImageButton.addTarget(self, action: #selector(choseImageButtonTapped), for: .touchUpInside)

        return choseImageButton
    }()

    private lazy var titleTextField: CustomTextField = {
        let titleTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.placeholder = "Title"
        titleTextField.backgroundColor = .systemGray6
        titleTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleTextField.textColor = .black
        titleTextField.autocapitalizationType = .none
        titleTextField.keyboardType = UIKeyboardType.default
        titleTextField.returnKeyType = UIReturnKeyType.done
        titleTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        titleTextField.layer.cornerRadius = 10

        titleTextField.delegate = self

        return titleTextField
    }()

    private lazy var bodyTextField: CustomTextField = {
        let bodyTextField = CustomTextField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        bodyTextField.translatesAutoresizingMaskIntoConstraints = false

        bodyTextField.placeholder = "Body"
        bodyTextField.backgroundColor = .systemGray6
        bodyTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bodyTextField.textColor = .black
        bodyTextField.autocapitalizationType = .none
        bodyTextField.keyboardType = UIKeyboardType.default
        bodyTextField.returnKeyType = UIReturnKeyType.done
        bodyTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        bodyTextField.layer.cornerRadius = 10

        bodyTextField.delegate = self

        return bodyTextField
    }()

    private lazy var createPostButton: UIButton = {
        let createPostButton = UIButton()

        createPostButton.translatesAutoresizingMaskIntoConstraints = false
        createPostButton.setTitle("Create new post", for: .normal)
        createPostButton.setTitleColor(.white, for: .normal)
        createPostButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createPostButton.backgroundColor = .main
        createPostButton.alpha = 1.0

        createPostButton.clipsToBounds = true

        createPostButton.layer.cornerRadius = 10

        createPostButton.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)

        return createPostButton
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

        return cancelButton
    }()

    private lazy var createPostScrollView: UIScrollView = {
        let createPostScrollView = UIScrollView()

        createPostScrollView.translatesAutoresizingMaskIntoConstraints = false
        createPostScrollView.showsHorizontalScrollIndicator = false
        createPostScrollView.showsVerticalScrollIndicator = true
        createPostScrollView.backgroundColor = .white

        return createPostScrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white

        return contentView
    }()

    // MARK: - Initialization

    init(previousController: UIViewController?) {
        self.previousController = previousController

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    @objc func createPostButtonTapped() {
        if let previousController = previousController as? ProfileViewController {
            let createdPost = CreatedPostModel(
                id: UUID().uuidString,
                image: self.imageView.image ?? UIImage(),
                title: self.titleTextField.text ?? "",
                body: self.bodyTextField.text ?? "",
                likes: 0,
                views: 0
            )

            CreatedPostsManager.shared.createdPosts.append(createdPost)

            previousController.profileTableView.reloadData()

            self.dismiss(animated: true)
        }
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height

        createPostScrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        createPostScrollView.contentInset.bottom = 0.0
    }

    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func choseImageButtonTapped() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())

        let filter = PHPickerFilter.images

        configuration.filter = filter

        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self

        self.present(imagePicker, animated: true)
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            createPostScrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            createPostScrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            createPostScrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            createPostScrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            contentView.trailingAnchor.constraint(equalTo: createPostScrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: createPostScrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: createPostScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: createPostScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: createPostScrollView.widthAnchor),

            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),

            bodyTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            bodyTextField.heightAnchor.constraint(equalToConstant: 50),

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            imageView.topAnchor.constraint(equalTo: bodyTextField.bottomAnchor, constant: 16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            choseImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            choseImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            choseImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 70),
            choseImageButton.heightAnchor.constraint(equalToConstant: 40),

            createPostButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            createPostButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            createPostButton.topAnchor.constraint(equalTo: choseImageButton.bottomAnchor, constant: 16),
            createPostButton.heightAnchor.constraint(equalToConstant: 40),

            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            cancelButton.topAnchor.constraint(equalTo: createPostButton.bottomAnchor, constant: 16),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func addSubviews() {
        self.view.addSubview(createPostScrollView)

        createPostScrollView.addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(choseImageButton)
        contentView.addSubview(titleTextField)
        contentView.addSubview(bodyTextField)
        contentView.addSubview(createPostButton)
        contentView.addSubview(cancelButton)
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

extension CreatePostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}

// MARK: - PHPickerViewControllerDelegate Implementation

extension CreatePostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let result = results.first {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { imageSelected, error in
                    if let error = error {
                        print(error.localizedDescription)

                        return
                    }

                    DispatchQueue.main.async {
                        self.imageView.image = imageSelected as? UIImage
                    }
                }
            } else {
                return
            }
        }

        self.dismiss(animated: true)
    }
}
