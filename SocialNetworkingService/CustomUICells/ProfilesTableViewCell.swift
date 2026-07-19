//
//  ProfilesTableViewCell.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/10/26.
//

import UIKit

class ProfilesTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var label: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.text = "My friends"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        return label
    }()

    var imageView1: UIImageView = {
        let imageView1 = UIImageView()

        imageView1.translatesAutoresizingMaskIntoConstraints = false

        imageView1.contentMode = .scaleAspectFill

        imageView1.clipsToBounds = true

        imageView1.layer.cornerRadius = 45

        return imageView1
    }()

    private var imageView2: UIImageView = {
        let imageView2 = UIImageView()

        imageView2.translatesAutoresizingMaskIntoConstraints = false

        imageView2.contentMode = .scaleAspectFill

        imageView2.clipsToBounds = true

        imageView2.layer.cornerRadius = 45

        return imageView2
    }()

    private var imageView3: UIImageView = {
        let imageView3 = UIImageView()

        imageView3.translatesAutoresizingMaskIntoConstraints = false

        imageView3.contentMode = .scaleAspectFill

        imageView3.clipsToBounds = true

        imageView3.layer.cornerRadius = 45

        return imageView3
    }()

    private var imageView4: UIImageView = {
        let imageView4 = UIImageView()

        imageView4.translatesAutoresizingMaskIntoConstraints = false

        imageView4.contentMode = .scaleAspectFill

        imageView4.clipsToBounds = true

        imageView4.layer.cornerRadius = 45

        return imageView4
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupTableViewCell()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupTableViewCell() {
        self.contentView.isUserInteractionEnabled = false
    }

    private func addSubviews() {
        self.contentView.addSubview(label)
        self.contentView.addSubview(imageView1)
        self.contentView.addSubview(imageView2)
        self.contentView.addSubview(imageView3)
        self.contentView.addSubview(imageView4)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),

            imageView1.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            imageView1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageView1.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            imageView1.heightAnchor.constraint(equalTo: imageView1.widthAnchor),

            imageView2.leftAnchor.constraint(equalTo: imageView1.rightAnchor, constant: 8),
            imageView2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageView2.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            imageView2.widthAnchor.constraint(equalTo: imageView1.widthAnchor),
            imageView2.heightAnchor.constraint(equalTo: imageView1.widthAnchor),

            imageView3.leftAnchor.constraint(equalTo: imageView2.rightAnchor, constant: 8),
            imageView3.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageView3.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            imageView3.widthAnchor.constraint(equalTo: imageView1.widthAnchor),
            imageView3.heightAnchor.constraint(equalTo: imageView1.widthAnchor),

            imageView4.leftAnchor.constraint(equalTo: imageView3.rightAnchor, constant: 8),
            imageView4.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
            imageView4.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            imageView4.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            imageView4.widthAnchor.constraint(equalTo: imageView1.widthAnchor),
            imageView4.heightAnchor.constraint(equalTo: imageView1.widthAnchor)
        ])
    }

    // MARK: - Public

    func update() {
        if NetworkManager.shared.imageArray.count == 4 || NetworkManager.shared.imageArray.count > 4 {
            self.imageView1.image = NetworkManager.shared.imageArray[0]
            self.imageView2.image = NetworkManager.shared.imageArray[1]
            self.imageView3.image = NetworkManager.shared.imageArray[2]
            self.imageView4.image = NetworkManager.shared.imageArray[3]
        } else {
            return
        }
    }
}

