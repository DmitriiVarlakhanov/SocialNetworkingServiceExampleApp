//
//  SignOutUIBarButtonItem.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 7/6/26.
//

import UIKit

class SignOutUIBarButtonItem: UIBarButtonItem {

    // MARK: - Initialization

    override init() {
        super.init()

        setupCustomUIBarButtonItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action

    @objc func barButtonTapped() {
        if let mainWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let mainWindow = mainWindowScene.windows.first {
                mainWindow.rootViewController = UINavigationController(rootViewController: LogInViewController())
            }
        }

        FirebaseAuthManager.shared.signOut()
    }

    // MARK: - Private

    private func setupCustomUIBarButtonItem() {
        self.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        self.style = .plain
        self.target = self
        self.action = #selector(barButtonTapped)
    }
}
