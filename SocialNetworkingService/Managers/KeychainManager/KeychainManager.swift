//
//  KeychainManager.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/9/26.
//

import Foundation
import KeychainSwift

class KeychainManager {

    // MARK: - Properties

    static let shared = KeychainManager()

    private let keychain = KeychainSwift()

    // MARK: - Initialization

    private init() {}

    // MARK: - Public

    func setKeyValuePair(key: String, value: String) {
        keychain.set(value, forKey: key)
    }

    func getValue(forKey key: String) -> String? {
        keychain.get(key)
    }

    func deleteKeyValuePair(forKey key: String) {
        keychain.delete(key)
    }

    func getAllKeys() -> [String] {
        keychain.allKeys
    }

    func deleteAllKeys() {
        keychain.clear()
    }
}
