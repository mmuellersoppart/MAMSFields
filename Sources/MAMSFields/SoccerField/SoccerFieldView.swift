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
    var strokeWidth: Double = 1.0
    var fillColor: Color = Color.green
    var scale: Double?
    
    public init(radians: Double = 0, strokeColor: Color = Color.white, fillColor: Color = Color.green, strokeWidth: Double = 1, scale: Double? = nil) {

        self.scale = scale
        self.radians = radians
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        
        Canvas { context, size in
            
            // find the scale that maximized field in boundary
            
            let scaleToFit = scale ?? Field.determineFieldScale(totalFieldSize: Size2D(x: SoccerFieldConstants.totalW, y: SoccerFieldConstants.totalH), boundarySize: size.asSize2D, rotation: radians)
            
            let soccerField = SoccerField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            // field
            let totalFieldPath = soccerField.totalField
            
            context.fill(totalFieldPath, with: .color(.clear))
            
            let fieldPath = soccerField.field
            
            context.fill(fieldPath, with: .color(fillColor))
            context.stroke(fieldPath, with: .color(strokeColor), lineWidth: strokeWidth)
            
            // midline
            let midlinePath = soccerField.midline
            context.stroke(midlinePath, with: .color(strokeColor), lineWidth: strokeWidth)
            
            // penalty boxes
            // ********************
            let penaltyBoxCirclePaths = soccerField.penaltyCircles
            context.stroke(penaltyBoxCirclePaths, with: .color(strokeColor), lineWidth: strokeWidth)
            
            let penaltyBoxesPaths = soccerField.penaltyBoxes
            context.fill(penaltyBoxesPaths, with: .color(fillColor))
            context.stroke(penaltyBoxesPaths, with: .color(strokeColor), lineWidth: strokeWidth)
            
            let penaltyDotPaths = soccerField.penaltyDots
            context.fill(penaltyDotPaths, with: .color(strokeColor))
            
            // goals
            // ********************
            let goalPaths = soccerField.goals
            context.fill(goalPaths, with: .color(fillColor))
            context.stroke(goalPaths, with: .color(strokeColor), lineWidth: strokeWidth)
            
            // goalie box
            let goalieBoxPaths = soccerField.goalieBoxes
            context.stroke(goalieBoxPaths, with: .color(strokeColor), lineWidth: strokeWidth)
            
            
            // center circle
            // ********************
            let centerCirclePath = soccerField.centerCircle
            context.stroke(centerCirclePath, with: .color(strokeColor), lineWidth: strokeWidth)
            
            //center dot
            let centerDotPath = soccerField.centerDot
            context.fill(centerDotPath, with: .color(strokeColor))
            
            let cornerPaths = soccerField.corners
            context.stroke(cornerPaths, with: .color(strokeColor), lineWidth: strokeWidth)
        }
    }
}

struct SoccerFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SoccerFieldView(radians: Double.pi/2, strokeWidth: 0.6)
    }
}
