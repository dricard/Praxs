//
//  Routine.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-05-05.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import Foundation

protocol ThingsThatNeedToBeDone {
    var name: String { get set }
    var time: Int { get set }
    var done: Bool { get set }
    func timeLabel() -> String
}

protocol ListOfThingsToBeDone {
    var tasks: [Task] { get set }
    mutating func complete(_ taskIndex: Int)
    mutating func reset()
}

extension ThingsThatNeedToBeDone {
    func timeLabel() -> String {
        return "\(time) min"
    }
}
extension ListOfThingsToBeDone {
    mutating func complete(_ taskIndex: Int) {
        tasks[taskIndex].done = true
    }
    
    mutating func reset() {
        for index in 0...(tasks.count - 1) {
            tasks[index].done = false
        }
    }
}

struct Task: ThingsThatNeedToBeDone {
    var name: String
    var time: Int
    var done: Bool = false
}

struct Routine: ListOfThingsToBeDone {
    var tasks = [Task]()
}
