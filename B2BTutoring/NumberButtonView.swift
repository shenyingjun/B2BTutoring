//
//  NumberButtonView.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/25/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit

@IBDesignable
class NumberButtonView: UIButton {
    @IBInspectable
    var color: UIColor = UIColor.greenColor()

    override func drawRect(rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalInRect: rect)
        color.setFill()
        path.fill()
    }
}
