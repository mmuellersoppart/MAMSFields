//
//  File.swift
//  
//
//  Created by Marlon Mueller Soppart on 5/8/22.
//

import Foundation
import MAMSVectors
import SwiftUI

class BasketballField: Field {
    
    var totalField: Path {
        let totalH = BasketballFieldConstants.totalH
        let totalW = BasketballFieldConstants.totalW
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: -totalH/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = totalFieldVectors.map {pos in scale * pos}.map { pos in pos.copy(radians: radians)}
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
    }
}
