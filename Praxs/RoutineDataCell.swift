//
//  RoutineDataCell.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-05-05.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class RoutineDataCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var completedTasksLabel: UILabel!
    @IBOutlet weak var totalTasksLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var checkView: DoneCheckView!
    

}
