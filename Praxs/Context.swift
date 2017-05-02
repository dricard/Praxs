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
    private var _minutes: Int = 0
    private var _hours: Int = 0
    
    // hours and minutes represent the start time of the context
    var next: Context?          // points to the next context
    var previous: Context?      // points to the previous context
    var color: Int              // color of the context's background
    var title: String           // name of the context
 
    /// The hours of the start time of the context.
    /// i.e., the `HH` part of the `HH:MM`
    /// - note: this is in 24H time format at the moment
    ///   we might want to have a pref to switch between
    ///   24H and am/pm formats eventually.
    var hours: Int {
        get {
            return _hours
        }
        set (newValue) {
            if newValue <= 0 {
                _hours = 0
            } else if newValue >= 23 {
                _hours = 23
            } else {
                _hours = newValue
            }
        }
    }
    
    /// The minutes in the start time of the context.
    /// i.e., the `MM` part of the `HH:MM`
    /// - note: for the start time represented in
    ///   minutes (as opposed to `HH:MM`, use the computed 
    ///   property `timeInMinutes`
    var minutes: Int {
        get {
            return _minutes
        }
        set (newValue) {
            if newValue <= 0 {
                _minutes = 0
            } else if newValue > 59 {
                _minutes = roundToIncrement(newValue - 60)
                _hours += 1
            } else {
                _minutes = roundToIncrement(newValue)
            }
        }
    }

    
    /// Holds the context's start time converted in minutes (from hours:minutes)
    var timeInMinutes: Int {
        return hours * 60 + minutes
    }
    
    let minimumContextDuration: Int = 30    // minutes
    let minimumContextUnit: Int = 5         // minutes
    let navigationBarHeight: CGFloat = 44 + 20 // navigation bar plus status bar
    
    // MARK: - Initializer
    
    init(hours: Int, minutes: Int, previous: Context?, next: Context?, color: Int, title: String) {
        self._hours = hours
        self._minutes = minutes
        self.previous = previous
        self.next = next
        self.color = color
        self.title = title
    }
    
    // MARK: - General Methods
    
    /// Creates a string from the context's start time. 
    /// This will pad minutes with `0` if minutes is < 10
    /// (but will not pad the hour).
    ///
    /// - returns: a string in the format `"H:MM"`
    func timeLabel() -> String {
        return "\(hours):\(minutes < 10 ? "0" : "")\(minutes)"
    }
    
    /// Rounds the start time of the context to the nearest time increment.
    /// Time increment is set in `minimumContextUnit` in minutes (i.e., 5 min)
    ///
    /// - Parameter rawValue: the time before rounding, generated from dragging
    ///   the context for example.
    /// - Returns: A rounded time in minutes.
    func roundToIncrement(_ rawValue: Int) -> Int {
        return Int(Double(rawValue) / Double(minimumContextUnit) + 0.5) * minimumContextUnit
    }

    // MARK: - Drawing methods
    
    /// Determines the CGRect of the UIView representing the context.
    ///
    /// - Parameters:
    ///   - scale: scale of the screen in CGFloat / min
    ///   - start: smallest amount of time for the day (in min)
    ///   - end: largest amount of time for the day (in min)
    ///   - width: screen width in CGFloat
    ///   - buffer: border margin around contexts
    /// - Returns: A CGRect for the context UIView frame
    func frame(scale: CGFloat, start: Int, end: Int, width: CGFloat, buffer: CGFloat) -> CGRect {
        let bottom: Int
        if let next = next {
            bottom = next.timeInMinutes
        } else {
            bottom = end
        }
        return CGRect(x: buffer, y: buffer + navigationBarHeight + CGFloat(timeInMinutes - start) * scale, width: width, height: CGFloat(bottom - timeInMinutes) * scale)
    }
    
    
}
