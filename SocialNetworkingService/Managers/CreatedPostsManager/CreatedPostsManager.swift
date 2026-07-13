//
//  CreatedPostsManager.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 7/9/26.
//

import Foundation

class CreatedPostsManager {

    // MARK: - Type properties

    static var shared = CreatedPostsManager()

    // MARK: - Properties

    var createdPosts: [CreatedPostModel] = []

    // MARK: - Initialization

    private init() {}
}
