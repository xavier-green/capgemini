//
//  DrawView.swift
//  Capgemini
//
//  Created by Younes Belkouchi on 27/02/2017.
//  Copyright © 2017 xavier green. All rights reserved.
//

import UIKit
import Photos

class DrawView: UIView {

    // MARK: Outlets

    // MARK: Properties
    var pointer: Pointer! = nil
    var timer: Timer!
    var lastPoint: CGPoint!
    var lastTouchedPoint: CGPoint!
    var lineWidth: CGFloat = 1
    var newPoint = CGPoint(x:200,y:200)
    
    var currentLine : Line? = nil
    
    var lines: [Line] = []
    
    var f0 = 150.0
    var fe = 10.0
    var fmin = 50.0
    var fmax = 300.0
    
    let minRadius = 13.5
    let lineSize = 13.5
    
    var previousAmplitude: CGFloat = 0.1
    var currentColor = UIColor.black
    
    var viewImage = UIImage()
    
    // MARK: Initialisation
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let initialPosition = CGPoint(x: 200, y: 200)
        pointer = Pointer(position: initialPosition, drawView: self)
        lastPoint = initialPosition
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("IPhone is shaken")
        if motion == .motionShake {
            print("IPhone is shaken")
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        print("Nombre de lines : " + String(lines.count))
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        viewImage.draw(at: CGPoint.zero)
        
        //       CGContextFillRect(context, CGRectMake(pointer.position.x, pointer.position.y, 2, 2))
        
        if currentLine != nil {
            
            context.beginPath()
            context.setLineCap(CGLineCap.round)
            context.setLineWidth((currentLine?.size)!)
            
            context.move(to: CGPoint(x: currentLine!.start.x, y: currentLine!.start.y))
            context.addLine(to: CGPoint(x: currentLine!.end.x, y: currentLine!.end.y))
            context.setStrokeColor(currentLine!.color.cgColor)
            context.strokePath()
            
        }
        
        viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let context3: CGContext = UIGraphicsGetCurrentContext()!
        context3.setFillColor(UIColor.init(red: 16.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor)
        context3.fill(CGRect(x: pointer.position.x, y: pointer.position.y, width: 2, height:2))
        
        let context2: CGContext = UIGraphicsGetCurrentContext()!
        context2.setBlendMode(CGBlendMode.colorBurn)
        viewImage.draw(at: CGPoint.zero)
        
        
    }
    
    // MARK: Finger Interactions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            pointer.position = position
            lastPoint = position
            setNeedsDisplay()
        }
    }
    
    // MARK: Voice interactions
    
    func getMoveFromAudioInput(_ frequency: Double, amplitude: Double){
        print("Je suis dans DrawView")
        
        self.previousAmplitude = CGFloat(previousAmplitude)
        let rotationAngle = frequencyToAngle(frequency)
        
        print("Angle1: " + String(rotationAngle) + " Amplitude1: " + String(amplitude))
        let currentDirection = pointer.getDirection()
        
        // Rotation
        
        let newDirection = currentDirection.rotate(radAngle: CGFloat(rotationAngle))
        
        pointer.setDirection(newDirection)
        
        // Move Pointer
        let newPointAndChangeOfSide = pointer.moves()
        newPoint = newPointAndChangeOfSide.position
        let hasChangedSide: Bool = newPointAndChangeOfSide.hasChangedSide
        
        if hasChangedSide == true {
            lastPoint = newPoint
        }
        // Get Color From Amplitude
        /*      let truncatedAmplitude = CGFloat(amplitude.roundToN(n: 2)) //2 digits truncature
         if truncatedAmplitude != previousAmplitude {
         previousAmplitude = truncatedAmplitude
         currentColor = UIColor.init(red: previousAmplitude, green: previousAmplitude, blue: 0, alpha: 1)
         }*/
        
        let lineSize = CGFloat(3 + (amplitude - 0.06) * GlobalVariables.lineSizeMultiplier)
        
        let drawColor = currentColor.withAlphaComponent(getOpacity(lineSize))
        
        let line: Line = Line(start: lastPoint, end: newPoint, color: drawColor, size: lineSize)
        lines.append(line)
        currentLine = line
        self.setNeedsDisplay()
        lastPoint = newPoint
    }
    
    
    func frequencyToAngle(_ frequency: Double) -> Double{
        
        //      let a_l = 0.1*(M_PI)/(fmin+fe+f0)
        let a_l = -0.25*(M_PI)/(fmin+fe-f0)
        let b_l = -0.25*(M_PI*(fe-f0))/(fmin+fe-f0)
        let a_r = 0.25*(M_PI)/(fmax-fe-f0)
        let b_r = -0.25*(M_PI)*(fe+f0)/(fmax-fe-f0)
        
        if fmin<frequency && frequency<f0-fe {
            return a_l * frequency + b_l
        }
            
        else if f0-fe<frequency && frequency<f0+fe {
            return 0.0
        }
            
        else if f0+fe<frequency && frequency<fmax {
            return a_r * frequency + b_r
        }
            
        else {return 0.0}
        
    }
    
    // MARK: Color Methods
    
    func getOpacity(_ lineWidth:CGFloat) -> (CGFloat){
        return 3.0/lineWidth
    }
    
    
    func midPoint(_ p0: CGPoint, p1: CGPoint) -> CGPoint {
        print("Je suis dans midPoint")
        
        let x=(p0.x+p1.x)/2
        let y=(p0.y+p1.y)/2
        return CGPoint(x:x,y:y)
        
    }


}
