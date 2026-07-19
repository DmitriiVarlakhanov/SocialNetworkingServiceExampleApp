//
//  FriendsProfilesViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/12/26.
//

import UIKit

class FriendsProfilesViewController: UIViewController {

    // MARK: - Properties

    private enum CellReuseID: String {
        case first = "FriendsProfilesViewControllerCollectionViewCell_ReuseID"
    }

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            FriendsProfilesViewControllerCollectionViewCell.self,
            forCellWithReuseIdentifier: CellReuseID.first.rawValue
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        setupConstraints()
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor)
        ])
    }

    private func addSubviews() {
        self.view.addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource Implementation

extension FriendsProfilesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !(NetworkManager.shared.imageArray.isEmpty) {
            return NetworkManager.shared.imageArray.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellReuseID.first.rawValue,
            for: indexPath
        ) as? FriendsProfilesViewControllerCollectionViewCell else {
            fatalError("could not dequeueReusableCell")
        }

        cell.update(indexPath: indexPath)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Implementation

extension FriendsProfilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 4 * 8) / 3

        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friendsOwnProfileViewController = FriendsOwnProfileViewController(indexPath: indexPath)

        self.navigationController?.pushViewController(friendsOwnProfileViewController, animated: true)
    }
}

