//
//  TaskCell.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-05-05.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkView: DoneCheckView!
    
}
