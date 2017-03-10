//
//  Curseur.swift
//  DrawYourVoice
//
//  Created by Gaetan on 26/07/2016.
//  Copyright © 2016 Gaetan. All rights reserved.
//

import UIKit

class Pointer {
    
    // MARK: Constants
    let SPEED : Int = 2
    // MARK: Properties
    var position: CGPoint
    fileprivate var direction: CGVector = CGVector(dx: 1.0,dy: 1.0)
    fileprivate var drawView: DrawView!
    
    // MARK: Setters
    
    func setDirection(_ newDirection: CGVector){
        //Normalise the vector
        let x: CGFloat = newDirection.dx
        let y: CGFloat = newDirection.dy
        
        let vectorLength: CGFloat = sqrt(x*x + y*y)
        
        let normalisedNewDirectionX = x / vectorLength
        let normalisedNewDirectionY = y / vectorLength

        direction.dx = normalisedNewDirectionX
        direction.dy = normalisedNewDirectionY
    }
    
    func getDirection() -> CGVector {
        return direction
    }
    
    
    
    init(position _position: CGPoint,drawView _drawView: DrawView){
        position = _position
        drawView = _drawView
    }
    
    convenience init(x: Double, y: Double, drawView _drawView: DrawView){
        self.init(position: CGPoint(x: CGFloat(x),y: CGFloat(y)),drawView: _drawView)
    }
    
    func moves() -> (PositionAndChangeOfSide){
        
        position.x += direction.dx * CGFloat(SPEED * GlobalVariables.lineSpeedMultiplier)
        position.y += direction.dy * CGFloat(SPEED)
        
        let width = self.drawView.bounds.size.width
        let height = self.drawView.bounds.size.height
        
        var hasChangedSide: Bool = false
        
        if position.x > width {
            position.x = 0
            hasChangedSide = true
        }
        if position.x < 0 {
            position.x = width
            hasChangedSide = true
        }
        if position.y > height {
            position.y = 0
            hasChangedSide = true
        }
        if position.y < 0 {
            position.y = height
            hasChangedSide = true
        }
        return PositionAndChangeOfSide(position: position, hasChangedSide: hasChangedSide)
    }
    
    
    
}

struct PositionAndChangeOfSide {
    
    var position: CGPoint
    var hasChangedSide: Bool
    
}
