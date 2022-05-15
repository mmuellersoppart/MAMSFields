//
//  SoccerField.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import Foundation
import SwiftUI
import MAMSVectors
import CoreGraphics

// modifies the original dimensions, in terms of scale and rotation to fit the given bounds.
class VolleyballField: Field {
    
    private typealias Constants = VolleyballFieldConstants
    
    private func centerArea(size: Size2D) -> Path {
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -size.x/2, y: -size.y/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = _adj(totalFieldVectors)
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
    }
    
    var total: Path {
        let totalSize = Constants.totalSize
        return centerArea(size: totalSize)
    }
    

    var field: Path {
        let fieldSize = Constants.fieldSize
        return centerArea(size: fieldSize)
    }

    var midline: Path {
        let totalW = Constants.midlineLength

        let leftLineAdj = _adj(PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: 0.0)))
        let rightLineAdj = _adj(PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalW/2, y: 0.0)))

        return Path { path in
            path.move(to: leftLineAdj.tip.asCGPoint)
            path.addLine(to: rightLineAdj.tip.asCGPoint)
        }
    }
    
    var netPoles: Path {
        let totalW = Constants.midlineLength
        let dotRadius = Constants.dotRadius

        let leftLinePtAdj = _adj(PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: 0.0))).tip
        let rightLinePtAdj = _adj(PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalW/2, y: 0.0))).tip
        
        return Path { path in
            path.addPath(leftLinePtAdj.asPath(pointDiameter: scale * dotRadius * 2))
            path.addPath(rightLinePtAdj.asPath(pointDiameter: scale * dotRadius * 2))
        }
    }
    
    var attackLines: Path {
        let attackAreaSize = Constants.attackLineArea
        return centerArea(size: attackAreaSize)
    }
}
