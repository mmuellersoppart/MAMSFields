//
//  VolleyballConstants.swift
//  
//
//  Created by Marlon Mueller Soppart on 5/15/22.
//  Official dimensions of a volleyball court in meters. https://www.dimensions.com/element/volleyball-courts
//

import Foundation
import SwiftUI

/*
 All the dimensions of a standard soccer field, ignoring how it may be distorted. All the dimensions
 are in meters based on this diagram, https://soccertraininglab.com/how-big-are-soccer-fields/.
 */
struct VolleyballFieldConstants {
    
    // includes the free zone
    static let totalH: CGFloat = fieldH + 2 * 3
    static let totalW: CGFloat = fieldW + 2 * 3
    static let totalSize: Size2D = Size2D(x: totalW, y: totalH)
    
    static let fieldH: CGFloat = 18
    static let fieldW: CGFloat = 9
    static let fieldSize: Size2D = Size2D(x: fieldW, y: fieldH)
    
    static let dotRadius: CGFloat = 0.11
    
    static let attackLineArea: Size2D = Size2D(x: fieldW, y: 6)
    
    static let midlineLength: CGFloat = fieldW + 2 * 0.91
}
