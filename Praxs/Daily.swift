//
//  Daily.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-14.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

struct Daily {
    
    // MARK: - Properties
    
    var contexts = [Context]()
    var startHour: CGFloat = 6
    var startMinutes: CGFloat = 0
    var endHour: CGFloat = 23
    var endMinutes: CGFloat = 55
    
    var start: CGFloat {
        return startHour * 60 + startMinutes
    }
    
    var end: CGFloat {
        return endHour * 60 + endMinutes
    }
    
    // MARK: - Methods
    
    mutating func sort() {
        let sorted = contexts.sorted { (lhs, rhs) -> Bool in
            lhs.hour + lhs.minutes < rhs.hour + rhs.minutes
        }
        contexts = sorted
    }
    
    func totalMinutes() -> CGFloat {
        return (endHour * 60 + endMinutes) - (startHour * 60 + startMinutes)
    }
}
