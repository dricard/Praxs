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
    }
}

// MARK: - Datasource delegate

extension RoutineVC {
    
    func configure(cell: TaskCell, indexPath: IndexPath) {
        guard let routine = routine else { return }
        cell.nameLabel?.text = routine.tasks[indexPath.row].name
        cell.timeLabel?.text = routine.tasks[indexPath.row].timeLabel()
        cell.checkView.done = routine.tasks[indexPath.row].done
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let routine = routine else { return 0 }
        return routine.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
}
