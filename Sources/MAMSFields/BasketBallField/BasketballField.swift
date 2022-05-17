//
//  File.swift
//  
//
//  Created by Marlon Mueller Soppart on 5/8/22.
//

import Foundation
import MAMSVectors
import SwiftUI

public class BasketballField: Field {
    
    private typealias Constants = BasketballFieldConstants
    
    var totalField: Path {
        let totalH = BasketballFieldConstants.totalH
        let totalW = BasketballFieldConstants.totalW
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: -totalH/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = totalFieldVectors.map {pos in scale * pos}.map { pos in pos.copy(radians: radians)}
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
    }
    
    public var totalBoundingBoxSize: Size2D {
        let totalSize = Size2D(x: Constants.totalW, y: Constants.totalH)
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalSize.x/2, y: -totalSize.y/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = _adj(totalFieldVectors)
        
        let xValues = totalFieldVectorsAdj.map {posvec in posvec.tip.x}
        let maxX = xValues.max()!
        let minX = xValues.min()!
        
        let yValues = totalFieldVectorsAdj.map {posvec in posvec.tip.y}
        let maxY = yValues.max()!
        let minY = yValues.min()!
        
        return Size2D(x: maxX - minX, y: maxY - minY)
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
        
        let topLine = centerPoint.y - BasketballFieldConstants.fieldH/2
        let threePointBoxSize = Size2D(x: BasketballFieldConstants.threePointBoxW, y: BasketballFieldConstants.threePointBoxH)
        
        // Get the four positional vectors representing the box
        let upperLeftTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - (threePointBoxSize.x / 2), y: topLine))
        let upperRightTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + (threePointBoxSize.x / 2), y: topLine))
        let lowerLeftTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - (threePointBoxSize.x / 2), y: topLine + threePointBoxSize.y))
        let lowerRightTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + (threePointBoxSize.x / 2), y: topLine + threePointBoxSize.y))

        // bottom part
        let upperLeftBottomAdj = _adj(mirrorY(upperLeftTop, over: centerPoint.y))
        let upperRightBottomAdj = _adj(mirrorY(upperRightTop, over: centerPoint.y))
        let lowerLeftBottomAdj = _adj(mirrorY(lowerLeftTop, over: centerPoint.y))
        let lowerRightBottomAdj = _adj(mirrorY(lowerRightTop, over: centerPoint.y))
        
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
        let arcCenterBottomAdj: Point2D = _adj(mirrorY(arcCenterPositionalVectorAdj, over: centerPoint.y)).tip
        
        
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
            path.addArc(center: arcCenterBottomAdj.asCGPoint, radius: arcRadiusAdj, startAngle: Angle(radians: 2 * Double.pi * 0.942 + radians), endAngle: Angle(radians: Double.pi * 1.115 + radians), clockwise: true)
        }
    }
    
    // mini box as base with arc (including arc)
    var restrictedAreas: Path {
        
        let topLine = centerPoint.y - BasketballFieldConstants.fieldH/2
        let backboardY = topLine + BasketballFieldConstants.backboardDistFromTop
        let restrictedBoxSize = Size2D(x: BasketballFieldConstants.restrictedAreaBoxW, y: BasketballFieldConstants.restrictedAreaBoxH)
        
        // Get the four positional vectors representing the box
        let upperLeftTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - (restrictedBoxSize.x / 2), y: backboardY))
        let upperRightTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + (restrictedBoxSize.x / 2), y: backboardY))
        let lowerLeftTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - (restrictedBoxSize.x / 2), y: backboardY + restrictedBoxSize.y))
        let lowerRightTop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + (restrictedBoxSize.x / 2), y: backboardY + restrictedBoxSize.y))

        // bottom part
        let upperLeftBottomAdj = _adj(mirrorY(upperLeftTop, over: centerPoint.y))
        let upperRightBottomAdj = _adj(mirrorY(upperRightTop, over: centerPoint.y))
        let lowerLeftBottomAdj = _adj(mirrorY(lowerLeftTop, over: centerPoint.y))
        let lowerRightBottomAdj = _adj(mirrorY(lowerRightTop, over: centerPoint.y))
        
        // adj
        let upperLeftTopAdj = _adj(upperLeftTop)
        let upperRightTopAdj = _adj(upperRightTop)
        let lowerLeftTopAdj = _adj(lowerLeftTop)
        let lowerRightTopAdj = _adj(lowerRightTop)
        
        // arc
        let arcY: Double = backboardY + restrictedBoxSize.y
        let arcCenter = Point2D(x: centerPoint.x, y: arcY)
        let arcRadiusAdj = scale * BasketballFieldConstants.restrictedAreaRadius
        
        let arcCenterPositionalVectorAdj = PositionalVector2D(start: centerPoint, end: arcCenter)
        let arcCenterAdj: Point2D = _adj(arcCenterPositionalVectorAdj).tip
        let arcCenterBottomAdj: Point2D = _adj(mirrorY(arcCenterPositionalVectorAdj, over: centerPoint.y)).tip
        
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
            path.addArc(center: arcCenterAdj.asCGPoint, radius: arcRadiusAdj, startAngle: Angle(radians: 0.0 + radians), endAngle: Angle(radians: Double.pi + radians), clockwise: false)
            
            path.move(to: lowerRightBottomAdj.tip.asCGPoint)
            path.addArc(center: arcCenterBottomAdj.asCGPoint, radius: arcRadiusAdj, startAngle: Angle(radians: 0.0 + radians), endAngle: Angle(radians: Double.pi + radians), clockwise: true)
        }
    }
    
    var outerHoopBoxes: Path {
        let outerHoopBoxSize = CGSize(width: BasketballFieldConstants.outerHoopBoxW, height: BasketballFieldConstants.outerHoopBoxH)
        let fieldH = BasketballFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        
        return createMirroringRectangles(rectSize: outerHoopBoxSize, yValue: topLine)
    }
    
    var hoopBoxes: Path {
        let hoopBoxSize = CGSize(width: BasketballFieldConstants.hoopBoxW, height: BasketballFieldConstants.hoopBoxH)
        let fieldH = BasketballFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        
        return createMirroringRectangles(rectSize: hoopBoxSize, yValue: topLine)
    }
    
    // includes the backboard
    var hoops: Path {
        let topLine = centerPoint.y - BasketballFieldConstants.fieldH/2
        let backboardY = topLine + BasketballFieldConstants.backboardDistFromTop
        
        let bottomLine = centerPoint.y + BasketballFieldConstants.fieldH/2
        let backboardYBottom = bottomLine - BasketballFieldConstants.backboardDistFromTop
        
        let hoopRadius = BasketballFieldConstants.hoopRadius
        let hoopCenterY = backboardY + hoopRadius
        
        
        let topHoop = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x, y: hoopCenterY))
        
        let topHoopAdj = _adj(topHoop)
        let bottomHoopAdj = _adj(mirrorY(topHoop, over: centerPoint.y))
                            
        let topBackboardAdj = (
            _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - BasketballFieldConstants.backboardW / 2, y: backboardY))),
            _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + BasketballFieldConstants.backboardW / 2, y: backboardY)))
        )
        
        let bottomBackboardAdj = (
            _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - BasketballFieldConstants.backboardW / 2, y: backboardYBottom))),
            _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + BasketballFieldConstants.backboardW / 2, y: backboardYBottom)))
        )
        
        return Path { path in
            path.addPath(topHoopAdj.tip.asPath(pointDiameter: hoopRadius * 2 * scale))
            path.addPath(bottomHoopAdj.tip.asPath(pointDiameter: hoopRadius * 2 * scale))
            
            path.move(to: topBackboardAdj.0.tip.asCGPoint)
            path.addLine(to: topBackboardAdj.1.tip.asCGPoint)
            
            path.move(to: bottomBackboardAdj.0.tip.asCGPoint)
            path.addLine(to: bottomBackboardAdj.1.tip.asCGPoint)
        }
    }
    
    var hoopBoxCircles: Path {
        let hoopBoxCircleDistFromTop = BasketballFieldConstants.hoopBoxCircleDistFromTop
        let hoopBoxCircleRadiusAdj = 2 * BasketballFieldConstants.hoopBoxCircleRadius * scale
        
        let topLine = centerPoint.y - BasketballFieldConstants.fieldH/2
        
        let hoopY = topLine + hoopBoxCircleDistFromTop
        let topCircle = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x, y: hoopY))
        let topCircleAdj = _adj(topCircle)
        
        let bottomCircleAdj = _adj(mirrorY(topCircle, over: centerPoint.y))
        
        return Path { path in
            path.addPath(topCircleAdj.tip.asPath(pointDiameter: hoopBoxCircleRadiusAdj))
            path.addPath(bottomCircleAdj.tip.asPath(pointDiameter: hoopBoxCircleRadiusAdj))
        }
    }
    
    var hoopBoxCircleHalves: Path {
        let hoopBoxCircleDistFromTop = BasketballFieldConstants.hoopBoxCircleDistFromTop
        let hoopBoxCircleRadiusAdj = 2 * BasketballFieldConstants.hoopBoxCircleRadius * scale
        
        let topLine = centerPoint.y - BasketballFieldConstants.fieldH/2
        
        let hoopY = topLine + hoopBoxCircleDistFromTop
        let topCircle = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x, y: hoopY))
        
        let topCircleAdj = _adj(topCircle)
        let bottomCircleAdj = _adj(mirrorY(topCircle, over: centerPoint.y))
        
        let topStartingPoint = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + BasketballFieldConstants.hoopBoxCircleRadius, y: hoopY))
        let topStartingPointAdj = _adj(topStartingPoint)
        
        let bottomStartingPointAdj = _adj(mirrorY(topStartingPoint, over: centerPoint.y))
        
        return Path { path in
            path.move(to: topStartingPointAdj.tip.asCGPoint)
            path.addArc(center: topCircleAdj.tip.asCGPoint, radius: hoopBoxCircleRadiusAdj / 2, startAngle: Angle(radians: 0.0 + radians), endAngle: Angle(radians: Double.pi + radians), clockwise: false)
            
            path.move(to: bottomStartingPointAdj.tip.asCGPoint)
            path.addArc(center: bottomCircleAdj.tip.asCGPoint, radius: hoopBoxCircleRadiusAdj / 2, startAngle: Angle(radians: 0.0 + radians), endAngle: Angle(radians: Double.pi + radians), clockwise: true)
        }
    }

}
