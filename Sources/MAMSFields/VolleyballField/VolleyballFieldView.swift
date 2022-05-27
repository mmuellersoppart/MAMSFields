//
//  SoccerFieldView.swift
//  Fields
//
//  Created by Marlon Mueller Soppart on 4/28/22.
//

import SwiftUI
import MAMSVectors

public struct VolleyballFieldView: View {
    var radians: Double = 0
    var strokeColor: Color = Color.white
    var strokeWidth: Double = 1.0
    var fillColor: Color = Color.blue
    var scale: Double
    var isMaximized: Bool = true
    
    public init(radians: Double = 0, strokeColor: Color = Color.white, fillColor: Color = Color.blue, strokeWidth: Double = 1, scale: Double = 1, isMaximized: Bool = true) {

        self.scale = scale
        self.radians = radians
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
        self.isMaximized = isMaximized
    }
    
    public var body: some View {
        
        Canvas { context, size in
            
            let freeZoneColor = Color.yellow
            
            func defaultFill(_ path: Path) {
                context.fill(path, with: .color(fillColor))
            }
            
            func defaultStroke(_ path: Path) {
                context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
            }

            func defaultFillStroke(_ path: Path) {
                context.fill(path, with: .color(fillColor))
                context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
            }
            
            // find the scale that maximized field in boundary
            let totalSize = VolleyballFieldConstants.totalSize
            var scaleToFit = 1.0
            if isMaximized {
                scaleToFit = scale * Field.determineFieldScale(totalFieldSize: Size2D(x: totalSize.x, y: totalSize.y), boundarySize: size.asSize2D, rotation: radians)
            } else {
                scaleToFit = scale
            }
            
            let volleyballField = VolleyballField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            // free zone
            let totalPath = volleyballField.total
            context.fill(totalPath, with: .color(freeZoneColor))
            
            
            let fieldPath = volleyballField.field
            defaultFillStroke(fieldPath)
            
            
            let midlinePath = volleyballField.midline
            defaultStroke(midlinePath)
            
            let attackLinesPath = volleyballField.attackLines
            defaultStroke(attackLinesPath)
            
            let netPoleDotsPath = volleyballField.netPoles
            context.fill(netPoleDotsPath, with: .color(freeZoneColor))
            defaultStroke(netPoleDotsPath)
        }
    }
    
    public func totalSize(containerSize: Size2D) -> Size2D {
        // find the scale that maximized field in boundary (or use the fixed input)
        var scaleToFit = 1.0
        if isMaximized {
            scaleToFit = scale * Field.determineFieldScale(totalFieldSize: Size2D(x: SoccerFieldConstants.totalW, y: SoccerFieldConstants.totalH), boundarySize: containerSize, rotation: radians)
        } else {
            scaleToFit = scale
        }
        
        let soccerField = SoccerField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: containerSize.x/2, y: containerSize.y/2))
        
        return soccerField.totalBoundingBoxSize
    }
    
}

struct VolleyballFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VolleyballFieldView(radians: Double.pi/4, strokeWidth: 2.6)
    }
}
