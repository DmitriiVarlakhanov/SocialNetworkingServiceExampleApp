//
//  FriendsProfilesViewControllerCollectionViewCell.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/12/26.
//

import UIKit

class FriendsProfilesViewControllerCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 8

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black

        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
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
        self.contentView.addSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),

            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    // MARK: - Public

    func update(indexPath: IndexPath) {
        if !(NetworkManager.shared.imageArray.isEmpty) && !(NetworkManager.shared.profileJSONModel.users.isEmpty) {
            imageView.image = NetworkManager.shared.imageArray[indexPath.row]
            label.text = NetworkManager.shared.profileJSONModel.users[indexPath.row].firstName
        } else {
            imageView.image = UIImage(systemName: "person.crop.circle")
            label.text = "Untitled"
            return
        }
    }
}

