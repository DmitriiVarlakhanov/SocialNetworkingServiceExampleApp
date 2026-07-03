//
//  FriendsOwnProfileViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/16/26.
//

import UIKit

class FriendsOwnProfileViewController: UIViewController {

    // MARK: - Properties

    var indexPath: IndexPath

    private lazy var profileTableView: UITableView = {
        let profileTableView = UITableView(frame: .zero, style: .plain)

        profileTableView.translatesAutoresizingMaskIntoConstraints = false

        return profileTableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "PostTableViewCell_ReuseID"
        case secondCustom = "PhotosTableViewCell_ReuseID"
        case thirdCustom = "SingleProfileTableViewCell_ReuseID"
    }

    // MARK: - Initialization

    init(indexPath: IndexPath) {
        self.indexPath = indexPath

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(profileTableView)

        setupConstraints()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !(NetworkManager.shared.profileJSONModel.users.isEmpty) {
            self.navigationItem.title = NetworkManager.shared.profileJSONModel.users[indexPath.row].firstName
        }

        self.navigationController?.navigationBar.isHidden = false

        profileTableView.indexPathsForSelectedRows?.forEach { profileTableView.deselectRow(at: $0, animated: false) }
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            profileTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            profileTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            profileTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        profileTableView.rowHeight = UITableView.automaticDimension

        profileTableView.tableHeaderView = UIView()
        profileTableView.tableFooterView = UIView()

        profileTableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        profileTableView.register(
            PhotosTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.secondCustom.rawValue
        )

        profileTableView.register(
            SingleProfileTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.thirdCustom.rawValue
        )

        profileTableView.dataSource = self
        profileTableView.delegate = self
    }
}

// MARK: - UITableViewDataSource Implementation

extension FriendsOwnProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.firstCustom.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            cell.update(indexPath: self.indexPath)

            return cell
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellReuseID.thirdCustom.rawValue,
                    for: indexPath
                ) as? SingleProfileTableViewCell else {
                    fatalError("could not dequeueReusableCell")
                }

                cell.updateForFriendsOwnProfileScreen(indexPath: self.indexPath)

                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellReuseID.secondCustom.rawValue,
                    for: indexPath
                ) as? PhotosTableViewCell else {
                    fatalError("could not dequeueReusableCell")
                }

                cell.updateForFriendsOwnProfileScreen(indexPath: self.indexPath)

                return cell
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if !(NetworkManager.shared.postJSONModel.posts.isEmpty) {
                return 1
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
}

// MARK: - UITableViewDelegate Implementation

extension FriendsOwnProfileViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 1 {
                let friendsOwnProfilePhotosViewController = FriendsOwnProfilePhotosViewController(
                    indexPath: self.indexPath
                )

                self.navigationController?.pushViewController(friendsOwnProfilePhotosViewController, animated: true)
            }
        }
}
