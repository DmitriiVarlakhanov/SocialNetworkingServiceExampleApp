//
//  FriendsOwnProfilePhotosViewController.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/16/26.
//

import UIKit

class FriendsOwnProfilePhotosViewController: UIViewController {

    // MARK: - Properties

    var indexPath: IndexPath

    private enum CellReuseID: String {
        case first = "PhotosCollectionViewCell_ReuseID"
    }

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: CellReuseID.first.rawValue
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

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

extension FriendsOwnProfilePhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellReuseID.first.rawValue,
            for: indexPath
        ) as? PhotosCollectionViewCell else {
            fatalError("could not dequeueReusableCell")
        }

        cell.friendsOwnProfilePhotosViewController(indexPath: self.indexPath)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Implementation

extension FriendsOwnProfilePhotosViewController: UICollectionViewDelegateFlowLayout {
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
        if !(NetworkManager.shared.imageArray.isEmpty) {
            let singleShownPhotoViewController = SingleShownPhotoViewController()

            singleShownPhotoViewController.imageView.image = NetworkManager.shared.imageArray[self.indexPath.row]

            self.present(singleShownPhotoViewController, animated: true)
        } else {
            return
        }
    }
}
