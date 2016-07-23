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
        
        for touch in touches
        {
            if touch.view == classroomView
            {
                let newDesk = DeskView()
                
                newDesk.frame = CGRect(origin: touch.locationInView(classroomView),
                                       size: classroom.deskSize)
                
                classroomView.addSubview(newDesk)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        // Do nothing
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        // Do nothing
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        // Do nothing
    }
    
    
}

