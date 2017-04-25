//
//  Context.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-14.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import Foundation
import UIKit

class Context {
    
    // MARK: - properties
    
    var hour: Int
    var minutes: Int
    var next: Context?
    var previous: Context?
    var color: Int
    var title: String
 
    var timeInMinutes: Int {
        return hour * 60 + minutes
    }

    let minimumContextDuration: CGFloat = 30 // minutes
    let miniumuContextUnit: CGFloat = 5 // minutes
    
    // MARK: - Initializer
    
    init(hour: Int, minutes: Int, previous: Context?, next: Context?, color: Int, title: String) {
        self.hour = hour
        self.minutes = minutes
        self.previous = previous
        self.next = next
        self.color = color
        self.title = title
    }
    
    // MARK: - Methods
    func timeLabel() -> String {
        return "\(hour):\(minutes < 10 ? "0" : "")\(minutes)"
    }
}
