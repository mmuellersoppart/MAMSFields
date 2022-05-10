//
//  SwiftUIView.swift
//  
//
//  Created by Marlon Mueller Soppart on 5/8/22.
//

import SwiftUI
import MAMSVectors

public struct BasketballFieldView: View {
    var radians: Double = 0
    var strokeColor: Color = Color.white
    var strokeWidth: Double = 1.0
    var fillColor: Color = Color.green
    var scale: Double?
    
    public init(radians: Double = 0, strokeColor: Color = Color.white, fillColor: Color = Color.brown, strokeWidth: Double = 1, scale: Double? = nil) {

        self.scale = scale
        self.radians = radians
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
    }
    
    public var body: some View {
        
        Canvas { context, size in
            
            // find the scale that maximized field in boundary (or use the fixed input)
            let scaleToFit = scale ?? Field.determineFieldScale(totalFieldSize: Size2D(x: BasketballFieldConstants.totalW, y: BasketballFieldConstants.totalH), boundarySize: size.asSize2D, rotation: radians)
            
            let basketballField = BasketballField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            let totalFieldPath = basketballField.totalField
            
            context.fill(totalFieldPath, with: .color(.clear))
            
            let fieldPath = basketballField.field
            
            context.fill(fieldPath, with: .color(fillColor))
            defaultStroke(fieldPath, context: &context)
            
            let midlinePath = basketballField.midline
            
            defaultStroke(midlinePath, context: &context)
            
            let centerCircleOuterPath = basketballField.centerCircleOuter
            
            context.fill(centerCircleOuterPath, with: .color(fillColor))
            defaultStroke(centerCircleOuterPath, context: &context)
            
            let centerCircleInnerPath = basketballField.centerCircleInner
            
            defaultStroke(centerCircleInnerPath, context: &context)
            
            let threePointLinePath = basketballField.threePointBoxes
            
            defaultStroke(threePointLinePath, context: &context)
            
            let restrictedAreaPath = basketballField.restrictedAreas
            
            defaultStroke(restrictedAreaPath, context: &context)
            
            let outerHoopBoxesPath = basketballField.outerHoopBoxes
            
            defaultStroke(outerHoopBoxesPath, context: &context)
            
            let hoopBoxesPath = basketballField.hoopBoxes
            
            defaultStroke(hoopBoxesPath, context: &context)
            
            let hoopsPath = basketballField.hoops
            
            defaultStroke(hoopsPath, context: &context)
            
            let hoopBoxCirclesPath = basketballField.hoopBoxCircles
            
            context.stroke(hoopBoxCirclesPath, with: .color(strokeColor), style: StrokeStyle(lineWidth: strokeWidth, dash: [CGFloat(5)]))
            
            let hoopBoxCircleHalvesPath = basketballField.hoopBoxCircleHalves
            
            defaultStroke(hoopBoxCircleHalvesPath, context: &context)
            
        }
    }
    
    private func defaultStroke(_ path: Path, context: inout GraphicsContext) {
        context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
    }
}

struct BasketballFieldView_Previews: PreviewProvider {
    static var previews: some View {
        BasketballFieldView(radians: Double.pi / 4, strokeWidth: 2.5)
    }
}
