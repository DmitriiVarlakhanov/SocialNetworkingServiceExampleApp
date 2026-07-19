//
//  UserProfileFirestoreModel.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/18/26.
//

import Foundation

struct UserProfileFirestoreModel: nonisolated Codable {
    let firstName: String
    let lastName: String
    let email: String
    let gender: String
    let birthDate: String
    let hometown: String
}
