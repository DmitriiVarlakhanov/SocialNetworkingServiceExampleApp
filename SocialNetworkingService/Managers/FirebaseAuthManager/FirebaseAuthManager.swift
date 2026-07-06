//
//  FirebaseAuthManager.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/17/26.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {

    // MARK: - Type properties

    static let shared = FirebaseAuthManager()

    // MARK: - Properties

    private let auth = Auth.auth()

    private let db = Firestore.firestore()

    var fetchedUser: UserProfileFirestoreModel?

    // MARK: - Initialization

    private init() {}

    // MARK: - Public

    // Method:

    func createUser(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        gender: String,
        birthDate: String,
        hometown: String
    ) {
        auth.createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Firebase user creation failed, \(error.localizedDescription)")

                let alertController = UIAlertController(
                    title: error.localizedDescription,
                    message: "Please try again",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                let topMostViewController = UIApplication.shared.topMostViewController()

                topMostViewController!.present(alertController, animated: true)

                return
            }

            self.db.collection("users").addDocument(
                data: [
                    "firstName": firstName,
                    "lastName": lastName,
                    "email" : email,
                    "gender": gender,
                    "birthDate": birthDate,
                    "hometown": hometown
                ],
                completion:
                    { error in
                if let error = error {
                    print(error.localizedDescription)

                    return
                }
            })

            KeychainManager.shared.setKeyValuePair(
                key: email,
                value: password
            )

            let topMostViewController = UIApplication.shared.topMostViewController()

            topMostViewController?.dismiss(animated: true)
        }
    }

    // Method:

    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Firebase user creation failed, \(error.localizedDescription)")

                let alertController = UIAlertController(
                    title: error.localizedDescription,
                    message: "Please try again",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "Ok",
                    style: .cancel
                )

                alertController.addAction(action)

                let topMostViewController = UIApplication.shared.topMostViewController()

                topMostViewController!.present(alertController, animated: true)

                return
            }

            UIViewController.changeRootControllerForMainWindow()

            self.fetchData(email: email)
        }
    }

    // Method:

    func fetchData(email: String) {
        db.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents")

                return
            }

            let users = documents.compactMap { document in
                try? document.data(as: UserProfileFirestoreModel.self)
            }

            for user in users {
                if email == user.email {
                    self.fetchedUser = user

                    break
                } else {
                    continue
                }
            }

            print("Fetched user - \(self.fetchedUser)")
        }
    }

    // Method:

    func deleteFirestoreData() {
        db.collection("users").getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents")

                return
            }

            var documentIDs: [String] = []

            for document in documents {
                documentIDs.append(document.documentID)
            }

            for documentID in documentIDs {
                self.db.collection("users").document(documentID).delete()
            }
        }
    }
}
