//
//  NetworkManager.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/11/26.
//

import Foundation
import UIKit

class NetworkManager {

    // MARK: - Type properties

    static let shared = NetworkManager()

    // MARK: - Properties

    var postJSONModel = PostJSONModel.init(posts: [])

    var profileJSONModel = ProfileJSONModel.init(users: [])

    var imageURLArray: [String] = []

    var imageArray: [UIImage] = []

    // MARK: - Initialization

    private init() {}

    // MARK: - Public

    func requestProfileJSONModel(url: String, tableView: UITableView) {
        let session = URLSession.shared

        let urlString = url

        let url = URL(string: urlString)!

        let request = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode != 200 {
                print("Response failure, status code - \(httpURLResponse.statusCode)")

                return
            }

            guard let data = data else {
                print("Error - no data available")

                return
            }

            do {
                let jsonData = try JSONDecoder().decode(ProfileJSONModel.self, from: data)

                self.profileJSONModel = jsonData

                jsonData.users.forEach { user in
                    self.imageURLArray.append(user.image)
                }

                self.imageURLArray.forEach { imageURL in
                    NetworkManager.shared.requestSingleImage(url: imageURL, tableView: tableView)
                }

                DispatchQueue.main.async {
                    tableView.reloadData()
                }

                print(jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }

        request.resume()
    }

    func requestPostJSONModel(url: String, tableView: UITableView) {
        let session = URLSession.shared

        let urlString = url

        let url = URL(string: urlString)!

        let request = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode != 200 {
                print("Response failure, status code - \(httpURLResponse.statusCode)")

                return
            }

            guard let data = data else {
                print("Error - no data available")

                return
            }

            do {
                let jsonData = try JSONDecoder().decode(PostJSONModel.self, from: data)

                self.postJSONModel = jsonData

                DispatchQueue.main.async {
                    tableView.reloadData()
                }

                print(jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }

        request.resume()
    }

    func requestSingleImage(url: String, tableView: UITableView) {
        let session = URLSession.shared

        let urlString = url

        let url = URL(string: urlString)!

        let request = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode != 200 {
                print("Response failure, status code - \(httpURLResponse.statusCode)")

                return
            }

            guard let data = data else {
                print("Error - no data available")

                return
            }

            self.imageArray.append(UIImage(data: data) ?? UIImage())

            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }

        request.resume()
    }
}
