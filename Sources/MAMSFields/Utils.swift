//
//  Utils.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 3/25/22.
//

import Foundation
import SwiftUI
import CoreGraphics
import MAMSVectors

/// We can extend CGRect

/// Centers one object on another
func centerOrigin(_ rect: CGSize, on background: CGRect) -> CGPoint {
    
    // width
    var originX: Double = 0
    if rect.width <= background.width {
        originX = (background.width - rect.width) / 2
        originX = originX + background.minX
    } else {
        originX = -1 * ((rect.width - background.width)/2)
        originX = originX + background.minX
    }
    
    // height
    var originY: Double = 0
    if rect.height <= background.height {
        originY = (background.height - rect.height) / 2
        originY = originY + background.minY
    } else {
        originY = -1 * ((rect.height - background.height)/2 )
        originY = originY + background.minY
    }
    
    return CGPoint(x: originX, y: originY)
}

/// Draws a bouding box on a canvas
/// - Parameters:
///   - canvasSize: space given to draw on
///   - aspectRatio: w/h
///   - scale: 0-1, The scale of the bounding box incomparison the space given
///   - angle: 0-2π, Orientation of the field, where π is portrait
/// - Returns: an outline stroke
func boundingBox(canvasSize: CGSize, aspectRatio: Double, scale: Double, angle: Double) -> CGRect {
    
    guard isClose(Double.pi, angle, error: 0.01) else { return CGRect()}
    
    return CGRect()
}

func isClose(_ lhs: Double, _ rhs: Double, error ε: Double) -> Bool {
    let Δ = lhs - rhs
    return abs(Δ) < ε
}

internal func vectorForEachQuadrant(positionalVector posvec: PositionalVector2D) -> [PositionalVector2D] {
    let commonPoint = posvec.origin
    let positiveVector = Vector2D(x: abs(posvec.vector.x), y: abs(posvec.vector.y))
    
    let q1 = PositionalVector2D(point: commonPoint, vector: Vector2D(x: -positiveVector.x, y: positiveVector.y))
    let q2 = PositionalVector2D(point: commonPoint, vector: positiveVector)
    let q3 = PositionalVector2D(point: commonPoint, vector: Vector2D(x: positiveVector.x, y: -positiveVector.y))
    let q4 = PositionalVector2D(point: commonPoint, vector: Vector2D(x: -positiveVector.x, y: -positiveVector.y))
    
    return [q1, q2, q3, q4]
}

//func determineFieldScale(boundaryH: CGFloat, boundaryW: Double, rotation: Double) -> Double {
//    let centerPoint = Point2D(x: boundaryW/2, y: boundaryH/2)
//    let fieldDimensionsW = BasicFieldDimensions.totalW
//    let fieldDimensionsH = BasicFieldDimensions.totalH
//    let q2PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: fieldDimensionsW/2, y: fieldDimensionsH/2)).copy(radians: rotation)
//    let q3PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: fieldDimensionsW/2, y: -fieldDimensionsH/2)).copy(radians: rotation)
//    
//    let q2Intersection = findClosestIntersection(positionalVector: q2PosVector, xBoundaries: 0.0, boundaryW, yBoundaries: 0.0, boundaryH)
//    let q3Intersection = findClosestIntersection(positionalVector: q3PosVector, xBoundaries: 0.0, boundaryW, yBoundaries: 0.0, boundaryH)
//    
//    let closestIntersection = centerPoint.distance(to: q2Intersection!) > centerPoint.distance(to: q3Intersection!) ? q3Intersection : q2Intersection
//
//    return centerPoint.distance(to: closestIntersection!) / centerPoint.distance(to: q2PosVector.tip)
//}
//
//func determineFieldScale1(boundaryH: CGFloat, boundaryW: Double, rotation: Double) -> Path {
//    let centerPoint = Point2D(x: boundaryW/2, y: boundaryH/2)
//    let fieldDimensionsW = BasicFieldDimensions.totalW
//    let fieldDimensionsH = BasicFieldDimensions.totalH
//    
//    let q2PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: fieldDimensionsW/2, y: fieldDimensionsH/2)).copy(radians: rotation)
//    let q3PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: fieldDimensionsW/2, y: -fieldDimensionsH/2)).copy(radians: rotation)
//    
//    let q2Intersection = findClosestIntersection(positionalVector: q2PosVector, xBoundaries: 0.0, boundaryW, yBoundaries: 0.0, boundaryH)
//    let q3Intersection = findClosestIntersection(positionalVector: q3PosVector, xBoundaries: 0.0, boundaryW, yBoundaries: 0.0, boundaryH)
//    
//    let closerIntersection = centerPoint.distance(to: q2Intersection!) > centerPoint.distance(to: q3Intersection!) ? q3Intersection : q2Intersection
//    
//    return Path { path in
//        
//        // draw center point
//        path.move(to: centerPoint.asCGPoint)
//        path.addPath(centerPoint.asPath(pointDiameter: 4))
//        
//        path.addPath(q2PosVector.asPath())
//        
//        // draw intersection points
//        path.move(to: q2Intersection!.asCGPoint)
//        path.addPath(q2Intersection!.asPath(pointDiameter: 6))
//        
//        path.move(to: q3Intersection!.asCGPoint)
//        path.addPath(q3Intersection!.asPath(pointDiameter: 6))
//        
//        path.move(to: closerIntersection!.asCGPoint)
//        path.addPath(closerIntersection!.asPath(pointDiameter: 12))
//    }
//    
//    
//}

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

extension Collection where Element == PositionalVector2D {
    func scaleAndRotate(scale: Double, rotate: Double) -> [PositionalVector2D] {
        return self.map { elem in (scale * elem).copy(radians: rotate) }
    }
}
