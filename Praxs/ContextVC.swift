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
    
    let buffer: CGFloat = 5 // space around the contexts
    let navigationBarHeight: CGFloat = 44 + 20 // navigation plus status bar
    
    /// Total number of minutes in a day available to context
    var minutesInADay: Int {
        if let daily = daily {
            return daily.totalMinutes()
        } else {
            return 24 * 60
        }
    }

    /// vertical screen size available to context
    var verticalContextSize: CGFloat {
        return view.bounds.height - 2 * buffer - navigationBarHeight
    }
    
    /// horizontal screen size available to context
    var horizontalContextSize: CGFloat {
        return view.bounds.width - 2 * buffer
    }
    
    /// screen scale in **CGFloat per minute**
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
//        contextsView.backgroundColor = UIColor.blue
        contextsView.alpha = 1.0
        setupInterface()
    }
    
    // MARK: - Interface Methods
    
    /// Initial setup of the contexts' views.
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
    
    /// Divide the vertical space available to contexts between them.
    /// This takes into account the start and end values of the Daily instance
    ///
    /// - Parameter daily: reference to the Daily instance
    /// - Returns: an array of tuples containing the CGRect for the contextView
    ///     and the corresponding context
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
    
    /// Handler for dragging a context start time. This only allows
    /// changing the start time of the dragged context. It is limited
    /// by the `minimumContextDuration` (defined in Context), both for
    /// the dragged context's duration, and for the previous context's.
    /// It only increments/decrements start time by `minimumContextUnit`
    /// (also defined in Context).
    ///
    /// - Parameter gestureRecognizer: gesture recognizer involved in drag.
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
    
    /// Converts the translation (drag value) to a new start time for the 
    /// context dragged (withing the min/max parameter).
    ///
    /// - Parameters:
    ///   - translation: vertical drag value (translation.y)
    ///   - minMax: a tuple with the minimum and maximum start time (in minutes)
    ///   - topPosition: context's start time prior to dragging
    /// - Returns: a new start time in minutes
    func newTimeFromPosition(translation: CGFloat, minMax: MinMaxY, topPosition: Int) -> Time {
        // we start with the currently saved "topPosition", i.e., 
        // the start time before the drag action started.
        var timeInMinutes: Int = topPosition
        // then add the drag translated in minutes
        timeInMinutes += Int(translation / scale)
        // And limit to the min, max depending on surrounding contexts
        if timeInMinutes < minMax.minimumY { timeInMinutes = minMax.minimumY }
        if timeInMinutes > minMax.maximumY { timeInMinutes = minMax.maximumY }
        // convert to hour:Min
        let hour: Int = Int(timeInMinutes) / 60
        let minutes: Int = Int(timeInMinutes) % 60
        return (hour, minutes)
    }
    
    /// Creates a tuple with the minimum and maximum start time for a context.
    /// This takes the previous context's start time and `minimumContextDuration`
    /// into account.
    ///
    /// - Parameters:
    ///   - contextView: the current context's ContextView
    ///   - context: the context being dragged
    ///   - daily: the Daily instance
    /// - Returns: a MinMax tuple
    func getMinMax(contextView: ContextView, context: Context, daily: Daily) -> MinMaxY {
        let minimumTime: Int
        if let previousContextView = contextView.previous, let previousContext = previousContextView.context {
            minimumTime = previousContext.timeInMinutes + context.minimumContextDuration
        } else {
            minimumTime = daily.start
        }
        let maximumTime: Int
        if let nextContext = context.next {
            maximumTime = nextContext.timeInMinutes - context.minimumContextDuration
        } else {
            maximumTime = daily.end - context.minimumContextDuration
        }
        return (minimumTime, maximumTime)
    }
    
}
