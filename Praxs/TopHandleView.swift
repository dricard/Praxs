//
//  TopHandleView.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-25.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class TopHandleView: UIView {

    override func draw(_ rect: CGRect) {
        PraxsStyleKit.drawTopHandle(frame: bounds, resizing: .aspectFit)
    }

}
