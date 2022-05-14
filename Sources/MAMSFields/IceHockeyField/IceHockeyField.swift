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
class IceHockeyField: Field {
    
    private typealias Constants = IceHockeyFieldConstants
    
    var totalField: Path {
        let totalSize = Size2D(x: Constants.totalW, y: Constants.totalH)
        
        let topLeftVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalSize.x/2, y: -totalSize.y/2))
        let totalFieldVectors = vectorForEachQuadrant(positionalVector: topLeftVector)
        
        // apply modifications
        let totalFieldVectorsAdj = totalFieldVectors.map {pos in scale * pos}.map { pos in pos.copy(radians: radians)}
        
        return vectorsToPath(positionalVectors: totalFieldVectorsAdj)
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
        let totalW = SoccerFieldConstants.totalW
        
        let leftLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: -totalW/2, y: 0.0))).copy(radians: radians)
        let rightLine = (scale * PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalW/2, y: 0.0))).copy(radians: radians)
        
        return Path { path in
            path.move(to: leftLine.tip.asCGPoint)
            path.addLine(to: rightLine.tip.asCGPoint)
        }
    }
    
}
