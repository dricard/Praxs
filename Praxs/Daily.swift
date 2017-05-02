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
    var startHour: Int = 6
    var startMinutes: Int = 0
    var endHour: Int = 23
    var endMinutes: Int = 55
    
    var start: Int {
        return startHour * 60 + startMinutes
    }
    
    var end: Int {
        return endHour * 60 + endMinutes
    }
    
    // MARK: - Methods
    
    mutating func sort() {
        let sorted = contexts.sorted { (lhs, rhs) -> Bool in
            lhs.hours + lhs.minutes < rhs.hours + rhs.minutes
        }
        contexts = sorted
    }
    
    func totalMinutes() -> Int {
        return (endHour * 60 + endMinutes) - (startHour * 60 + startMinutes)
    }
}
