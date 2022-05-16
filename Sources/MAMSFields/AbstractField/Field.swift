//
//  File.swift
//  
//
//  Created by Marlon Mueller Soppart on 5/8/22.
//

import Foundation
import MAMSVectors
import SwiftUI

public class Field {
    internal var scale: Double = 1
    internal var centerPoint: Point2D = Point2D(x: 0, y: 0)
    internal var radians: Double = 0
    
    init(scale: Double, radians: Double, centerPoint: Point2D) {
        self.radians = radians
        self.scale = scale
        self.centerPoint = centerPoint
    }

    internal static func determineFieldScale(totalFieldSize: Size2D, boundarySize: Size2D, rotation: Double) -> Double {
        
        func findClosestIntersection(positionalVector posVector: PositionalVector2D, xBoundaries: Double..., yBoundaries: Double...) -> Point2D? {
            //TODO: sort x and y boundaries and make sure it goes from least to most.
            
            let centerPoint = posVector.origin
            
            // find the closest point
            var points: [Point2D?] = []
            for xBound in xBoundaries {
                points.append(posVector.intercept(x: xBound))
            }
            
            for yBound in yBoundaries {
                points.append(posVector.intercept(y: yBound))
            }
            
            let closestPoint = points.compactMap{$0}.sorted(by: {lhs, rhs in centerPoint.distance(to: lhs) < centerPoint.distance(to: rhs)}).first
            
            return closestPoint
        }
        
        let centerPoint = Point2D(x: boundarySize.x/2, y: boundarySize.y/2)
        let q2PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalFieldSize.x/2, y: totalFieldSize.y/2)).copy(radians: rotation)
        let q3PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalFieldSize.x/2, y: -totalFieldSize.y/2)).copy(radians: rotation)
        
        let q2Intersection = findClosestIntersection(positionalVector: q2PosVector, xBoundaries: 0.0, boundarySize.x, yBoundaries: 0.0, boundarySize.y)
        let q3Intersection = findClosestIntersection(positionalVector: q3PosVector, xBoundaries: 0.0, boundarySize.x, yBoundaries: 0.0, boundarySize.y)
        
        let closestIntersection = centerPoint.distance(to: q2Intersection!) > centerPoint.distance(to: q3Intersection!) ? q3Intersection : q2Intersection
        
        return centerPoint.distance(to: closestIntersection!) / centerPoint.distance(to: q2PosVector.tip)
    }
    
    internal func createMirroringRectangles(rectSize: CGSize, yValue: Double) -> Path {
        // establish size
        let upperLeftPoint = Point2D(x: centerPoint.x - rectSize.width/2, y: yValue)
    
        let upperVectors: [PositionalVector2D] = boxToVectors(vectorOrigin: centerPoint, upperLeftPoint: upperLeftPoint, boxSize: rectSize)
        
        let upperVectorsAdj: [PositionalVector2D] = upperVectors.scaleAndRotate(scale: scale, rotate: radians)
        let upperGoalPaths = vectorsToPath(positionalVectors: upperVectorsAdj)
        
        let lowerVectorsAdj: [PositionalVector2D] = upperVectors.map {posvec in mirrorY(posvec, over: centerPoint.y)}.scaleAndRotate(scale: scale, rotate: radians)
        
        let lowerGoalPaths = vectorsToPath(positionalVectors: lowerVectorsAdj)
        
        return Path { path in
            path.addPath(upperGoalPaths)
            path.addPath(lowerGoalPaths)
        }
    }

    internal func mirrorY(_ positionalVector: PositionalVector2D, over midlineY: Double) -> PositionalVector2D {
        return positionalVector.copy(vectorY: -positionalVector.vector.y)
    }
    
    internal func _adj(_ posvec: PositionalVector2D) -> PositionalVector2D {
        (scale * posvec).copy(radians: radians)
    }
    
    func _adj(_ vectors: [PositionalVector2D]) -> [PositionalVector2D] {
        return vectors.map { elem in (scale * elem).copy(radians: radians) }
    }
    

}
