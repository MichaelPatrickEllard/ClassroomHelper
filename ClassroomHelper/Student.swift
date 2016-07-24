//
//  Student.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/23/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit

class Student: NSObject
{
    let name: String
    var comments: String
    weak var desk: FixtureView?
    
    var questionsAsked = 0
    var questionsAnswered = 0
    
    init(name: String, comments: String)
    {
        self.name = name
        self.comments = comments
    }
    
    static func defaultClassList() -> [Student]
    {
        var students = [Student]()
        
        students.append(Student(name: "Winnie Chen", comments: "Picks up new topics fast."))
        students.append(Student(name: "Mike Ellard", comments: "Thinks he's supposed to be teaching the class."))
        students.append(Student(name: "Bruce Chou", comments: "Knows everyone in the class."))
        students.append(Student(name: "Ada Lovelace", comments: "Mathematics as Poetry."))
        students.append(Student(name: "Jacob Dudney", comments: "Great UX Designer."))
        students.append(Student(name: "Grace Hopper", comments: "Get her to show you her millisecond."))
        students.append(Student(name: "Chris Lattner", comments: "He's a pretty swift guy."))
        students.append(Student(name: "Nikola Tesla", comments: "Shouldn't be seated next to Edison."))
        students.append(Student(name: "Charles Babbage", comments: "If you build it, they will come."))
        students.append(Student(name: "Thomas Edison", comments: "When asked about his homework, says, 'I've tried 999 ways that didn't work."))
        students.append(Student(name: "Steve Wozniak", comments: "Doesn't trust a computer unless he can throw it out the window.  Didn't trust his computer.  Threw it out the window."))
        students.append(Student(name: "Alan Turing", comments: "Seems a little wooden sometimes. Never quite sure if he's a person or a computer."))
    
        return students
    }
}
