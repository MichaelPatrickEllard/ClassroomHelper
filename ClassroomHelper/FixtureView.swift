//
//  Fixture.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/23/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit

class FixtureView: UIView
{
    var referenceTransform = CGAffineTransformIdentity
    
    var studentLabel : StudentLabel?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        addRotateGesture()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func addRotateGesture()
    {
        let rotateGR = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        
        self.addGestureRecognizer(rotateGR)
    }
    
    func handleRotate(gesture: UIRotationGestureRecognizer)
    {
        if gesture.state == .Began
        {
            self.referenceTransform = self.transform
        }
        
        self.transform = CGAffineTransformRotate(referenceTransform, gesture.rotation)
        
        if gesture.state == .Ended
        {
            self.referenceTransform = self.transform
        }
    }
    
    // MARK: Appearance changes
    
//    func highlight()
//    {
//        // Do Nothing
//    }
//    
//    func startPulsing()
//    {
//        
//    }
//    
//    func stopPulsing()
//    {
//        
//    }

}
