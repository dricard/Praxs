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
    
    var tasks: [Task]?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self

        tableView.reloadData()
    }
 }

extension RoutineVC {
    
    func configure(cell: UITableViewCell, indexPath: IndexPath) {
        guard let tasks = tasks else { return }
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.detailTextLabel?.text = tasks[indexPath.row].done ? "done" : "not done yet"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = tasks else { return 0 }
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineCell", for: indexPath)
        configure(cell: cell, indexPath: indexPath)
        return cell
    }
}
