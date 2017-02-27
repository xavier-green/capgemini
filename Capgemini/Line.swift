//
//  Line.swift
//  DrawYourVoice
//
//  Created by Gaetan on 02/08/2016.
//  Copyright © 2016 Gaetan. All rights reserved.
//

import UIKit

class Line {
    
    // MARK: Properties
    var start: CGPoint
    var end: CGPoint
    var color: UIColor
    var size: CGFloat
    
    init(start _start: CGPoint, end _end: CGPoint, color _color: UIColor, size _size: CGFloat){
        
        start = _start
        end = _end
        color = _color
        size = _size
    }
    
    
}