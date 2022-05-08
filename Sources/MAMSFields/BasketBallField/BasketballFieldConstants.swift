//
//  BasketballFieldDimensions.swift
//  GamePlanV2
//
//  Created by Marlon Mueller Soppart on 8/7/21.
//  https://www.dimensions.com/element/basketball-court
//

import Foundation
import SwiftUI

/// Field dimensions in meters from a portrait position
class BasketballFieldConstants {
    
    static let fieldH: CGFloat = 28.65
    static let fieldW: CGFloat = 15.24
    
    static let totalH: CGFloat = 28.65
    static let totalW: CGFloat = 15.24
    static let ratioHW: CGFloat = totalH/totalW
    static let ratioWH: CGFloat = totalW/totalH
    
    // generally for all points
    static let pointRadius: CGFloat = 1.22 / 2
    
    // center stuff
    static let centerLineLength: CGFloat = fieldW
    
    static let centerPoint: CGPoint = CGPoint(x: totalW / 2, y: totalH / 2)
    static let centerCircleRadius: CGFloat = 3.66 / 2
    
    // 3 point arc & box
    static let threePointArcRadius: CGFloat = 7.19
    static let threePointArcDistFromTop: CGFloat = hoopRadius + backboardDistFromTop
    
    static let threePointBoxH: CGFloat = 4.26
    static let threePointBoxW: CGFloat = totalW - 2 * 0.914
    
    // hoop
    static let hoopRadius: CGFloat = 0.457
    static let backboardDistFromTop: CGFloat = 1.22
    static let backboardW: CGFloat = 1.83
    
    // hoop arc & box
    static let hoopBoxH: CGFloat = 5.79
    static let hoopBoxW: CGFloat = 3.66
    
    static let outerHoopBoxH: CGFloat = hoopBoxH
    static let outerHoopBoxW: CGFloat = hoopBoxW + 2 * 0.7
    
    static let hoopBoxCircleRadius: CGFloat = centerCircleRadius
    static let hoopBoxCircleDistFromTop: CGFloat = hoopBoxH
    
    static let restrictedAreaRadius: CGFloat = 1.22
    static let restrictedAreaBoxH: CGFloat = hoopRadius + 0.03
    //trial and error
    static let restrictedAreaBoxW: CGFloat = backboardW + 0.615
}
