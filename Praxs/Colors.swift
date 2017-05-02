//
//  Colors.swift
//  Praxs
//
//  Created by Denis Ricard on 2017-04-25.
//  Copyright © 2017 Denis Ricard. All rights reserved.
//

import UIKit

/// Theme colors. Contains two arrays, one for contexts' background colors,
/// and one for contexts' text color. These are also used for the top handles
/// in the contextViews.
/// The `night` parameter is the index to use for the background (night) color.
struct Colors {
    static let night = 2
    static let context: [UIColor] = [PraxsStyleKit.context_01_color, PraxsStyleKit.context_02_color, PraxsStyleKit.context_03_color, PraxsStyleKit.context_04_color, PraxsStyleKit.context_05_color]
    static let text: [UIColor] = [PraxsStyleKit.context_01_textColor, PraxsStyleKit.context_02_textColor, PraxsStyleKit.context_03_textColor, PraxsStyleKit.context_04_textColor, PraxsStyleKit.context_05_textColor]
}
