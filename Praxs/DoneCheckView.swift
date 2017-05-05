//
//  DoneCheckView.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-05-05.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class DoneCheckView: UIView {

    var done: Bool = false
    
    override func draw(_ rect: CGRect) {
        if done {
            PraxsStyleKit.drawDoneCheck()
        } else {
            PraxsStyleKit.drawNotDoneCheck()
        }
        
    }

}
