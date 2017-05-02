//
//  Daily.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-14.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

/// Daily holds the list of contexts and the start and end time for the day.
/// - methods:
///     - `sort()`: sorts contexts by time
///     - `totalMinutes()`: number of minutes in a day available for contexts (end - start)
struct Daily {
    
    // MARK: - Properties
    
    var contexts = [Context]()
    var startHour: Int = 6
    var startMinutes: Int = 0
    var endHour: Int = 24
    var endMinutes: Int = 00
    
    var start: Int {
        return startHour * 60 + startMinutes
    }
    
    var end: Int {
        return endHour * 60 + endMinutes
    }
    
    // MARK: - Methods
    
    /// Sorts contexts by time
    mutating func sort() {
        let sorted = contexts.sorted { (lhs, rhs) -> Bool in
            lhs.hours + lhs.minutes < rhs.hours + rhs.minutes
        }
        contexts = sorted
    }
    
    /// Number of minutes in a day available for contexts
    ///
    /// - Returns: (end - start) in minutes
    func totalMinutes() -> Int {
        return (endHour * 60 + endMinutes) - (startHour * 60 + startMinutes)
    }
}
