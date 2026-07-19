//
//  SingleProfileTableViewCell.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/10/26.
//

import UIKit

class SingleProfileTableViewCell: UITableViewCell {

    // MARK: - Properties

    private lazy var myImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill

        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private lazy var profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()

        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false

        profileNameLabel.text = ""
        profileNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        profileNameLabel.textColor = .black
        profileNameLabel.numberOfLines = 2

        return profileNameLabel
    }()

    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()

        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        emailLabel.text = ""
        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        emailLabel.textColor = .black
        emailLabel.numberOfLines = 3

        return emailLabel
    }()

    private lazy var genderLabel: UILabel = {
        let genderLabel = UILabel()

        genderLabel.translatesAutoresizingMaskIntoConstraints = false

        genderLabel.text = ""
        genderLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        genderLabel.textColor = .black

        return genderLabel
    }()

    private lazy var birthDateLabel: UILabel = {
        let birthDateLabel = UILabel()

        birthDateLabel.translatesAutoresizingMaskIntoConstraints = false

        birthDateLabel.text = ""
        birthDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        birthDateLabel.textColor = .black
        birthDateLabel.numberOfLines = 3

        return birthDateLabel
    }()

    private lazy var hometownLabel: UILabel = {
        let hometownLabel = UILabel()

        hometownLabel.translatesAutoresizingMaskIntoConstraints = false

        hometownLabel.text = ""
        hometownLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        hometownLabel.textColor = .black
        hometownLabel.numberOfLines = 3

        return hometownLabel
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(myImageView)
        self.addSubview(profileNameLabel)
        self.addSubview(emailLabel)
        self.addSubview(genderLabel)
        self.addSubview(birthDateLabel)
        self.addSubview(hometownLabel)

        setupTableViewCell()
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        myImageView.layer.cornerRadius = myImageView.bounds.width / 2
        myImageView.clipsToBounds = true
    }

    // MARK: - Private

    private func setupTableViewCell() {
        self.selectionStyle = .none
    }

    private func setupView() {
        self.backgroundColor = .white

        self.contentView.isUserInteractionEnabled = false
    }

    private func setupConstraints() {
        let safeAreaGuide = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            myImageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 15),
            myImageView.widthAnchor.constraint(equalToConstant: 128),
            myImageView.heightAnchor.constraint(equalToConstant: 128),

            profileNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27),
            profileNameLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 27),
            profileNameLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5),

            emailLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 27),
            emailLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 27),
            emailLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5),

            genderLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            genderLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 27),
            genderLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5),

            birthDateLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5),
            birthDateLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 27),
            birthDateLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5),

            hometownLabel.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 5),
            hometownLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 27),
            hometownLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5),
            hometownLabel.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Public

    func updateForFriendsOwnProfileScreen(indexPath: IndexPath) {
        if !(NetworkManager.shared.imageArray.isEmpty) && !(NetworkManager.shared.profileJSONModel.users.isEmpty) {
            self.myImageView.image = NetworkManager.shared.imageArray[indexPath.row]
            self.profileNameLabel.text = NetworkManager.shared.profileJSONModel.users[indexPath.row].firstName + " " + NetworkManager.shared.profileJSONModel.users[indexPath.row].lastName
            self.emailLabel.text = "Email: " + NetworkManager.shared.profileJSONModel.users[indexPath.row].email
            self.genderLabel.text = "Gender: " + NetworkManager.shared.profileJSONModel.users[indexPath.row].gender
            self.birthDateLabel.text = "Birth date: " + NetworkManager.shared.profileJSONModel.users[indexPath.row].birthDate
            self.hometownLabel.text = "Hometown: " + NetworkManager.shared.profileJSONModel.users[indexPath.row].address.city
        } else {
            return
        }
    }

    func updateForProfileScreen() {
        if !(FirebaseAuthManager.shared.fetchedUser == nil) {
            self.myImageView.image = UIImage(named: "ProfileImage")
            self.profileNameLabel.text = FirebaseAuthManager.shared.fetchedUser!.firstName + " " + FirebaseAuthManager.shared.fetchedUser!.lastName
            self.emailLabel.text = "Email: " + FirebaseAuthManager.shared.fetchedUser!.email
            self.genderLabel.text = "Gender: " + FirebaseAuthManager.shared.fetchedUser!.gender
            self.birthDateLabel.text = "Birth date: " + FirebaseAuthManager.shared.fetchedUser!.birthDate
            self.hometownLabel.text = "Hometown: " + FirebaseAuthManager.shared.fetchedUser!.hometown
        } else {
            return
        }
    }
}
