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
    var topPosition: Int
    var previous: ContextView?
    
    init(frame: CGRect, context: Context, previous: ContextView?) {
        self.context = context
        if let context = self.context {
            self.topPosition = context.timeInMinutes
        } else {
            self.topPosition = 0
        }
        self.previous = previous
        super.init(frame: frame)
        setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.context = nil
        self.topPosition = 0
        super.init(coder: aDecoder)
    }
        
    func setUpSubViews() {
        guard let context = context else { return }
        // set background color
        backgroundColor = Colors.context[context.color]
        
        // create the labels
        // Name label
        let namelabelFrame = CGRect(x: 0, y: 0, width: 100, height: 14)
        nameLabel = UILabel(frame: namelabelFrame)
        addSubview(nameLabel)
        nameLabel.text = context.title
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = Colors.text[context.color]
        
        // set constraints on name label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: bounds.width / 2).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        // time label
        let timelabelFrame = CGRect(x: 0, y: 0, width: 20, height: 12)
        timeLabel = UILabel(frame: timelabelFrame)
        addSubview(timeLabel)
        timeLabel.text = context.timeLabel()
        timeLabel.textAlignment = .left
        timeLabel.textColor = Colors.text[context.color]
        timeLabel.font = UIFont.systemFont(ofSize: 10)

        // set constraints on time label
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true

        // set the top handle view
        let topHandleViewWidth: CGFloat = 45
        let topHandleViewHeight: CGFloat = 6
        let topHandleViewRect = CGRect(x: self.bounds.width / 2 - topHandleViewWidth / 2, y: 0, width: topHandleViewWidth, height: topHandleViewHeight)
        let topHandleView = TopHandleView(frame: topHandleViewRect)
        topHandleView.strokeColor = Colors.text[context.color]
        topHandleView.fillColor = Colors.context[context.color]
        addSubview(topHandleView)
        topHandleView.backgroundColor = UIColor.clear
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
