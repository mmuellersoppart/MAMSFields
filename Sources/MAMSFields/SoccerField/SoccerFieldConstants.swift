//
//  SoccerFieldConstants.swift
//
//  Created by Marlon Mueller Soppart on 6/21/21.
//

import Foundation
import SwiftUI

/*
 All the dimensions of a standard soccer field, ignoring how it may be distorted. All the dimensions
 are in meters based on this diagram, https://soccertraininglab.com/how-big-are-soccer-fields/.
 */
struct SoccerFieldConstants {
    
    static let fieldH: CGFloat = 120
    static let fieldW: CGFloat = 90
    
    static let totalH: CGFloat = fieldH + goalH * 2
    static let totalW: CGFloat = fieldW
    static let ratioHW: CGFloat = totalH/totalW
    static let ratioWH: CGFloat = totalW/totalH
    
    static let centerPoint: CGPoint = CGPoint(x: totalW / 2, y: totalH / 2)
    
    static let dotRadius: CGFloat = 1
    
    static let centerLineLength: CGFloat = 90
    static let centerCircleRadius: CGFloat = 9.15
    
    static let penaltyAreaH: CGFloat = 16.5
    static let penaltyAreaW: CGFloat = 40.3
    
    static let goalieAreaH: CGFloat = 5.5
    static let goalieAreaW: CGFloat = 18.3
    
    static let goalH: CGFloat = 3
    static let goalW: CGFloat = 7.3
    
    static let penatlyDotDistance: CGFloat = 11.0
    
    static let penaltyArcRadius: CGFloat = 9.15
    
    static let cornerArcRadius: CGFloat = 3
}
