//
//  PostsViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/13/26.
//

import UIKit

class PostsViewController: UIViewController {

    // MARK: - Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "PostTableViewCell_ReuseID"
        case secondCustom = "ProfilesTableViewCell_ReuseID"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)

        setupConstraints()
        setupTableView()

        NetworkManager.shared.requestPostJSONModel(
            url: "https://dummyjson.com/posts",
            tableView: self.tableView
        )
        NetworkManager.shared.requestProfileJSONModel(
            url: "https://dummyjson.com/users",
            tableView: self.tableView
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Social Networking Service"
        self.navigationController?.navigationBar.isHidden = false

        CoreDataManager.shared.fetchObjectsFromCoreData()

        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: false) }

        self.tableView.reloadData()
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()

        tableView.register(
            PostTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        tableView.register(
            ProfilesTableViewCell.self,
            forCellReuseIdentifier: CellReuseID.secondCustom.rawValue
        )

        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource Implementation

extension PostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.firstCustom.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            cell.update(indexPath: indexPath)

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.secondCustom.rawValue,
                for: indexPath
            ) as? ProfilesTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            guard NetworkManager.shared.imageArray.isEmpty else {
                cell.update()

                return cell
            }

            return cell
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if !(NetworkManager.shared.postJSONModel.posts.isEmpty) {
                return NetworkManager.shared.postJSONModel.posts.count - 20
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
}

// MARK: - UITableViewDelegate Implementation

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let friendsProfilesViewController = FriendsProfilesViewController()

            self.navigationController?.pushViewController(friendsProfilesViewController, animated: true)
        }
    }
}
