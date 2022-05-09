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
    
    
    // three point box (including arc)
    var threePointBoxes: Path {
        func _adj(_ posvec: PositionalVector2D) -> PositionalVector2D {
            (scale * posvec).copy(radians: radians)
        }
        
        let topLine = centerPoint.y - BasketballFieldConstants.fieldH/2
        let threePointBoxSize = Size2D(x: BasketballFieldConstants.threePointBoxW, y: BasketballFieldConstants.threePointBoxH)
        
        // Get the four positional vectors representing the box
        let upperLeftTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - (threePointBoxSize.x / 2), y: topLine))
        let upperRightTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + (threePointBoxSize.x / 2), y: topLine))
        let lowerLeftTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - (threePointBoxSize.x / 2), y: topLine + threePointBoxSize.y))
        let lowerRightTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + (threePointBoxSize.x / 2), y: topLine + threePointBoxSize.y))

        // bottom part
        let upperLeftBottomAdj = _adj(reflectOverMidline(midlineY: centerPoint.y, positionalVector: upperLeftTop))
        let upperRightBottomAdj = _adj(reflectOverMidline(midlineY: centerPoint.y, positionalVector: upperRightTop))
        let lowerLeftBottomAdj = _adj(reflectOverMidline(midlineY: centerPoint.y, positionalVector: lowerLeftTop))
        let lowerRightBottomAdj = _adj(reflectOverMidline(midlineY: centerPoint.y, positionalVector: lowerRightTop))
        
        // adj
        let upperLeftTopAdj = _adj(upperLeftTop)
        let upperRightTopAdj = _adj(upperRightTop)
        let lowerLeftTopAdj = _adj(lowerLeftTop)
        let lowerRightTopAdj = _adj(lowerRightTop)
        
        // arc
        let arcY: Double = topLine + BasketballFieldConstants.threePointArcDistFromTop
        let arcCenter = Point2D(x: centerPoint.x, y: arcY)
        let arcRadiusAdj = scale * BasketballFieldConstants.threePointArcRadius
        
        let arcCenterPositionalVectorAdj = PositionalVector2D(start: centerPoint, end: arcCenter)
        let arcCenterAdj: Point2D = _adj(arcCenterPositionalVectorAdj).tip
        let arcCenterBottomAdj: Point2D = _adj(reflectOverMidline(midlineY: centerPoint.y, positionalVector: arcCenterPositionalVectorAdj)).tip
        
        
        return Path { path in
            
            // draw sides
            path.move(to: upperLeftTopAdj.tip.asCGPoint)
            path.addLine(to: lowerLeftTopAdj.tip.asCGPoint)

            path.move(to: upperRightTopAdj.tip.asCGPoint)
            path.addLine(to: lowerRightTopAdj.tip.asCGPoint)
            
            path.move(to: upperLeftBottomAdj.tip.asCGPoint)
            path.addLine(to: lowerLeftBottomAdj.tip.asCGPoint)
            
            path.move(to: upperRightBottomAdj.tip.asCGPoint)
            path.addLine(to: lowerRightBottomAdj.tip.asCGPoint)
            
            // draw arcs
            path.move(to: lowerRightTopAdj.tip.asCGPoint)
            path.addArc(center: arcCenterAdj.asCGPoint, radius: arcRadiusAdj, startAngle: Angle(radians: Double.pi/8.5 + radians), endAngle: Angle(radians: (Double.pi * 0.885) + radians), clockwise: false)
            
            path.move(to: lowerRightBottomAdj.tip.asCGPoint)
//            path.addPath(arcCenterBottomAdj.asPath(pointDiameter: 4))
            path.addArc(center: arcCenterBottomAdj.asCGPoint, radius: arcRadiusAdj, startAngle: Angle(radians: 2 * Double.pi * 0.942 + radians), endAngle: Angle(radians: Double.pi * 1.115 + radians), clockwise: true)
        }
    }
    
//    static let threePointBoxH: CGFloat = 4.26
//    static let threePointBoxW: CGFloat = totalW - 2 * 0.914
}
