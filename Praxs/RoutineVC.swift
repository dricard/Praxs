//
//  RoutineVC.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-05-05.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class RoutineVC: UITableViewController {

    // MARK: - properties
    
    var routine: Routine?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        if var routine = routine {
            routine.reset()
            print(routine.numberOfCompletedTasks())
        }
        tableView.reloadData()
    }
 }

// MARK: - TableView Delegate

extension RoutineVC {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let routine = routine else { return }
        routine.tasks[indexPath.row].done = !(routine.tasks[indexPath.row].done)
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        cell.checkView.done = routine.tasks[indexPath.row].done
        tableView.reloadData()
    }
}

// MARK: - Datasource delegate

extension RoutineVC {
    
    func timeLabel(time: Int) -> String {
        if time >= 60 {
            let hours: Int = time / 60
            let minutes: Int = time % 60
            return "\(hours)h\(minutes < 10 ? "0" : "")\(minutes)m"
        } else {
            return "\(time) min"
        }
    }
    
    func configure(cell: TaskCell, indexPath: IndexPath) {
        guard let routine = routine else { return }
        cell.nameLabel?.text = routine.tasks[indexPath.row].name
        cell.timeLabel?.text = routine.tasks[indexPath.row].timeLabel()
        cell.checkView.done = routine.tasks[indexPath.row].done
    }
    
    func configureDataCell(cell: RoutineDataCell, indexPath: IndexPath) {
        guard let routine = routine else { return }
        cell.completedTasksLabel.text = "\(routine.numberOfUncompletedTasks())"
        cell.totalTasksLabel.text = "\(routine.totalNumberOfTasks())"
        cell.totalTimeLabel.text = timeLabel(time: routine.totalTimeForTasks())
        cell.timeRemainingLabel.text = timeLabel(time: routine.remainingTimeForTasks())
        if routine.numberOfCompletedTasks() == routine.tasks.count {
            cell.checkView.done = true
        } else {
            cell.checkView.done = false
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let routine = routine else { return 0 }
        if section == 0 {
            return 1
        } else {
            return routine.tasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! RoutineDataCell
            configureDataCell(cell: cell, indexPath: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            configure(cell: cell, indexPath: indexPath)
            return cell
        }
    }
}
