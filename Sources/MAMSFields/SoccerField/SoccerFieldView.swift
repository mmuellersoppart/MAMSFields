//
//  SoccerFieldView.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import SwiftUI
import MAMSVectors

public struct SoccerFieldView: View {
    @State var radians: Double = 0
    
    public var body: some View {
        VStack {
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
                context.stroke(totalFieldPath, with: .color(.white))
                
                let fieldPath = soccerField.field
                
                context.fill(fieldPath, with: .color(.green))
                context.stroke(fieldPath, with: .color(.white))
                
                // midline
                let midlinePath = soccerField.midline
                context.stroke(midlinePath, with: .color(.white))
                
                // penalty boxes
                // ********************
                let penaltyBoxCirclePaths = soccerField.penaltyCircles
                context.stroke(penaltyBoxCirclePaths, with: .color(.white))
                
                let penaltyBoxesPaths = soccerField.penaltyBoxes
                context.fill(penaltyBoxesPaths, with: .color(.green))
                context.stroke(penaltyBoxesPaths, with: .color(.white))
                
                let penaltyDotPaths = soccerField.penaltyDots
                context.fill(penaltyDotPaths, with: .color(.white))
                
                // goals
                // ********************
                let goalPaths = soccerField.goals
                context.fill(goalPaths, with: .color(.green))
                context.stroke(goalPaths, with: .color(.white))
                
                // goalie box
                let goalieBoxPaths = soccerField.goalieBoxes
                context.stroke(goalieBoxPaths, with: .color(.white))
                
                
                // center circle
                // ********************
                let centerCirclePath = soccerField.centerCircle
                context.stroke(centerCirclePath, with: .color(.white))
                
                //center dot
                let centerDotPath = soccerField.centerDot
                context.fill(centerDotPath, with: .color(.white))
                
                //TODO: corner
                let cornerPaths = soccerField.corners
                context.stroke(cornerPaths, with: .color(.white))
            }
        }.frame(width: 200, height: 300)
            Slider(value: $radians, in:Double(0)...(2.0 * Double.pi))
        }
    }
}

struct SoccerFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SoccerFieldView()
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
