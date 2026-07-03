//
//  CoreDataManager.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/26/26.
//

import Foundation
import CoreData

class CoreDataManager {

    // MARK: - Type properties

    static let shared = CoreDataManager()

    // MARK: - Properties

    var fetchedPosts: [CoreDataPostModel] = []

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataPostModel")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        return container
    }()

    // MARK: - Initialization

    private init() {}

    // MARK: - Public

    // Method

    func addPostToCoreData(imageData: Data, title: String, body: String, likes: String, views: String) {
        self.fetchObjectsFromCoreData()

        for fetchedPost in fetchedPosts {
            guard !(imageData == fetchedPost.image && title == fetchedPost.title && body == fetchedPost.body && likes == fetchedPost.likes && views == fetchedPost.views) else {
                print("----------Post already exists----------")

                return
            }
            continue
        }

        let post = CoreDataPostModel(context: persistentContainer.viewContext)

        post.image = imageData
        post.title = title
        post.body = body
        post.likes = likes
        post.views = views

        do {
            try persistentContainer.viewContext.save()

            print("----------Successfully added post----------")
            print(post)
        } catch {
            print(error.localizedDescription)
        }
    }

    // Method

    func deleteAllObjectsFromCoreData() {
        let fetchRequest = CoreDataPostModel.fetchRequest()

        do {
            let postsFromCoreData = try persistentContainer.viewContext.fetch(fetchRequest)

            for post in postsFromCoreData {
                print("------------Deleting-----------------")
                persistentContainer.viewContext.delete(post)
            }

            try persistentContainer.viewContext.save()

            print("Successfully deleted all objects")
        } catch {
            print(error.localizedDescription)
        }
    }

    // Method

    func fetchObjectsFromCoreData() {
        let fetchRequest = CoreDataPostModel.fetchRequest()

        fetchedPosts = []

        do {
            let postsFromCoreData = try persistentContainer.viewContext.fetch(fetchRequest)

            for post in postsFromCoreData {
                print("------------Fetching-----------------")
                print(post)

                fetchedPosts.append(post)
            }

            print("Successfully fetched all objects")
        } catch {
            print(error.localizedDescription)
        }
    }

    // Method

    func deleteAnObjectFromCoreData(imageData: Data, title: String, body: String, likes: String, views: String) {
        let fetchRequest = CoreDataPostModel.fetchRequest()

        do {
            let postsFromCoreData = try persistentContainer.viewContext.fetch(fetchRequest)

            for post in postsFromCoreData {
                if imageData == post.image && title == post.title && body == post.body && likes == post.likes && views == post.views {
                    persistentContainer.viewContext.delete(post)

                    break
                } else {
                    continue
                }
            }

            try persistentContainer.viewContext.save()

            print("Successfully deleted requested object")

            self.fetchObjectsFromCoreData()
        } catch {
            print(error.localizedDescription)
        }
    }
}
