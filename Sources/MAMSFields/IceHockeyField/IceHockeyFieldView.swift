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
            
            let totalSize = IceHockeyFieldConstants.totalSize
            
            let scaleToFit = scale ?? Field.determineFieldScale(totalFieldSize: totalSize, boundarySize: size.asSize2D, rotation: radians)
            
            let iceHockeyField = IceHockeyField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            // field
            let totalFieldPath = iceHockeyField.totalField
            
            context.fill(totalFieldPath, with: .color(.yellow))
            
            let fieldPath = iceHockeyField.field
            
            defaultFill(fieldPath.0, context: &context)
            defaultStroke(fieldPath.0, context: &context)
            
            defaultFill(fieldPath.1, context: &context)
            
            defaultStroke(fieldPath.2, context: &context)
           
        }
    }
    
    private func defaultFill(_ path: Path, context: inout GraphicsContext) {
        context.fill(path, with: .color(fillColor))
    }
    
    private func defaultStroke(_ path: Path, context: inout GraphicsContext) {
        context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
    }

}

struct IceHockeyFieldView_Previews: PreviewProvider {
    static var previews: some View {
        IceHockeyFieldView(radians: Double.pi/4, strokeWidth: 0.6)
    }
}
