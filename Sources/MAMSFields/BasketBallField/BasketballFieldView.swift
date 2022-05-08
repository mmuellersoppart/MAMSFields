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
            
            let basketballField = BasketballField(scale: scaleToFit, radians: radians, centerPoint: Point2D(x: size.width/2, y: size.height/2))
            
            // field
            let totalFieldPath = basketballField.totalField
            
            context.fill(totalFieldPath, with: .color(.clear))
            
           
        }
    }
}

struct BasketballFieldView_Previews: PreviewProvider {
    static var previews: some View {
        BasketballFieldView(radians: Double.pi/2, strokeWidth: 0.6)
    }
}
