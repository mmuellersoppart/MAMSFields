//
//  HockeyFieldDimensions.swift
//  GamePlanV2
//
//  Created by Marlon Mueller Soppart on 7/30/21.
//

import Foundation
import SwiftUI

/*
 All the dimensions of a hockey field in absolute terms from a portrait perspective. All the dimensions
 are in meters based on this diagram,https://en.wikipedia.org/wiki/Ice_hockey_rink#/media/File:Ice_hockey_layout.svg .
 */
struct IceHockeyFieldConstants {
    
    static let fieldH: CGFloat = 61
    static let fieldW: CGFloat = 30
    static let fieldSize: Size2D = Size2D(x: fieldW, y: fieldH)
    
    static let totalH: CGFloat = 61
    static let totalW: CGFloat = 30
    static let totalSize: Size2D = Size2D(x: totalW, y: totalH)
    
    static let ratioHW: CGFloat = totalH/totalW
    static let ratioWH: CGFloat = totalW/totalH
    
    static let fieldCornerRadius: CGFloat = 8.5
    
    // generally for all points
    static let pointRadius: CGFloat = 0.4
    
    // center stuff
    static let centerLineLength: CGFloat = fieldW
    static let centerPoint: CGPoint = CGPoint(x: totalW / 2, y: totalH / 2)
    static let centerCircleRadius: CGFloat = 9 / 2
    
    // neutral area
    static let neutralAreaW: CGFloat = fieldW
    static let neutralAreaH: CGFloat = 17.66
    
    // in neutral area
    static let faceOffDotsH: CGFloat = neutralAreaH - 1.5 * 2
    static let faceOffDotsW: CGFloat = 13.4
    
    static let scoreKeeperBubbleRadius: CGFloat = 6 / 2
    
    // faceoff zones
    static let faceOffPointH: CGFloat = fieldH - 2 * (6.7 + 4)
    static let faceOffPointW: CGFloat = faceOffDotsW
    
    static let faceoffAreaLineLength: CGFloat = 10.2
    static let faceoffAreaLineSeparation: CGFloat = 0.9
    
    static let faceOffCircleRadius: CGFloat = 9 / 2
    
    // goal line (yikes)
    //width is tricky... maybe - trial and error
    static let goalLineLength: CGFloat = 27.4
    static let goalLineDistanceFromTop: CGFloat = 4
    
    // goal
    static let goalCreaseRadius: CGFloat = 3.66 / 2
    static let goalH: CGFloat = 1
    static let goalW: CGFloat = 1.83
    
}
