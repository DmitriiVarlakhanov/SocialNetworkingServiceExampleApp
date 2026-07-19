//
//  PostTableViewCell.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/10/26.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var id: String = ""

    private lazy var likeImageView: UIImageView = {
        let likeImageView = UIImageView()

        likeImageView.translatesAutoresizingMaskIntoConstraints = false

        likeImageView.image = UIImage(systemName: "heart")

        likeImageView.backgroundColor = .white
        likeImageView.contentMode = .scaleAspectFill

        likeImageView.clipsToBounds = true

        likeImageView.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeImageViewTapped))

        likeImageView.addGestureRecognizer(gestureRecognizer)

        return likeImageView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3

        return titleLabel
    }()

    private lazy var imageImageView: UIImageView = {
        let imageImageView = UIImageView()

        imageImageView.translatesAutoresizingMaskIntoConstraints = false

        imageImageView.backgroundColor = .white
        imageImageView.contentMode = .scaleAspectFill

        imageImageView.clipsToBounds = true

        return imageImageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0

        return descriptionLabel
    }()

    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()

        likesLabel.translatesAutoresizingMaskIntoConstraints = false

        likesLabel.text = ""
        likesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        likesLabel.textColor = .black

        return likesLabel
    }()

    private lazy var viewsLabel: UILabel = {
        let viewsLabel = UILabel()

        viewsLabel.translatesAutoresizingMaskIntoConstraints = false

        viewsLabel.text = ""
        viewsLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        viewsLabel.textColor = .black

        return viewsLabel
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

    // MARK: - Actions

    @objc private func likeImageViewTapped() {
        let imageData = self.imageImageView.image?.pngData()

        CoreDataManager.shared.addPostToCoreData(
            imageData: imageData ?? Data(),
            title: self.titleLabel.text ?? "",
            body: self.descriptionLabel.text ?? "",
            likes: self.likesLabel.text ?? "",
            views: self.viewsLabel.text ?? "",
            id: self.id
        )

        let heartFillImage = UIImage(systemName: "heart.fill")

        self.likeImageView.image = heartFillImage
    }

    // MARK: - Private

    private func setupTableViewCell() {
        self.selectionStyle = .none
    }

    private func addSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(imageImageView)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(likesLabel)
        self.contentView.addSubview(viewsLabel)
        self.contentView.addSubview(likeImageView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),

            imageImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            imageImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imageImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: imageImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),

            likesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),

            likeImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likeImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            likeImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),

            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: self.likeImageView.leadingAnchor, constant: -5),
            viewsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
        ])
    }

    // MARK: - Public

    func update(indexPath: IndexPath) {
        if !(NetworkManager.shared.postJSONModel.posts.isEmpty) {
            titleLabel.text = NetworkManager.shared.postJSONModel.posts[indexPath.row].title
            imageImageView.image = UIImage(
                named: "Image\(NetworkManager.shared.postJSONModel.posts[indexPath.row].id)"
            )
            descriptionLabel.text = NetworkManager.shared.postJSONModel.posts[indexPath.row].body
            likesLabel.text = "Likes: \(NetworkManager.shared.postJSONModel.posts[indexPath.row].reactions.likes)"
            viewsLabel.text = "Views: \(NetworkManager.shared.postJSONModel.posts[indexPath.row].views)"
            id = String(NetworkManager.shared.postJSONModel.posts[indexPath.row].id)
        } else {
            return
        }

        let isSaved = CoreDataManager.shared.fetchedPosts.contains { fetchedPost in
            fetchedPost.identificator == self.id
        }

        if isSaved {
            self.likeImageView.image = UIImage(systemName: "heart.fill")
        } else {
            self.likeImageView.image = UIImage(systemName: "heart")
        }
    }

    func updateForProfileScreen(indexPathRow: Int) {
        if !(CreatedPostsManager.shared.createdPosts.isEmpty) {
            titleLabel.text = CreatedPostsManager.shared.createdPosts[indexPathRow].title
            imageImageView.image = CreatedPostsManager.shared.createdPosts[indexPathRow].image
            descriptionLabel.text = CreatedPostsManager.shared.createdPosts[indexPathRow].body
            likesLabel.text = "Likes: \(CreatedPostsManager.shared.createdPosts[indexPathRow].likes)"
            viewsLabel.text = "Views: \(CreatedPostsManager.shared.createdPosts[indexPathRow].views)"
            id = CreatedPostsManager.shared.createdPosts[indexPathRow].id
        } else {
            return
        }

        let isSaved = CoreDataManager.shared.fetchedPosts.contains { fetchedPost in
            fetchedPost.identificator == self.id
        }

        if isSaved {
            self.likeImageView.image = UIImage(systemName: "heart.fill")
        } else {
            self.likeImageView.image = UIImage(systemName: "heart")
        }
    }
}
