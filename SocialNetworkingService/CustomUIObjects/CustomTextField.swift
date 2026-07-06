//
//  CustomTextField.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/8/26.
//

import UIKit

class CustomTextField: UITextField {

    // MARK: - Properties

    let insets: UIEdgeInsets

    // MARK: - Initialization

    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)

        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.textColor = .black
        self.placeholder = "Enter text"

        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Text geometry overriding

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}
