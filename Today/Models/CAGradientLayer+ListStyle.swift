//
//  CAGradientLayer+ListStyle.swift
//  Today
//
//  Created by Nikita  on 2/24/23.
//

import Foundation
import UIKit


extension CAGradientLayer {
    
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self{
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        
        switch style {
        case .today:
            beginColor = UIColor(named: "TodayGradientTodayBegin")!
            endColor = UIColor(named: "TodayGradientTodayEnd")!
        case .future:
            beginColor = UIColor(named: "TodayGradientFutureBegin")!
            endColor = UIColor(named: "TodayGradientFutureEnd")!
        case .all:
            beginColor = UIColor(named: "TodayGradientAllBegin")!
            endColor = UIColor(named: "TodayGradientAllEnd")!
        }
        
        return [beginColor.cgColor, endColor.cgColor]
    }
}
