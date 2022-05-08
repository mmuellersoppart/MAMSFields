//
//  File.swift
//  
//
//  Created by Marlon Mueller Soppart on 5/8/22.
//

import Foundation
import MAMSVectors
import SwiftUI

internal class Field {
    internal var scale: Double = 1
    internal var radians: Double = 0
    internal var centerPoint: Point2D = Point2D(x: 0, y: 0)
    
    init(scale: Double, radians: Double, centerPoint: Point2D) {
        self.radians = radians
        self.scale = scale
        self.centerPoint = centerPoint
    }

    internal func createMirroringRectangles(rectSize: CGSize, yValue: Double) -> Path {
        // establish size
        let upperLeftPoint = Point2D(x: centerPoint.x - rectSize.width/2, y: yValue)
    
        let upperVectors: [PositionalVector2D] = boxToVectors(vectorStartPoint: centerPoint, upperLeftPoint: upperLeftPoint, boxSize: rectSize)
        
        let upperVectorsAdj: [PositionalVector2D] = upperVectors.scaleAndRotate(scale: scale, rotate: radians)
        let upperGoalPaths = vectorsToPath(positionalVectors: upperVectorsAdj)
        
        let lowerVectorsAdj: [PositionalVector2D] = upperVectors.map {posvec in reflectOverMidline(midlineY: centerPoint.y, positionalVector: posvec)}.scaleAndRotate(scale: scale, rotate: radians)
        
        let lowerGoalPaths = vectorsToPath(positionalVectors: lowerVectorsAdj)
        
        return Path { path in
            path.addPath(upperGoalPaths)
            path.addPath(lowerGoalPaths)
        }
    }

    internal func reflectOverMidline(midlineY: Double, positionalVector: PositionalVector2D) -> PositionalVector2D {
        return positionalVector.copy(vectorY: -positionalVector.vector.y)
    }
}
