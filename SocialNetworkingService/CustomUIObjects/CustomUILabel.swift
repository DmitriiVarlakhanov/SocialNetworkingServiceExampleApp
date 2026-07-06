//
//  CustomUILabel.swift
//  SocialNetworkingService
//
//  Created by Dmitrii Varlakhanov on 6/20/26.
//

import UIKit

class CustomUILabel: UILabel {

    // MARK: - Properties

    var textInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    // MARK: - Layout lifecycle

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }

    // MARK: - Rendering lifecycle

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }
}
