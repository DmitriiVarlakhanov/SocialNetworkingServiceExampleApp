//
//  ProfileJSONModel.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/11/26.
//

import Foundation

struct ProfileJSONModel: Codable {
    let users: [User]
}

struct User: Codable {
    let firstName: String
    let lastName: String
    let age: Int
    let gender: String
    let email: String
    let username: String
    let password: String
    let birthDate: String
    let image: String
    let address: Address
}

struct Address: Codable {
    let city: String
    let country: String
}
