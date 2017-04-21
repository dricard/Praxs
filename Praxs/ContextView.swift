//
//  ContextView.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-14.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class ContextView: UIView {

    // MARK: - Properties
    var context: Context?
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var topPosition: CGFloat
    var previous: ContextView?
    
    init(frame: CGRect, context: Context, previous: ContextView?) {
        self.context = context
        self.topPosition = frame.origin.y
        self.previous = previous
        super.init(frame: frame)
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.context = nil
        self.topPosition = CGFloat(0)
        super.init(coder: aDecoder)
    }
        
    func setUpSubViews() {
        guard let context = context else { return }
        // set background color
        backgroundColor = context.color
        
        // create the labels
        // Name label
        let namelabelFrame = CGRect(x: 0, y: 0, width: 100, height: 20)
        nameLabel = UILabel(frame: namelabelFrame)
        addSubview(nameLabel)
        nameLabel.text = context.title
        nameLabel.textAlignment = .center
        
        // set constraints on name label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // time label
        let timelabelFrame = CGRect(x: 0, y: 0, width: 100, height: 20)
        timeLabel = UILabel(frame: timelabelFrame)
        addSubview(timeLabel)
        timeLabel.text = context.timeLabel()

        // set constraints on time label
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
