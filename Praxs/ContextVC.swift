//
//  ContextVC.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-14.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

class ContextVC: UIViewController {

    // MARK: - Dependency Injection
    
    var daily: Daily?

    // MARK: - Properties
    
    var startingPostion: CGPoint = CGPoint.zero
    let buffer: CGFloat = 5
    let navigationBarHeight: CGFloat = 44 + 20 // navigation plus status bar
    var minutesInADay: Int {
        if let daily = daily {
            return daily.totalMinutes()
        } else {
            return 24 * 60
        }
    }

    var verticalContextSize: CGFloat {
        return view.bounds.height - 2 * buffer - navigationBarHeight
    }
    
    var horizontalContextSize: CGFloat {
        return view.bounds.width - 2 * buffer
    }
    
    var scale: CGFloat {
        return verticalContextSize / CGFloat(minutesInADay)
    }
    
    // MARK: - Type aliases
    
    typealias Time = (hours: Int, minutes: Int)
    typealias MinMaxY = (minimumY: Int, maximumY: Int)
    
    // MARK: - Outlets
    
    @IBOutlet weak var contextsView: UIView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contextsView.backgroundColor = Colors.context[Colors.night]
        contextsView.alpha = 1.0
        setupInterface()
    }
    
    // MARK: - Interface Methods
    
    func setupInterface() {
        guard var daily = daily else { return }
        // Set Contexts Views as subviews of contextsView
        // first sort the contexts
        daily.sort()
        // Divide the vertical space between contexts
        let contextFrames = generateContextsFrames(daily: daily)
        // add a subview per context. we keep a reference to the previous contextView
        var previousContextView: ContextView? = nil
        for (frame, context) in contextFrames {
            let contextView = ContextView(frame: frame, context: context, previous: previousContextView)
            previousContextView = contextView
            contextsView.addSubview(contextView)
            let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(ContextVC.dragContext))
            contextView.addGestureRecognizer(dragGesture)
            contextView.isUserInteractionEnabled = true
            dragGesture.delegate = self as? UIGestureRecognizerDelegate
        }
    }
    
    func generateContextsFrames(daily: Daily) -> [(CGRect, Context)] {
        var cFrames = [(CGRect, Context)]()
        for (_, context) in daily.contexts.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.timeInMinutes < rhs.timeInMinutes
        }).enumerated() {
            let frame = context.frame(scale: scale, start: daily.start, end: daily.end, width: horizontalContextSize, buffer: buffer)
            cFrames.append((frame, context))
        }
        return cFrames
    }
    
    func dragContext(gestureRecognizer: UIPanGestureRecognizer) {
        let contextView = gestureRecognizer.view as! ContextView
        // get the context drawing area and the scale
        guard let context = contextView.context, let daily = daily else { return }
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            // get the drag value
            let translation = gestureRecognizer.translation(in: contextView.superview!)
            let minMax = getMinMax(contextView: contextView, context: context, daily: daily)
            let newTime = newTimeFromPosition(translation: translation.y, minMax: minMax, topPosition: contextView.topPosition)
            context.hours = newTime.hours
            context.minutes = newTime.minutes
            contextView.timeLabel.text = context.timeLabel()
            contextView.frame = context.frame(scale: scale, start: daily.start, end: daily.end, width: horizontalContextSize, buffer: buffer)
            if contextView.previous != nil {
                guard let previousContext = contextView.previous!.context else { return }
                contextView.previous!.frame = previousContext.frame(scale: scale, start: daily.start, end: daily.end, width: horizontalContextSize, buffer: buffer)
            }
        } else if gestureRecognizer.state == .ended {
            // update saved starting time for affected context
            contextView.topPosition = context.timeInMinutes
        }
    }
    
    func newTimeFromPosition(translation: CGFloat, minMax: MinMaxY, topPosition: Int) -> Time {
        // we start with the currently saved "topPosition", i.e., the start time before
        // the drag action started.
        var timeInMinutes: Int = topPosition
        // then add the drag translated in minutes
        timeInMinutes += Int(translation / scale)
        // set min, max depending on surrounding contexts
        if timeInMinutes < minMax.minimumY { timeInMinutes = minMax.minimumY }
        if timeInMinutes > minMax.maximumY { timeInMinutes = minMax.maximumY }
        // convert to hour:Min
        let hour: Int = Int(timeInMinutes) / 60
        let minutes: Int = Int(timeInMinutes) % 60
        return (hour, minutes)
    }
    
    
    func getMinMax(contextView: ContextView, context: Context, daily: Daily) -> MinMaxY {
        let minimumPosition: Int
        if let previousContextView = contextView.previous, let previousContext = previousContextView.context {
            minimumPosition = previousContext.timeInMinutes + context.minimumContextDuration
        } else {
            minimumPosition = daily.start
        }
        let maximumPosition: Int
        if let nextContext = context.next {
            maximumPosition = nextContext.timeInMinutes - context.minimumContextDuration
        } else {
            maximumPosition = daily.end
        }
        return (minimumPosition, maximumPosition)
    }
    
}
