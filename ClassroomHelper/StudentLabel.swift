//
//  StudentLabel.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/23/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit

class StudentLabel: UILabel
{
    let student: Student
    
    init(student: Student)
    {
        self.student = student
        super.init(frame: CGRectZero)
        self.text = student.name
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.student = Student(name: "Unitialized", comments:"")
        super.init(coder: aDecoder)
    }
    
    func addMarker(marker: String)
    {
        self.text = self.text! + marker
        
        self.bounds = CGRect(origin: CGPointZero, size: self.intrinsicContentSize())
        
        let superFrame = superview!.frame
        
        self.center = CGPoint(x: superFrame.size.width / 2,
                              y: superFrame.size.height / 2)
    }
}
