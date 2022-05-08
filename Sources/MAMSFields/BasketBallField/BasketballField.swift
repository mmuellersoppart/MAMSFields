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
    
    var field: Path {
        let fieldSize = Size2D(x: BasketballFieldConstants.fieldW, y: BasketballFieldConstants.fieldH)
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -fieldSize.x/2, y: -fieldSize.y/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = totalFieldVectors.map {pos in scale * pos}.map { pos in pos.copy(radians: radians)}
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
    }
    
    var midline: Path {
        let totalW = BasketballFieldConstants.totalW
        
        let leftLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: 0.0))).copy(radians: radians)
        let rightLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalW/2, y: 0.0))).copy(radians: radians)
        
        return Path { path in
            path.move(to: leftLine.tip.asCGPoint)
            path.addLine(to: rightLine.tip.asCGPoint)
        }
    }
    
    var centerCircleOuter: Path {
        return centerPoint.asPath(pointDiameter: BasketballFieldConstants.centerCircleOuterRadius * scale * 2)
    }
    
    var centerCircleInner: Path {
        return centerPoint.asPath(pointDiameter: BasketballFieldConstants.centerCircleInnerRadius * scale * 2)
    }
    
}
