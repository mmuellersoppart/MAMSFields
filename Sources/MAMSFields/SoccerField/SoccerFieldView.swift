//
//  SoccerFieldView.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import SwiftUI
import MAMSVectors

public struct SoccerFieldView: View {
    var radians: Double = 0
    var strokeColor: Color = Color.white
    var strokeSize: Double = 1.0
    var fillColor: Color = Color.green
    
    public init(radians: Double = 0, strokeColor: Color = Color.white, fillColor: Color = Color.green) {
        self.radians = radians
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }
    
    public var body: some View {
        ZStack {
            Color.gray
            Canvas { context, size in

                // find the scale that maximized field in boundary
//                let scaleToFit = determineSoccerFieldScale(boundaryH: size.height, boundaryW: size.width, rotation: radians)
                let scaleToFit = determineSoccerFieldScale(totalFieldSize: Size2D(x: SoccerFieldConstants.totalW, y: SoccerFieldConstants.totalH), boundarySize: size.asSize2D, rotation: radians)
                
                let soccerField = SoccerField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
                
                // field
                let totalFieldPath = soccerField.totalField
                
                context.fill(totalFieldPath, with: .color(.clear))
//                context.stroke(totalFieldPath, with: .color(.white))
                
                let fieldPath = soccerField.field
                
                context.fill(fieldPath, with: .color(fillColor))
                context.stroke(fieldPath, with: .color(strokeColor))
                
                // midline
                let midlinePath = soccerField.midline
                context.stroke(midlinePath, with: .color(strokeColor))
                
                // penalty boxes
                // ********************
                let penaltyBoxCirclePaths = soccerField.penaltyCircles
                context.stroke(penaltyBoxCirclePaths, with: .color(strokeColor))
                
                let penaltyBoxesPaths = soccerField.penaltyBoxes
                context.fill(penaltyBoxesPaths, with: .color(fillColor))
                context.stroke(penaltyBoxesPaths, with: .color(strokeColor))
                
                let penaltyDotPaths = soccerField.penaltyDots
                context.fill(penaltyDotPaths, with: .color(strokeColor))
                
                // goals
                // ********************
                let goalPaths = soccerField.goals
                context.fill(goalPaths, with: .color(fillColor))
                context.stroke(goalPaths, with: .color(strokeColor))
                
                // goalie box
                let goalieBoxPaths = soccerField.goalieBoxes
                context.stroke(goalieBoxPaths, with: .color(strokeColor))
                
                
                // center circle
                // ********************
                let centerCirclePath = soccerField.centerCircle
                context.stroke(centerCirclePath, with: .color(strokeColor))
                
                //center dot
                let centerDotPath = soccerField.centerDot
                context.fill(centerDotPath, with: .color(strokeColor))
                
                //TODO: corner
                let cornerPaths = soccerField.corners
                context.stroke(cornerPaths, with: .color(strokeColor))
            }
        }
    }
}

struct SoccerFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SoccerFieldView(radians: 0.0)
    }
}

func determineSoccerFieldScale(totalFieldSize: Size2D, boundarySize: Size2D, rotation: Double) -> Double {
    let centerPoint = Point2D(x: boundarySize.x/2, y: boundarySize.y/2)
    let q2PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalFieldSize.x/2, y: totalFieldSize.y/2)).copy(radians: rotation)
    let q3PosVector = PositionalVector2D(point: centerPoint, vector: Vector2D(x: totalFieldSize.x/2, y: -totalFieldSize.y/2)).copy(radians: rotation)
    
    let q2Intersection = findClosestIntersection(positionalVector: q2PosVector, xBoundaries: 0.0, boundarySize.x, yBoundaries: 0.0, boundarySize.y)
    let q3Intersection = findClosestIntersection(positionalVector: q3PosVector, xBoundaries: 0.0, boundarySize.x, yBoundaries: 0.0, boundarySize.y)
    
    let closestIntersection = centerPoint.distance(to: q2Intersection!) > centerPoint.distance(to: q3Intersection!) ? q3Intersection : q2Intersection

    return centerPoint.distance(to: closestIntersection!) / centerPoint.distance(to: q2PosVector.tip)
}
