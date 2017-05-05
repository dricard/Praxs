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
    func numberOfCompletedTasks() -> Int
    func totalNumberOfTasks() -> Int
}

extension ThingsThatNeedToBeDone {
    func timeLabel() -> String {
        if time >= 60 {
            let hours: Int = time / 60
            let minutes: Int = time % 60
            return "\(hours)h\(minutes < 10 ? "0" : "")\(minutes)m"
        } else {
            return "\(time) min"
        }
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
    
    func numberOfCompletedTasks() -> Int {
        let number = tasks.reduce(0, { sum, task in
            sum + (task.done ? 1 : 0)
        })
        return number
    }

    func numberOfUncompletedTasks() -> Int {
        let number = tasks.reduce(0, { sum, task in
            sum + (task.done ? 0 : 1)
        })
        return number
    }

    func totalNumberOfTasks() -> Int {
        return tasks.count
    }

    func totalTimeForTasks() -> Int {
        let number = tasks.reduce(0, { sum, task in
            sum + task.time
        })
        return number
    }
    
    func remainingTimeForTasks() -> Int {
        let number = tasks.reduce(0, { sum, task in
            sum + (task.done == false ? task.time : 0)
        })
        return number
    }

}

class Task: ThingsThatNeedToBeDone {
    var name: String
    var time: Int
    var done: Bool = false
    
    init(name: String, time: Int, done: Bool) {
        self.name = name
        self.time = time
        self.done = done
    }
}

struct Routine: ListOfThingsToBeDone {
    var tasks = [Task]()
}


