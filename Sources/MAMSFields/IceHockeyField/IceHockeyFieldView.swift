//
//  SoccerFieldView.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import SwiftUI
import MAMSVectors

public struct IceHockeyFieldView: View {
    var radians: Double = 0
    var strokeColor: Color = Color.white
    var strokeWidth: Double = 1.0
    var fillColor: Color = Color.blue
    var scale: Double?
    
    public init(radians: Double = 0, strokeColor: Color = Color.white, fillColor: Color = Color.blue, strokeWidth: Double = 1, scale: Double? = nil) {

        self.scale = scale
        self.radians = radians
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        
        Canvas { context, size in
            
            func defaultFill(_ path: Path) {
                context.fill(path, with: .color(fillColor))
            }
            
            func defaultStroke(_ path: Path) {
                context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
            }

            
            // find the scale that maximized field in boundary
            
            let totalSize = IceHockeyFieldConstants.totalSize
            
            let scaleToFit = scale ?? Field.determineFieldScale(totalFieldSize: totalSize, boundarySize: size.asSize2D, rotation: radians)
            
            let iceHockeyField = IceHockeyField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            // field
            let totalFieldPath = iceHockeyField.totalField
            
            context.fill(totalFieldPath, with: .color(.clear))
            
            let fieldPath = iceHockeyField.field
            
            // circles
            defaultFill(fieldPath.0)
            defaultStroke(fieldPath.0)
            
            // fill pill
            defaultFill(fieldPath.1)
            
            // missing outlines
            defaultStroke(fieldPath.2)
            
            // midline
            let midlinePath = iceHockeyField.midline
            
            defaultStroke(midlinePath)
            
            let centerOuterCirclePath = iceHockeyField.centerOuterCircle
            
            defaultStroke(centerOuterCirclePath)
            
            let centerDotPath = iceHockeyField.centerDot
            
            defaultStroke(centerDotPath)
            
            // neutral area
            let neutralAreaPath = iceHockeyField.neutralArea
            defaultStroke(neutralAreaPath)
            
            let neutralFaceoffDots = iceHockeyField.neutralFaceoffDots
            defaultStroke(neutralFaceoffDots)
            
            let faceoffCirclesPath = iceHockeyField.faceOffCircles
            defaultStroke(faceoffCirclesPath.underlines)
            
            defaultFill(faceoffCirclesPath.outerCircles)
            defaultStroke(faceoffCirclesPath.outerCircles)
            
            defaultStroke(faceoffCirclesPath.dots)
            
            let goalLinesPath = iceHockeyField.goalLines
            defaultStroke(goalLinesPath)
            
            let goalsPath = iceHockeyField.goals
            defaultStroke(goalsPath)
            
            let goalCreasesPath = iceHockeyField.goalCreases
            defaultStroke(goalCreasesPath)
            
            let refereeCreasePath = iceHockeyField.refereeCrease
            defaultStroke(refereeCreasePath)
        }
    }
}

struct IceHockeyFieldView_Previews: PreviewProvider {
    static var previews: some View {
        IceHockeyFieldView(radians: Double.pi/4, strokeWidth: 2.6)
    }
}
