//
//  SlingShooter.swift
//  ShurikenShooter
//
//  Created by il17aag on 12/01/2020.
//  Copyright © 2020 il17aag. All rights reserved.
//

import UIKit
import AVFoundation

class SlingShooter: UIImageView {

    var startPosition: CGPoint?
    var myDelegate: subViewDelegate?

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        startPosition = touches.first?.location(in: self)
        self.myDelegate?.chargethrow()

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let currentPosition = touches.first?.location(in: self)
        let dx = currentPosition!.x - startPosition!.x
        let dy = currentPosition!.y - startPosition!.y
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        self.myDelegate?.updatethrow()
        self.myDelegate?.updateShuriken(currentPosition: newCenter)
          //Constrain the movement to the phone screen bounds
        let slingx = self.bounds.midX
        newCenter.x = max(slingx, newCenter.x)
        newCenter.x = min(self.superview!.bounds.width - 530, newCenter.x)
        newCenter.y = max(80, newCenter.y)
        newCenter.y = min(self.superview!.bounds.height - 80, newCenter.y)
        self.center = newCenter

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.center.x = self.bounds.midX
        self.center.y = self.superview!.bounds.size.height*0.5
        self.myDelegate?.changethrow()
        self.myDelegate?.generateShuriken()
        self.myDelegate?.playChargeSound()
    }
    
    
}
