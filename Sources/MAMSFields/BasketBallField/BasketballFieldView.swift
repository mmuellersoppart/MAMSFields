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
    var scale: Double
    // should the field try to maximize its size. Or be of fixed size.
    var isMaximized: Bool = true
    
    public init(radians: Double = 0, strokeColor: Color = Color.white, fillColor: Color = Color.brown, strokeWidth: Double = 1, scale: Double = 1, isMaximized: Bool = true) {

        self.scale = scale
        self.radians = radians
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.strokeWidth = strokeWidth
        self.isMaximized = isMaximized
    }
    
    public var body: some View {
        
        Canvas { context, size in
            
            func defaultStroke(_ path: Path) {
                context.stroke(path, with: .color(strokeColor), lineWidth: strokeWidth)
            }
            
            // find the scale that maximized field in boundary (or use the fixed input)
            var scaleToFit = 1.0
            if isMaximized {
                scaleToFit = scale * Field.determineFieldScale(totalFieldSize: Size2D(x: BasketballFieldConstants.totalW, y: BasketballFieldConstants.totalH), boundarySize: size.asSize2D, rotation: radians)
            } else {
                scaleToFit = scale
            }
            
            let basketballField = BasketballField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            let totalFieldPath = basketballField.totalField
            
            context.fill(totalFieldPath, with: .color(.clear))
            
            let fieldPath = basketballField.field
            
            context.fill(fieldPath, with: .color(fillColor))
            defaultStroke(fieldPath)
            
            let midlinePath = basketballField.midline
            
            defaultStroke(midlinePath)
            
            let centerCircleOuterPath = basketballField.centerCircleOuter
            
            context.fill(centerCircleOuterPath, with: .color(fillColor))
            defaultStroke(centerCircleOuterPath)
            
            let centerCircleInnerPath = basketballField.centerCircleInner
            
            defaultStroke(centerCircleInnerPath)
            
            let threePointLinePath = basketballField.threePointBoxes
            
            defaultStroke(threePointLinePath)
            
            let restrictedAreaPath = basketballField.restrictedAreas
            
            defaultStroke(restrictedAreaPath)
            
            let outerHoopBoxesPath = basketballField.outerHoopBoxes
            
            defaultStroke(outerHoopBoxesPath)
            
            let hoopBoxesPath = basketballField.hoopBoxes
            
            defaultStroke(hoopBoxesPath)
            
            let hoopsPath = basketballField.hoops
            
            defaultStroke(hoopsPath)
            
            let hoopBoxCirclesPath = basketballField.hoopBoxCircles
            
            context.stroke(hoopBoxCirclesPath, with: .color(strokeColor), style: StrokeStyle(lineWidth: strokeWidth, dash: [CGFloat(5)]))
            
            let hoopBoxCircleHalvesPath = basketballField.hoopBoxCircleHalves
            
            defaultStroke(hoopBoxCircleHalvesPath)
            
        }
    }
    
    public func totalSize(containerSize: Size2D) -> Size2D {
        // find the scale that maximized field in boundary (or use the fixed input)
        var scaleToFit = 1.0
        if isMaximized {
            scaleToFit = scale * Field.determineFieldScale(totalFieldSize: Size2D(x: BasketballFieldConstants.totalW, y: BasketballFieldConstants.totalH), boundarySize: containerSize, rotation: radians)
        } else {
            scaleToFit = scale
        }
        
        let basketballField = BasketballField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: containerSize.x/2, y: containerSize.y/2))
        
        return basketballField.totalBoundingBoxSize
    }
}

struct BasketballFieldView_Previews: PreviewProvider {
    static var previews: some View {
        BasketballFieldView(radians: Double.pi / 4, strokeWidth: 2.5, scale: 1, isMaximized: true)
    }
}
