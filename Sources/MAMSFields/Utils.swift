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
internal func centerOrigin(_ rect: CGSize, on background: CGRect) -> CGPoint {
    
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
internal func boundingBox(canvasSize: CGSize, aspectRatio: Double, scale: Double, angle: Double) -> CGRect {
    
    guard isClose(Double.pi, angle, error: 0.01) else { return CGRect()}
    
    return CGRect()
}

internal func isClose(_ lhs: Double, _ rhs: Double, error ε: Double) -> Bool {
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

/// Produces four Position Vectors whose tips represent a box.
/// - Parameters:
///   - vectorStartPoint: Where all the positional vectors should start
///   - upperLeftPoint: Upper left point of the box
///   - boxSize: The box's height and width
/// - Returns: Positional Vectors that describe the box
internal func boxToVectors(vectorOrigin: Point2D, upperLeftPoint: Point2D, boxSize: CGSize) -> [PositionalVector2D] {
    let upperRightPoint = Point2D(x: upperLeftPoint.x + Double(boxSize.width), y: upperLeftPoint.y)
    let lowerLeftPoint = Point2D(x: upperLeftPoint.x, y: upperLeftPoint.y + Double(boxSize.height))
    let lowerRightPoint = Point2D(x: upperLeftPoint.x + Double(boxSize.width), y: upperLeftPoint.y + Double(boxSize.height))
    
    let upperPoints = [upperLeftPoint, upperRightPoint, lowerRightPoint, lowerLeftPoint]
    let upperVectors = upperPoints.map { pt in PositionalVector2D(start: vectorOrigin, end: pt)}
    
    return upperVectors
}

internal func vectorsToPath(positionalVectors posvecs: [PositionalVector2D]) -> Path {
    
    guard posvecs.count > 0 else { return Path() }
    
    return Path { path in
        path.move(to: posvecs.first!.tip.asCGPoint)
        
        for vec in posvecs {
            path.addLine(to: vec.tip.asCGPoint)
        }
        
        path.move(to: posvecs.last!.tip.asCGPoint)
        path.addLine(to: posvecs.first!.tip.asCGPoint)
        
        path.closeSubpath()
    }
}

internal func fourPoints(size: Size2D, customCenterPoint: Point2D) -> [PositionalVector2D] {
    let topY = customCenterPoint.y - size.y / 2
    let leftX = customCenterPoint.x - size.x / 2
    
    let upperLeft = PositionalVector2D(start: customCenterPoint, end: Point2D(x: leftX, y: topY))
    return vectorForEachQuadrant(positionalVector: upperLeft)
}

extension Collection where Element == PositionalVector2D {
    func scaleAndRotate(scale: Double, rotate: Double) -> [PositionalVector2D] {
        return self.map { elem in (scale * elem).copy(radians: rotate) }
    }
}
