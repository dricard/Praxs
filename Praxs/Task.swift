//
//  task.swift
//  prouks
//
//  Created by Arnaud on 2017-04-12.
//  Copyright © 2017 arnaud. All rights reserved.
//

import Foundation

enum taskError: Error {
    case tagExists(msg:String)

}
struct Task{
    // default task hold values of a new task.
    var name:String = "Task Name"
    var duration:Double = 600.0
    var completions:Int = 0
    var tags: Set<String> = ([])
    var routineBonds:Set<String> = ([])
    
    mutating func changeDuration(to:Double){
        self.duration = to
    }
    mutating func complete (completions:Int) {
        self.completions += 1
    }
    mutating func tag(newTags:Set<String>){
      self.tags = tags.union(newTags)
    }
    mutating func boundToRoutine(routine:Set<String>){
        self.routineBonds = routineBonds.union(routine)
    }

}
// Use the TaskList object to populate the Task list tableView.

struct TaskList{
    var tasks = [Task]()
    subscript(index: Int) -> Task{  //to handle user's List of Tasks in TBV.
        get{                        //ex: cellForRow at:Tasklist[index]
            return tasks[index]
        }
        set{
            return tasks[index] = Task()
        }
    }
    mutating func append(_ task: Task){
        tasks.append(task)
    }
    mutating func insert(_ task:Task,at:Int){
        tasks.insert(task,at:at)
    }

}
// TagList object feeds EditTaskNameVC tableView

struct TagList{
    var tags:[String] = ["Workout","Health","Kitchen",                  //The Default tags (Open to proposistions)
                         "Grocery","Self-improvement",
                         "Brain-hacks","Yoga","Knowledge",
                         "Litterature"]
    func addNewTag(tag:String) throws -> TagList{
        if tags.contains(tag){
            throw taskError.tagExists(msg: "This tag already exist!")
        }
        else{
            var newList = tags
            newList.append(tag)
            return TagList(tags:newList)            
        }
    }
}





