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
public class IceHockeyField: Field {
    
    private typealias Constants = IceHockeyFieldConstants
    
    var totalField: Path {
        let totalSize = Size2D(x: Constants.totalW, y: Constants.totalH)
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalSize.x/2, y: -totalSize.y/2))
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
    
    var field: (Path, Path, Path) {
        let fieldSize = Size2D(x: Constants.fieldW, y: Constants.fieldH)
        let cornerRadius = Constants.fieldCornerRadius
        
        // 4 corner circles
        
        // get center of each of the circles
        let upperLeft = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - fieldSize.x / 2 + cornerRadius, y: centerPoint.y - fieldSize.y / 2 + cornerRadius))
        let circlePosVectors = vectorForEachQuadrant(positionalVector: upperLeft)
        let circlePosVectorsAdj = circlePosVectors.scaleAndRotate(scale: scale, rotate: radians)
        
        let circlePaths = circlePosVectorsAdj.map { posvec in posvec.tip.asPath(pointDiameter: scale * cornerRadius * 2)}
        
        let circles = Path { path in
            for circle in circlePaths {
                path.addPath(circle)
            }
        }
        
        // going clockwise
        // upper left
        let pt1 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - fieldSize.x / 2, y: centerPoint.y - fieldSize.y / 2 + cornerRadius))).tip.asCGPoint
        let pt2 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - fieldSize.x / 2 + cornerRadius, y: centerPoint.y - fieldSize.y / 2))).tip.asCGPoint
        
        // upper right
        let pt3 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + fieldSize.x / 2 - cornerRadius, y: centerPoint.y - fieldSize.y / 2))).tip.asCGPoint
        let pt4 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + fieldSize.x / 2, y: centerPoint.y - fieldSize.y / 2 + cornerRadius))).tip.asCGPoint
        
        // bottom right
        let pt5 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + fieldSize.x / 2, y: centerPoint.y + fieldSize.y / 2 - cornerRadius))).tip.asCGPoint
        let pt6 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x + fieldSize.x / 2 - cornerRadius, y: centerPoint.y + fieldSize.y / 2))).tip.asCGPoint
        
        // bottom left
        let pt7 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - fieldSize.x / 2 + cornerRadius, y: centerPoint.y + fieldSize.y / 2))).tip.asCGPoint
        let pt8 = _adj(PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x - fieldSize.x / 2, y: centerPoint.y + fieldSize.y / 2 - cornerRadius))).tip.asCGPoint
        
        let allPts = [pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8]
        
        let fieldBackdrop = Path { path in
            path.move(to: pt1)
            for pt in allPts {
                path.addLine(to: pt)
            }
        }
        
        let outlinePts = [(pt2, pt3), (pt4, pt5), (pt6, pt7), (pt8, pt1)]
        
        let fieldBackdropOutline = Path { path in
            for pts in outlinePts {
                path.move(to: pts.0)
                path.addLine(to: pts.1)
            }
        }
        
        return (circles: circles, fieldFill: fieldBackdrop, fieldlines: fieldBackdropOutline)
    }
    
    var midline: Path {
        let totalW = Constants.totalW
        
        let leftLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: 0.0))).copy(radians: radians)
        let rightLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalW/2, y: 0.0))).copy(radians: radians)
        
        return Path { path in
            path.move(to: leftLine.tip.asCGPoint)
            path.addLine(to: rightLine.tip.asCGPoint)
        }
    }
    
    var centerOuterCircle: Path {
        centerPoint.asPath(pointDiameter: scale * Constants.centerCircleRadius * 2)
    }
    
    var centerDot: Path {
        centerPoint.asPath(pointDiameter: scale * Constants.dotRadius * 2)
    }
    
    // neutral area
    var neutralArea: Path {
        let neutralAreaSize = Size2D(x: Constants.neutralAreaW, y: Constants.neutralAreaH)
        let vectorsAdj = _adj(fourPoints(size: neutralAreaSize, customCenterPoint: centerPoint))
        
        return Path { path in
            path.move(to: vectorsAdj[0].tip.asCGPoint)
            path.addLine(to: vectorsAdj[1].tip.asCGPoint)
            
            path.move(to: vectorsAdj[2].tip.asCGPoint)
            path.addLine(to: vectorsAdj[3].tip.asCGPoint)
        }
    }
    
    // neutral face off dots
    var neutralFaceoffDots: Path {
        let faceoffSize = Size2D(x: Constants.neutralfaceOffDotsW, y: Constants.neutralfaceOffDotsH)
        let vectorsAdj = _adj(fourPoints(size: faceoffSize, customCenterPoint: centerPoint))
        
        return Path { path in
            for vec in vectorsAdj {
                path.addPath(vec.tip.asPath(pointDiameter: scale * Constants.dotRadius * 2))
            }
        }
    }
    
    var faceOffCircles: (underlines: Path, outerCircles: Path, dots: Path) {
        let faceoffSize = Size2D(x: Constants.faceOffCircleDotsW, y: Constants.faceOffCircleDotsH)
        let vectorsAdj = _adj(fourPoints(size: faceoffSize, customCenterPoint: centerPoint))
        
        var lines = Path()
        var outerCirles = Path()
        var dots = Path()
        for vec in vectorsAdj {
            
            // lines that go underneath the circles
            let linesSize = Size2D(x: Constants.faceoffAreaLineLength, y: Constants.faceoffAreaLineSeparation)
            let lineVectorsAdj = _adj(fourPoints(size: linesSize, customCenterPoint: vec.tip))
            
            lines.move(to: lineVectorsAdj[0].tip.asCGPoint)
            lines.addLine(to: lineVectorsAdj[1].tip.asCGPoint)
            
            lines.move(to: lineVectorsAdj[2].tip.asCGPoint)
            lines.addLine(to: lineVectorsAdj[3].tip.asCGPoint)
            
            dots.addPath(vec.tip.asPath(pointDiameter: scale * Constants.dotRadius * 2))
            outerCirles.addPath(vec.tip.asPath(pointDiameter: scale * Constants.faceOffCircleRadius * 2))
        }
        
        return (lines, outerCirles, dots)
    }

    var goals: Path {
        let goalSize = Size2D(x: Constants.goalW, y: Constants.goalH)
        let topLine = centerPoint.y - Constants.fieldH / 2 + Constants.goalLineDistanceFromTop - goalSize.y
        
        return createMirroringRectangles(rectSize: goalSize.asCGSize(), yValue: topLine)
    }
    
    var goalCreases: Path {
        let creaseRadiusAdj = Constants.goalCreaseRadius * scale
        let topLine = centerPoint.y - Constants.fieldH / 2 + Constants.goalLineDistanceFromTop
        
        let topCreaseCenter = PositionalVector2D(start: centerPoint, end: Point2D(x: centerPoint.x, y: topLine))
        let topCreaseCenterAdj = _adj(topCreaseCenter)
        let bottomCreaseCenterAdj = _adj(mirrorY(topCreaseCenter, over: centerPoint.y))
        
        return Path { path in
            path.move(to: topCreaseCenterAdj.tip.asCGPoint)
            path.addArc(center: topCreaseCenterAdj.tip.asCGPoint, radius: creaseRadiusAdj, startAngle: Angle(radians: 0.0 + radians), endAngle: Angle(radians: Double.pi + radians), clockwise: false)

            path.move(to: bottomCreaseCenterAdj.tip.asCGPoint)
            path.addArc(center: bottomCreaseCenterAdj.tip.asCGPoint, radius: creaseRadiusAdj, startAngle: Angle(radians: 0.0 + radians), endAngle: Angle(radians: Double.pi + radians), clockwise: true)
        }
    }
    
    var goalLines: Path {
        let goalLineSize = Size2D(x: Constants.goalLineLength, y: Constants.fieldH - Constants.goalLineDistanceFromTop * 2)
        let vectorsAdj = _adj(fourPoints(size: goalLineSize, customCenterPoint: centerPoint))
        
        return Path { path in
            path.move(to: vectorsAdj[0].tip.asCGPoint)
            path.addLine(to: vectorsAdj[1].tip.asCGPoint)
            
            path.move(to: vectorsAdj[2].tip.asCGPoint)
            path.addLine(to: vectorsAdj[3].tip.asCGPoint)
        }
    }
    
    var refereeCrease: Path {
        let creaseLocation = Point2D(x: centerPoint.x + Constants.fieldW / 2, y: centerPoint.y)
        let creaseRadiusAdj = Constants.refereeCreaseRadius * scale
        
        let creaseVectorAdj = _adj(PositionalVector2D(start: centerPoint, end: creaseLocation))
        
        return Path { path in
            let start = Angle(radians: (Double.pi / 2 + radians))
            let end = start + Angle(radians: Double.pi)
            path.addArc(center: creaseVectorAdj.tip.asCGPoint, radius: creaseRadiusAdj, startAngle: start, endAngle: end, clockwise: false)
        }        
    }
}

extension Size2D {
    func asCGSize() -> CGSize {
        CGSize(width: self.x, height: self.y)
    }
}
