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
    let minutesInADay: CGFloat = 24 * 60

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
        let verticalContextSize = view.bounds.height - 2 * buffer
        let horizontalContextSize = view.bounds.width - 2 * buffer
        let scale = verticalContextSize / minutesInADay
        for (_, context) in daily.contexts.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.timeInMinutes < rhs.timeInMinutes
        }).enumerated() {
            var bottom: CGFloat
            if context.next != nil {
                bottom = CGFloat(context.next!.timeInMinutes)
            } else {
                bottom = CGFloat(24*60)
            }
            let frame = CGRect(x: buffer, y: buffer + CGFloat(context.timeInMinutes) * scale, width: horizontalContextSize, height: (bottom - CGFloat(context.timeInMinutes)) * scale)
            cFrames.append((frame, context))
        }
        return cFrames
    }
    
    func dragContext(gestureRecognizer: UIPanGestureRecognizer) {
        let contextView = gestureRecognizer.view as! ContextView
        // get the context drawing area and the scale
        let verticalContextSize = view.bounds.height - 2 * buffer
        let horizontalContextSize = view.bounds.width - 2 * buffer
        let scale = verticalContextSize / minutesInADay
        var bottom: CGFloat = minutesInADay * scale
        guard let context = contextView.context else { return }
        let minimumUnitSize: CGFloat = scale * context.miniumuContextUnit
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: contextView.superview!)
            let adjustedTranslation = adjustTranslation(translation: translation.y, minimumStep: minimumUnitSize, scale: scale)
            if context.next != nil {
                bottom = CGFloat(context.next!.timeInMinutes) * scale
            }
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
                maximumPosition = 24 * 60 * scale
            }
            var newYPosition = contextView.topPosition + adjustedTranslation
            if newYPosition < minimumPosition { newYPosition = minimumPosition }
            if newYPosition > maximumPosition { newYPosition = maximumPosition }
            contextView.frame = CGRect(x: buffer, y: newYPosition, width: horizontalContextSize, height: bottom - newYPosition + buffer)
            let (hour, minutes) = timeFromPosition(y: newYPosition, scale: scale)
            contextView.timeLabel.text = "\(hour):\(minutes < 10 ? "0" : "")\(minutes)"
            if contextView.previous != nil {
                guard let previousContext = contextView.previous!.context else { return }
                contextView.previous!.frame = CGRect(x: buffer, y: buffer + CGFloat(previousContext.timeInMinutes) * scale, width: horizontalContextSize, height: newYPosition - CGFloat(previousContext.timeInMinutes) * scale)
            }
        } else if gestureRecognizer.state == .ended {
            // update time for each affected context depending on end position
            let (hour, minutes) = timeFromPosition(y: contextView.frame.origin.y, scale: scale)
            context.hour = hour
            context.minutes = minutes
            contextView.topPosition = contextView.frame.origin.y
        }
    }
    
    func timeFromPosition(y: CGFloat, scale: CGFloat) -> (Int, Int) {
        let timeInMinutes = (y - buffer) / scale
        let hour: Int = Int(timeInMinutes) / 60
        let minutes: Int = Int(timeInMinutes) % 60
        return (hour, minutes)
    }
    
    
    func adjustTranslation(translation: CGFloat, minimumStep: CGFloat, scale: CGFloat) -> CGFloat {
        let units = CGFloat(Int(round(translation / minimumStep))) * minimumStep
        return units
    }
}
