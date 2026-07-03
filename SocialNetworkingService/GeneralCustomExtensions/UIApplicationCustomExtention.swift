//
//  UIApplicationCustomExtention.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/17/26.
//

import Foundation
import UIKit

extension UIApplication {

    func topMostViewController() -> UIViewController? {
        let activeScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene

        let keyWindow = activeScene?.windows.first(where: { $0.isKeyWindow })

        return keyWindow?.rootViewController?.findTopMostController()
    }
}
