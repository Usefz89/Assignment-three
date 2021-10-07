//
//  Utilities.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 04/10/2021.
//

import SwiftUI



extension Shape {
    
    /// Frame fits the space offered which width is double the height
    func frameThatFits( in size: CGSize) -> some View {
        frame(
            width: min(size.width, size.height) * 0.6,
            height: (min(size.width, size.height) * 0.6) / 2 )
    }
}

extension Array {
    mutating func add(_ numberOfElements: Int, from  sourceArray: inout [Element]) {
        if sourceArray.count >= numberOfElements  {
            for _ in 0..<numberOfElements {
                self.append(sourceArray.removeLast())
            }
        } else {
            return
        }
            
        
    }
}
