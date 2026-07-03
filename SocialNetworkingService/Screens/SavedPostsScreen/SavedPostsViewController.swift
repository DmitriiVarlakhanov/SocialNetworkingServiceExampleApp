//
//  SavedPostsViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/21/26.
//

import UIKit

class SavedPostsViewController: UIViewController {

    // MARK: - Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private enum CellReuseID: String {
        case firstCustom = "PostTableViewCellForSavedPostsScreen_ReuseID"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)

        setupConstraints()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = "Saved Posts"
        self.navigationController?.navigationBar.isHidden = false

        tableView.indexPathsForSelectedRows?.forEach { tableView.deselectRow(at: $0, animated: false) }

        CoreDataManager.shared.fetchObjectsFromCoreData()

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
            PostTableViewCellForSavedPostsScreen.self,
            forCellReuseIdentifier: CellReuseID.firstCustom.rawValue
        )

        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource Implementation

extension SavedPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.firstCustom.rawValue,
            for: indexPath
        ) as? PostTableViewCellForSavedPostsScreen else {
            fatalError("could not dequeueReusableCell")
        }

        cell.updateForSavedPostsScreen(indexPath: indexPath)

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.fetchedPosts.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCellForSavedPostsScreen

            CoreDataManager.shared.deleteAnObjectFromCoreData(
                imageData: cell.imageImageView.image?.pngData() ?? Data(),
                title: cell.titleLabel.text ?? "",
                body: cell.descriptionLabel.text ?? "",
                likes: cell.likesLabel.text ?? "",
                views: cell.viewsLabel.text ?? ""
            )

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
