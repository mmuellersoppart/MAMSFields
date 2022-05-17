//
//  SoccerField.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import Foundation
import SwiftUI
import MAMSVectors

// modifies the original dimensions, in terms of scale and rotation to fit the given bounds.
public class SoccerField: Field {
    
    private typealias Constants = SoccerFieldConstants
    
    var totalField: Path {
        let totalH = SoccerFieldConstants.totalH
        let totalW = SoccerFieldConstants.totalW
        
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
        let fieldSize = Size2D(x: SoccerFieldConstants.fieldW, y: SoccerFieldConstants.fieldH)
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -fieldSize.x/2, y: -fieldSize.y/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = totalFieldVectors.map {pos in scale * pos}.map { pos in pos.copy(radians: radians)}
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
    }
    
    var midline: Path {
        let totalW = SoccerFieldConstants.totalW
        
        let leftLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: 0.0))).copy(radians: radians)
        let rightLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalW/2, y: 0.0))).copy(radians: radians)
        
        return Path { path in
            path.move(to: leftLine.tip.asCGPoint)
            path.addLine(to: rightLine.tip.asCGPoint)
        }
    }
    
    var goals: Path {
        let goalSize = CGSize(width: SoccerFieldConstants.goalW, height: SoccerFieldConstants.goalH)
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2 - goalSize.height
        
        return createMirroringRectangles(rectSize: goalSize, yValue: topLine)
    }
    
    var goalieBoxes: Path {
        let goalieArea = CGSize(width: SoccerFieldConstants.goalieAreaW, height: SoccerFieldConstants.goalieAreaH)
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        
        return createMirroringRectangles(rectSize: goalieArea, yValue: topLine)
    }
    
    var penaltyBoxes: Path {
        let penaltyBoxSize = CGSize(width: SoccerFieldConstants.penaltyAreaW, height: SoccerFieldConstants.penaltyAreaH)
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        
        return createMirroringRectangles(rectSize: penaltyBoxSize, yValue: topLine)
    }
    
    var centerCircle: Path {
        return centerPoint.asPath(pointDiameter: SoccerFieldConstants.centerCircleRadius * scale * 2)
    }
    
    var centerDot: Path {
        return centerPoint.asPath(pointDiameter: SoccerFieldConstants.dotRadius * 2 * scale)
    }
    
    var penaltyCircles: Path {
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        let bottomLine = centerPoint.y + fieldH/2
        
        let topPenaltyDot = Point2D(x: centerPoint.x, y: topLine + SoccerFieldConstants.penatlyDotDistance)
        let bottomPenaltyDot = Point2D(x: centerPoint.x, y: bottomLine - SoccerFieldConstants.penatlyDotDistance)
        
        let topPenaltyDotAdj = (scale * PositionalVector2D(start: centerPoint, end: topPenaltyDot)).copy(radians: radians)
        let bottomPenaltyDotAdj = (scale * PositionalVector2D(start: centerPoint, end: bottomPenaltyDot)).copy(radians: radians)
        
        return Path { path in
            path.addPath(topPenaltyDotAdj.tip.asPath(pointDiameter: 2 * SoccerFieldConstants.penaltyArcRadius * scale))
            path.addPath(bottomPenaltyDotAdj.tip.asPath(pointDiameter: 2 * SoccerFieldConstants.penaltyArcRadius * scale))
        }
    }
    
    var penaltyDots: Path {
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        let bottomLine = centerPoint.y + fieldH/2
        
        let topPenaltyDot = Point2D(x: centerPoint.x, y: topLine + SoccerFieldConstants.penatlyDotDistance)
        let bottomPenaltyDot = Point2D(x: centerPoint.x, y: bottomLine - SoccerFieldConstants.penatlyDotDistance)
        
        let topPenaltyDotAdj = (scale * PositionalVector2D(start: centerPoint, end: topPenaltyDot)).copy(radians: radians)
        let bottomPenaltyDotAdj = (scale * PositionalVector2D(start: centerPoint, end: bottomPenaltyDot)).copy(radians: radians)
        
        return Path { path in
            path.addPath(topPenaltyDotAdj.tip.asPath(pointDiameter: 2 * SoccerFieldConstants.dotRadius * scale))
            path.addPath(bottomPenaltyDotAdj.tip.asPath(pointDiameter: 2 * SoccerFieldConstants.dotRadius * scale))
        }
    }
    
    var corners: Path {
        let fieldSize = Size2D(x: SoccerFieldConstants.fieldW, y: SoccerFieldConstants.fieldH)
        
        let left = centerPoint.x - fieldSize.x / 2
        let right = centerPoint.x + fieldSize.x / 2
        let up = centerPoint.y - fieldSize.y / 2
        let down = centerPoint.y + fieldSize.y / 2
        
        let cornerPoints = [Point2D(x: left, y: up), Point2D(x: right, y: up), Point2D(x: right, y: down), Point2D(x: left, y: down)]
        let cornerPositionalVectorsAdj = cornerPoints.map {pt in PositionalVector2D(start: centerPoint, end: pt)}.scaleAndRotate(scale: scale, rotate: radians)
        let cornerPointsAdj = cornerPositionalVectorsAdj.map { posvec in posvec.tip }
        
        let anglesAdj = [
            Angle(radians: 0.0 + radians),
            Angle(radians: Double.pi / 2 + radians),
            Angle(radians: Double.pi + radians),
            Angle(radians: (3 * Double.pi)/2 + radians)
        ]
        
        return Path { path in
            for corner in zip(cornerPointsAdj, anglesAdj) {
                path.move(to: corner.0.asCGPoint)
                path.addArc(center: corner.0.asCGPoint, radius: SoccerFieldConstants.cornerArcRadius * scale, startAngle: corner.1, endAngle: corner.1 + Angle(degrees: 90), clockwise: false)
            }
        }
    }
}
