//
//  Theme.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 03/10/2021.
//

import Foundation

/// Consisit of array of 81 Theme

   
    
    /// A theme on which, it consists of Shape, Color of the shape, number of shapes and the opacity of the shape
    /// Can be included on a View as a content. 
    struct Theme: Equatable {
        
        private(set) var shape: Theme.Shape
        private(set) var numberOfShapes: Theme.NumberOfShapes
        private(set) var colorOfShape: Theme.ColorOfShape
        private(set) var opacityOfShape: Theme.OpacityOptions
        
        
        enum Shape: CaseIterable {
            case oval
            case diamond
            case rectangle
        }
        enum NumberOfShapes: Int, CaseIterable {
            case one = 1, two, three
        }
        enum ColorOfShape: CaseIterable {
            case red, purple, green
        }  
        enum OpacityOptions: Double, CaseIterable {
            case zero = 0
            case half = 0.3
            case full = 1.0
            
        }
    }

  

