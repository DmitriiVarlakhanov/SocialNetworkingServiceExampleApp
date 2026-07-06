//
//  PhotosCollectionViewCell.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/16/26.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 8

        return imageView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func addSubviews() {
        self.contentView.addSubview(imageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    // MARK: - Public

    func update(indexPath: IndexPath) {
        self.imageView.image = UIImage(named: "Image\(indexPath.row + 1)")
    }

    func friendsOwnProfilePhotosViewController(indexPath: IndexPath) {
        if !(NetworkManager.shared.imageArray.isEmpty) {
            self.imageView.image = NetworkManager.shared.imageArray[indexPath.row]
        } else {
            return
        }
    }
}
