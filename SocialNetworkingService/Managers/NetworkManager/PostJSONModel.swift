//
//  PostJSONModel.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/13/26.
//

import Foundation

struct PostJSONModel: nonisolated Codable {
    let posts: [Post]
}

struct Post: nonisolated Codable {
    let id: Int
    let title: String
    let body: String
    let reactions: Reaction
    let views: Int
}

struct Reaction: nonisolated Codable {
    let likes: Int
}
