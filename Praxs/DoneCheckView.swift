//
//  DoneCheckView.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-05-05.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class DoneCheckView: UIView {

    private var _done: Bool = false
    
    var done: Bool {
        get {
            return _done
        }
        set (newValue) {
            _done = newValue
            setNeedsDisplay()
        }
       
    }
    
    
    override func draw(_ rect: CGRect) {
        if _done {
            PraxsStyleKit.drawDoneCheck()
        } else {
            PraxsStyleKit.drawNotDoneCheck()
        }
        
    }

}
