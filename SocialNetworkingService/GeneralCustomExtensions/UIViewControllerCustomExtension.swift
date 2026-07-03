//
//  UIViewControllerCustomExtension.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/17/26.
//

import Foundation
import UIKit

extension UIViewController {

    // MARK: - Type public

    static func changeRootControllerForMainWindow() {
        if let mainWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let mainWindow = mainWindowScene.windows.first {
                let tabBarController = UITabBarController()

                let postsViewController = PostsViewController()
                let profileViewController = ProfileViewController()
                let savedPostsViewController = SavedPostsViewController()

                postsViewController.tabBarItem = UITabBarItem(
                    title: "Posts",
                    image: UIImage(systemName: "newspaper"),
                    tag: 0
                )

                profileViewController.tabBarItem = UITabBarItem(
                    title: "Profile",
                    image: UIImage(systemName: "person.crop.circle"),
                    tag: 1
                )

                savedPostsViewController.tabBarItem = UITabBarItem(
                    title: "Saved",
                    image: UIImage(systemName: "square.and.arrow.down.badge.checkmark"),
                    tag: 2
                )

                let navigationControllerForProfileViewController = UINavigationController(rootViewController: profileViewController)
                let navigationControllerForPostsViewController = UINavigationController(rootViewController: postsViewController)
                let navigationControllerForSavedPostsViewController = UINavigationController(rootViewController: savedPostsViewController)

                tabBarController.viewControllers = [
                    navigationControllerForPostsViewController,
                    navigationControllerForProfileViewController,
                    navigationControllerForSavedPostsViewController
                ]

                mainWindow.rootViewController = tabBarController
            }
        }
    }

    // MARK: - Public

    func findTopMostController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.findTopMostController()
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.findTopMostController() ?? navigation
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.findTopMostController() ?? tab
        }

        return self
    }
}
