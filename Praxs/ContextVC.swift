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
    let navigationBarHeight: CGFloat = 44
    var minutesInADay: CGFloat {
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
        return verticalContextSize / minutesInADay
    }
    
    // MARK: - Type aliases
    
    typealias Time = (hours: Int, minutes: Int)
    typealias MinMaxY = (minimumY: CGFloat, maximumY: CGFloat)
    
    // MARK: - Outlets
    
    @IBOutlet weak var contextsView: UIView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contextsView.backgroundColor = Colors.context[Colors.night]
        contextsView.alpha = 1.0
        updateInterface()
    }

    // MARK: - Utilities
    
    func timeString(_ time: Time) -> String {
        return "\(time.hours):\(time.minutes < 10 ? "0" : "")\(time.minutes)"
    }
    
    // MARK: - Interface Methods
    
    func updateInterface() {
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
        print("minutes: \(minutesInADay), scale: \(scale)")
        for (_, context) in daily.contexts.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.timeInMinutes < rhs.timeInMinutes
        }).enumerated() {
            let bottom = maxFramePosition(context: context, daily: daily)
            let frame = context.frame(scale: scale, start: daily.start, width: horizontalContextSize, bottom: bottom, buffer: buffer)
            cFrames.append((frame, context))
        }
        return cFrames
    }
    
    func dragContext(gestureRecognizer: UIPanGestureRecognizer) {
        let contextView = gestureRecognizer.view as! ContextView
        // get the context drawing area and the scale
        guard let context = contextView.context, let daily = daily else { return }
        let minimumUnitSize: CGFloat = scale * context.minimumContextUnit
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            // get the drag value
            let translation = gestureRecognizer.translation(in: contextView.superview!)
            // adjust it so that we have steps corresponding to the minimum unit size (e.g., 5 min)
            let adjustedTranslation = adjustTranslation(translation: translation.y, minimumStep: minimumUnitSize, contextView: contextView, context: context, daily: daily)
            print("translation: \(translation.y), adjusted: \(adjustedTranslation)")
            /* REFACTORING */
            
            let newYPosition = newPositionFromTranslation(contextView: contextView, context: context, daily: daily, translation: adjustedTranslation)
            let newTime = newTimeFromPosition(y: newYPosition)
            print(timeString(newTime))
            contextView.timeLabel.text = timeString(newTime)
            context.hour = newTime.hours
            context.minutes = newTime.minutes
            let bottom = maxFramePosition(context: context, daily: daily)
            contextView.frame = context.frame(scale: scale, start: daily.start, width: horizontalContextSize, bottom: bottom, buffer: buffer)
            if contextView.previous != nil {
                guard let previousContext = contextView.previous!.context else { return }
                let previousBottom = maxFramePosition(context: previousContext, daily: daily)
                contextView.previous!.frame = previousContext.frame(scale: scale, start: daily.start, width: horizontalContextSize, bottom: previousBottom, buffer: buffer)
            }
        } else if gestureRecognizer.state == .ended {
            // update time for each affected context depending on end position
            let (hour, minutes) = newTimeFromPosition(y: contextView.frame.origin.y)
            context.hour = hour
            context.minutes = minutes
            contextView.topPosition = contextView.frame.origin.y
        }
    }
    
    func newTimeFromPosition(y: CGFloat) -> Time {
        let timeInMinutes: Int
        if let daily = daily {
            timeInMinutes = Int((y - buffer) / scale + daily.start)
        } else {
            timeInMinutes = Int((y - buffer) / scale)
        }
        let hour: Int = Int(timeInMinutes) / 60
        let minutes: Int = Int(timeInMinutes) % 60
        return (hour, minutes)
    }
    
    
    func adjustTranslation(translation: CGFloat, minimumStep: CGFloat, contextView: ContextView, context: Context, daily: Daily) -> CGFloat {
        let position = newPositionFromTranslation(contextView: contextView, context: context, daily: daily, translation: translation)
        print("position: \(position)")
        let nonAdjustedTimeFromTranslation = newTimeFromPosition(y: translation)
        print("non adjusted time: \(nonAdjustedTimeFromTranslation)")
        let minutes = nonAdjustedTimeFromTranslation.hours * 60 + nonAdjustedTimeFromTranslation.minutes
        print("minutes: \(minutes)")
        let timeStep = Int(context.minimumContextUnit)
        print("timeStep: \(timeStep)")
        let adjustedTime = (minutes % timeStep) > 2 ? (Int(minutes / timeStep) + 1) * timeStep : Int(minutes / timeStep) * timeStep
        print("adjustedTime: \(adjustedTime)")
        let adjustedTranslation = (CGFloat(adjustedTime) - daily.start) * scale + buffer
        print("adjusted translation: \(adjustedTranslation)")
//        let units = CGFloat(Int(round(translation / minimumStep))) * minimumStep
        return translation + adjustedTranslation
    }
    
    func getMinMax(contextView: ContextView, context: Context, daily: Daily) -> MinMaxY {
        let minimumPosition: CGFloat
        if contextView.previous != nil {
            minimumPosition = contextView.previous!.topPosition + context.minimumContextDuration * scale
        } else {
            minimumPosition = buffer
        }
        let maximumPosition: CGFloat
        if let next = context.next {
            maximumPosition = (CGFloat(next.timeInMinutes) - context.minimumContextDuration) * scale
        } else {
            maximumPosition = daily.end * scale
        }
       return (minimumPosition, maximumPosition)
    }
    
    func newPositionFromTranslation(contextView: ContextView, context: Context, daily: Daily, translation: CGFloat) -> CGFloat {
        let minMaxY = getMinMax(contextView: contextView, context: context, daily: daily)
        var newYPosition = contextView.topPosition + translation
        if newYPosition < minMaxY.minimumY { newYPosition = minMaxY.minimumY }
        if newYPosition > minMaxY.maximumY { newYPosition = minMaxY.maximumY }
        return newYPosition
    }
    
    func maxFramePosition(context: Context, daily: Daily) -> CGFloat {
        var bottom: CGFloat
        if context.next != nil {
            bottom = CGFloat(context.next!.timeInMinutes) - daily.start
        } else {
            bottom = CGFloat(minutesInADay)
        }
        return bottom
    }

}
