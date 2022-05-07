//
//  SoccerField.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import Foundation
import SwiftUI
import MAMSVectors

typealias Size2D = Point2D

// modifies the original dimensions, in terms of scale and rotation to fit the given bounds.
final class SoccerField {
    private var scale: Double = 1
    private var radians: Double = 0
    private var centerPoint: Point2D = Point2D(x: 0, y: 0)
    
    var totalField: Path {
        let totalH = SoccerFieldConstants.totalH
        let totalW = SoccerFieldConstants.totalW
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: -totalH/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = totalFieldVectors.map {pos in scale * pos}.map { pos in pos.copy(radians: radians)}
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
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
        
        // establish size
        return createMirroringRectangles(goalSize, topLine)
    }
    
    var goalieBoxes: Path {
        let goalieArea = CGSize(width: SoccerFieldConstants.goalieAreaW, height: SoccerFieldConstants.goalieAreaH)
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        
        return createMirroringRectangles(goalieArea, topLine)
    }
    
    var penaltyBoxes: Path {
        let penaltyBoxSize = CGSize(width: SoccerFieldConstants.penaltyAreaW, height: SoccerFieldConstants.penaltyAreaH)
        let fieldH = SoccerFieldConstants.fieldH
        let topLine = centerPoint.y - fieldH/2
        
        return createMirroringRectangles(penaltyBoxSize, topLine)
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
    
    //    var cornerArcs: [Path] {
    //
    //        var cornerPaths: [Path] = []
    //
    //        let cornerRadius = SoccerFieldDimensions.cornerArcRadius * meterScaled
    //        var points = corners(rect: absField)
    //
    //        if !isPortrait {
    //            points = points.map(xyFlip)
    //        }
    //
    //        var angles = [Angle(degrees: 0), Angle(degrees: 90), Angle(degrees: 180), Angle(degrees: 270)]
    //
    //        if !isPortrait {
    //
    //            angles = angles.map {
    //
    //                if $0 == Angle(degrees: 90) || $0 == Angle(degrees: 270) {
    //                    return $0 + Angle(degrees: 180)
    //                }
    //                return $0
    //            }
    //        }
    //
    //        for (pt, angle) in zip(points, angles) {
    //            var path = Path()
    //            path.addArc(center: pt, radius: cornerRadius, startAngle: angle, endAngle: angle + Angle(degrees: 90), clockwise: false)
    //            cornerPaths.append(path)
    //        }
    //
    //        return cornerPaths
    //    }
    
    fileprivate func createMirroringRectangles(_ rectSize: CGSize, _ yValue: Double) -> Path {
        // establish size
        let upperLeftPoint = Point2D(x: centerPoint.x - rectSize.width/2, y: yValue)
        
        let upperVectors: [PositionalVector2D] = boxToVectors(upperLeftPoint: upperLeftPoint, goalSize: rectSize)
        
        let upperVectorsAdj: [PositionalVector2D] = upperVectors.scaleAndRotate(scale: scale, rotate: radians)
        let upperGoalPaths = vectorsToPath(positionalVectors: upperVectorsAdj)
        
        let lowerVectorsAdj: [PositionalVector2D] = upperVectors.map {posvec in reflectOverMidline(midlineY: centerPoint.y, positionalVector: posvec)}.scaleAndRotate(scale: scale, rotate: radians)
        
        let lowerGoalPaths = vectorsToPath(positionalVectors: lowerVectorsAdj)
        
        return Path { path in
            path.addPath(upperGoalPaths)
            path.addPath(lowerGoalPaths)
        }
    }
    
    init(scale: Double, radians: Double, centerPoint: Point2D) {
        self.radians = radians
        self.scale = scale
        self.centerPoint = centerPoint
    }
    
    private func reflectOverMidline(midlineY: Double, positionalVector: PositionalVector2D) -> PositionalVector2D {
        return positionalVector.copy(vectorY: -positionalVector.vector.y)
    }
    
    /// Produces four Position Vectors whose tips represent a box.
    private func boxToVectors(upperLeftPoint: Point2D, goalSize: CGSize) -> [PositionalVector2D] {
        let upperRightPoint = Point2D(x: upperLeftPoint.x + Double(goalSize.width), y: upperLeftPoint.y)
        let lowerLeftPoint = Point2D(x: upperLeftPoint.x, y: upperLeftPoint.y + Double(goalSize.height))
        let lowerRightPoint = Point2D(x: upperLeftPoint.x + Double(goalSize.width), y: upperLeftPoint.y + Double(goalSize.height))
        
        let upperPoints = [upperLeftPoint, upperRightPoint, lowerRightPoint, lowerLeftPoint]
        let upperVectors = upperPoints.map { pt in PositionalVector2D(start: centerPoint, end: pt)}
        
        return upperVectors
    }
    
    private func vectorsToPath(positionalVectors posvecs: [PositionalVector2D]) -> Path {
        
        guard posvecs.count > 0 else { return Path() }
        
        return Path { path in
            path.move(to: posvecs.first!.tip.asCGPoint)
            
            for vec in posvecs {
                path.addLine(to: vec.tip.asCGPoint)
            }
            
            path.move(to: posvecs.last!.tip.asCGPoint)
            path.addLine(to: posvecs.first!.tip.asCGPoint)
        }
    }
}
