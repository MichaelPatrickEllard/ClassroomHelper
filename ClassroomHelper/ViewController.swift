//
//  ViewController.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/22/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let classroom = Classroom()
    var classroomView: UIView!
    
    var activeDesk: DeskView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let classroomFrame = CGRect(origin: CGPoint(x: 0, y: 0),
                                    size: classroom.roomSize)
        
        classroomView = UIView(frame: classroomFrame)
        
        classroomView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(classroomView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func studentsPressed(sender: AnyObject) {
    }
    
    @IBAction func deskPressed(sender: AnyObject) {
    }
    
    @IBAction func chairPressed(sender: AnyObject) {
    }

    @IBAction func questionPressed(sender: AnyObject) {
    }
    
    
    @IBAction func answerPressed(sender: AnyObject) {
    }
    
    @IBAction func classroomPressed(sender: AnyObject) {
    }
    
    @IBAction func transformPressed(sender: AnyObject) {
    }
    
    @IBAction func videoPressed(sender: AnyObject) {
    }
    
    // MARK: Touch Handling Code
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if touches.count > 1
        {
            NSLog("Unexpectedly got multi-touch action!")
            return
        }
        
        for touch in touches
        {
            if touch.view == classroomView
            {
                activeDesk = DeskView()
                
                activeDesk!.frame = CGRectZero
                
                activeDesk!.center = touch.locationInView(classroomView)
                
                classroomView.addSubview(activeDesk!)
                
                UIView.animateWithDuration(1.0)
                {
                    self.activeDesk!.bounds.size = self.classroom.deskSize
                }
            }
            else if let touchedDesk = touch.view as? DeskView
            {
                activeDesk = touchedDesk
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if touches.count > 1
        {
            NSLog("Unexpectedly got multi-touch action!")
            return
        }
        
        for touch in touches
        {
            if let touchDesk = self.activeDesk
            {
                let previousLocation = touch.previousLocationInView(classroomView)
                let currentLocation = touch.locationInView(classroomView)
                
                let xDelta = currentLocation.x - previousLocation.x
                let yDelta = currentLocation.y - previousLocation.y
                
                let oldCenter = touchDesk.center
                
                touchDesk.center = CGPoint(x: oldCenter.x + xDelta,
                                           y: oldCenter.y + yDelta)
            }

        }
        
        activeDesk = nil
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if touches.count > 1
        {
            NSLog("Unexpectedly got multi-touch action!")
            return
        }
        
        for touch in touches
        {
            if let touchDesk = self.activeDesk
            {
                let previousLocation = touch.previousLocationInView(classroomView)
                let currentLocation = touch.locationInView(classroomView)
                
                let xDelta = currentLocation.x - previousLocation.x
                let yDelta = currentLocation.y - previousLocation.y
                
                let oldCenter = touchDesk.center
                
                touchDesk.center = CGPoint(x: oldCenter.x + xDelta,
                                           y: oldCenter.y + yDelta)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        // Do nothing
    }
    
    
}

