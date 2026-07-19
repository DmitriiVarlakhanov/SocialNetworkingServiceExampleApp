//
//  ProfileViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/10/26.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties

    lazy var profileTableView: UITableView = {
        let profileTableView = UITableView(frame: .zero, style: .plain)

        profileTableView.translatesAutoresizingMaskIntoConstraints = false

        return profileTableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "PostTableViewCell_ReuseID"
        case secondCustom = "PhotosTableViewCell_ReuseID"
        case thirdCustom = "SingleProfileTableViewCell_ReuseID"
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

        if !(FirebaseAuthManager.shared.fetchedUser == nil) {
            self.navigationItem.title = FirebaseAuthManager.shared.fetchedUser!.firstName
        }

        self.navigationController?.navigationBar.isHidden = false

        let createPostUIBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(createPostUIBarButtonItemTapped)
        )

        self.navigationItem.leftBarButtonItem = createPostUIBarButtonItem

        CoreDataManager.shared.fetchObjectsFromCoreData()

        profileTableView.indexPathsForSelectedRows?.forEach { profileTableView.deselectRow(at: $0, animated: false) }

        self.profileTableView.reloadData()
    }

    // MARK: - Actions

    @objc func createPostUIBarButtonItemTapped() {
        let createPostViewController = CreatePostViewController(previousController: self)

        createPostViewController.modalPresentationStyle = .fullScreen

        self.present(createPostViewController, animated: true)
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

extension ProfileViewController: UITableViewDataSource {
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

            cell.updateForProfileScreen(indexPathRow: indexPath.row)

            return cell
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellReuseID.thirdCustom.rawValue,
                    for: indexPath
                ) as? SingleProfileTableViewCell else {
                    fatalError("could not dequeueReusableCell")
                }

                cell.updateForProfileScreen()

                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellReuseID.secondCustom.rawValue,
                    for: indexPath
                ) as? PhotosTableViewCell else {
                    fatalError("could not dequeueReusableCell")
                }

                cell.update()

                return cell
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if !(CreatedPostsManager.shared.createdPosts.isEmpty) {
                return CreatedPostsManager.shared.createdPosts.count
            } else {
                return 0
            }
        } else {
            return 1
        }
    }
}

// MARK: - UITableViewDelegate Implementation

extension ProfileViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 1 {
                let photosViewController = PhotosViewController()

                self.navigationController?.pushViewController(photosViewController, animated: true)
            }
        }
}

