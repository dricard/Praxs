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
    
    // MARK: - Methods
    
    mutating func sort() {
        let sorted = contexts.sorted { (lhs, rhs) -> Bool in
            lhs.hour + lhs.minutes < rhs.hour + rhs.minutes
        }
        contexts = sorted
    }
}
