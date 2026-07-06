//
//  SingleShownPhotoViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/21/26.
//

import UIKit

class SingleShownPhotoViewController: UIViewController {

    // MARK: - Properties

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage()

        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 8

        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRootView()
        addSubviews()
        setupConstraints()
    }

    // MARK: - Private

    private func setupRootView() {
        self.view.backgroundColor = .black
    }

    private func addSubviews() {
        self.view.addSubview(imageView)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            imageView.heightAnchor.constraint(equalToConstant: self.view.bounds.width)
        ])
    }
}
