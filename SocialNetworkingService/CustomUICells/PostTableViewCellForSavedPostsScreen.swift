//
//  PostTableViewCellForSavedPostsScreen.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/28/26.
//

import UIKit

class PostTableViewCellForSavedPostsScreen: UITableViewCell {

    // MARK: - Properties

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 3

        return titleLabel
    }()

    lazy var imageImageView: UIImageView = {
        let imageImageView = UIImageView()

        imageImageView.translatesAutoresizingMaskIntoConstraints = false

        imageImageView.backgroundColor = .white
        imageImageView.contentMode = .scaleAspectFill

        imageImageView.clipsToBounds = true

        return imageImageView
    }()

    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = ""
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0

        return descriptionLabel
    }()

    lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()

        likesLabel.translatesAutoresizingMaskIntoConstraints = false

        likesLabel.text = ""
        likesLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        likesLabel.textColor = .black

        return likesLabel
    }()

    lazy var viewsLabel: UILabel = {
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

            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
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
        } else {
            return
        }
    }

    func updateForProfileScreen(indexPathRow: Int) {
        if !(NetworkManager.shared.postJSONModel.posts.isEmpty) {
            titleLabel.text = NetworkManager.shared.postJSONModel.posts[indexPathRow].title
            imageImageView.image = UIImage(
                named: "Image\(NetworkManager.shared.postJSONModel.posts[indexPathRow].id)"
            )
            descriptionLabel.text = NetworkManager.shared.postJSONModel.posts[indexPathRow].body
            likesLabel.text = "Likes: \(NetworkManager.shared.postJSONModel.posts[indexPathRow].reactions.likes)"
            viewsLabel.text = "Views: \(NetworkManager.shared.postJSONModel.posts[indexPathRow].views)"
        } else {
            return
        }
    }


    func updateForSavedPostsScreen(indexPath: IndexPath) {
        titleLabel.text = CoreDataManager.shared.fetchedPosts[indexPath.row].title

        imageImageView.image = UIImage(data: CoreDataManager.shared.fetchedPosts[indexPath.row].image ?? Data())

        descriptionLabel.text = CoreDataManager.shared.fetchedPosts[indexPath.row].body
        likesLabel.text = CoreDataManager.shared.fetchedPosts[indexPath.row].likes
        viewsLabel.text = CoreDataManager.shared.fetchedPosts[indexPath.row].views
    }
}
