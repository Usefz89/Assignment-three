//
//  Diamond.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 04/10/2021.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startPoint = CGPoint(
            x: center.x,
            y: center.y + (min(rect.width, rect.height)) / 2.5
        )
        let secondPoint = CGPoint (
            x: center.x + min(rect.width, rect.height) / 1.25,
            y: center.y
        )
        let thirdPoint = CGPoint(
            x: center.x,
            y: center.y - (min(rect.width, rect.height)) / 2.5
        )
        let forthPoint = CGPoint (
            x: center.x - min(rect.width, rect.height) / 1.25,
            y: center.y
        )
        
        var p = Path()
        p.move(to: startPoint)
        p.addLine(to: secondPoint)
        p.addLine(to: thirdPoint)
        p.addLine(to: forthPoint)
        p.addLine(to: startPoint)
        
        return p
        
      
    }
    
    
}
