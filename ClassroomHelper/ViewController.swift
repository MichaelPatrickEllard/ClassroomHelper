//
//  ViewController.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/22/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit
import AVFoundation

enum Mode
{
    case AddDesk
    case AddChair
    case Passive
}

class ViewController: UIViewController {
    
    let classroom = Classroom()
    var classroomView: UIView!
    
    @IBOutlet weak var toolArea: UIView!
    
    var studentLabels: [StudentLabel]!
    
    var fixtureViews = [FixtureView]()
    
    var activeFixture: FixtureView?
    var activeStudentLabel: StudentLabel?
    
    var cameraIsOn = false
    
    var captureSession: AVCaptureSession?
    
    @IBOutlet weak var studentsButton: UIButton!
    
    var mode: Mode = .AddDesk
    
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let classroomFrame = CGRect(origin: CGPoint(x: 0, y: 0),
                                    size: classroom.roomSize)
        
        classroomView = UIView(frame: classroomFrame)
        
        classroomView.backgroundColor = UIColor.whiteColor()
        
        self.view.insertSubview(classroomView, atIndex:0)
        
        addStudentLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func studentsPressed(sender: AnyObject) {
    }
    
    @IBAction func deskPressed(sender: AnyObject)
    {
        self.mode = .AddDesk
    }
    
    @IBAction func chairPressed(sender: AnyObject)
    {
        self.mode = .AddChair
    }

    @IBAction func questionPressed(sender: AnyObject) {
    }
    
    
    @IBAction func answerPressed(sender: AnyObject) {
    }
    
    @IBAction func classroomPressed(sender: AnyObject) {
    }
    
    @IBAction func transformPressed(sender: AnyObject) {
    }
    
    @IBAction func videoPressed(sender: AnyObject)
    {
        if !cameraIsOn
        {
            let session = AVCaptureSession()
            session.sessionPreset = AVCaptureSessionPresetHigh
            
            let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
            do
            {
                let input = try AVCaptureDeviceInput(device: backCamera)
                
                session.addInput(input)
                
                session.startRunning()
                
                previewLayer = AVCaptureVideoPreviewLayer(session: session)
                
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                self.classroomView.layer.insertSublayer(previewLayer!, atIndex: 0)
                
                previewLayer!.frame = self.classroomView.frame
                
                self.captureSession = session
                
                cameraIsOn = true

            }
            catch
            {
                NSLog("Dang!  Camera initialization failed...")
            }
        }
        else
        {
            cameraIsOn = false
            
            self.captureSession?.stopRunning()
            
            previewLayer?.removeFromSuperlayer()
            
            previewLayer = nil
            
            self.captureSession = nil
        }
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
                if self.mode == .AddDesk || self.mode == .AddChair
                {
                    activeFixture = mode == .AddDesk ? DeskView() : ChairView()
                    
                    activeFixture!.frame = CGRectZero
                    
                    activeFixture!.center = touch.locationInView(classroomView)
                    
                    classroomView.addSubview(activeFixture!)
                    
                    fixtureViews.append(activeFixture!)
                    
                    UIView.animateWithDuration(1.0)
                    {
                        let fixtureSize = self.mode == .AddDesk ? self.classroom.deskSize : self.classroom.chairSize
                        
                        self.activeFixture!.bounds.size = fixtureSize
                    }
                }
            }
            else if let touchedFixture = touch.view as? FixtureView
            {
                activeFixture = touchedFixture
            }
            else if let selectedStudent = touch.view as? StudentLabel
            {
                
                
                activeStudentLabel = selectedStudent
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
            if let touchFixture = self.activeFixture
            {
                if self.classroomView.pointInside(touch.locationInView(self.classroomView), withEvent: event)
                {
                    let previousLocation = touch.previousLocationInView(classroomView)
                    let currentLocation = touch.locationInView(classroomView)
                    
                    let xDelta = currentLocation.x - previousLocation.x
                    let yDelta = currentLocation.y - previousLocation.y
                    
                    let oldCenter = touchFixture.center
                    
                    touchFixture.center = CGPoint(x: oldCenter.x + xDelta,
                                               y: oldCenter.y + yDelta)
                }
                else
                {
                    UIView.animateWithDuration(1.0, animations:
                        {
                            touchFixture.bounds.size = CGSizeZero
                        },
                        completion:
                        {(Bool) -> Void in
                            touchFixture.removeFromSuperview()
                            if let sLabel = touchFixture.studentLabel
                            {
                                self.toolArea.addSubview(sLabel)
                                sLabel.student.desk = nil
                                sLabel.frame = CGRectZero
                                touchFixture.studentLabel = nil
                                
                                self.layoutStudentLabels(animated: true)
                            }
                            
                            self.fixtureViews = self.fixtureViews.filter({$0 !== touchFixture})
                            
                            
                        })
                }
            }
            else if let selectedStudent = self.activeStudentLabel
            {
                for fixtureView in fixtureViews
                {
                    if fixtureView.studentLabel == nil && fixtureView.pointInside(touch.locationInView(fixtureView), withEvent: event)
                    {
                        fixtureView.studentLabel = selectedStudent
                        selectedStudent.student.desk = fixtureView
                        
                        fixtureView.addSubview(selectedStudent)
                        let newCenter = CGPoint(x: fixtureView.bounds.size.width / 2, y: fixtureView.bounds.size.height / 2)
                        selectedStudent.center = newCenter
                        break
                    }
                }
                
                self.layoutStudentLabels(animated: true)
            }

        }
        
        activeFixture = nil
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if touches.count > 1
        {
            NSLog("Unexpectedly got multi-touch action!")
            return
        }
        
        for touch in touches
        {
            if let touchDesk = self.activeFixture
            {
                let previousLocation = touch.previousLocationInView(classroomView)
                let currentLocation = touch.locationInView(classroomView)
                
                let xDelta = currentLocation.x - previousLocation.x
                let yDelta = currentLocation.y - previousLocation.y
                
                let oldCenter = touchDesk.center
                
                touchDesk.center = CGPoint(x: oldCenter.x + xDelta,
                                           y: oldCenter.y + yDelta)
            }
            else if let selectedStudent = self.activeStudentLabel
            {
                let previousLocation = touch.previousLocationInView(self.view)
                let currentLocation = touch.locationInView(self.view)
                
                let xDelta = currentLocation.x - previousLocation.x
                let yDelta = currentLocation.y - previousLocation.y
                
                let oldCenter = selectedStudent.center
                
                selectedStudent.center = CGPoint(x: oldCenter.x + xDelta,
                                                 y: oldCenter.y + yDelta)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        // Do nothing
    }
    
    func addStudentLabels()
    {
        var sLabels = [StudentLabel]()
        
        for student in self.classroom.students
        {
            let newLabel = StudentLabel(student: student)
            
            sLabels.append(newLabel)
            
            toolArea.addSubview(newLabel)
            
        }
        
        self.studentLabels = sLabels
        
        layoutStudentLabels(animated: false)
    }
    
    func layoutStudentLabels(animated animated: Bool)
    {
        if animated
        {
            UIView.animateWithDuration(1.0)
            {
                self.layoutStudentLabels()
            }
        }
        else
        {
            layoutStudentLabels()
        }
    }
    
    
    func layoutStudentLabels()
    {
        var unusedLabelCount: CGFloat = 0
        
        for label in studentLabels
        {
            if label.student.desk == nil
            {
                unusedLabelCount += 1
                
                let labelSize = label.intrinsicContentSize()
                
                label.bounds.size = labelSize
                
                label.center = CGPoint(x: studentsButton.center.x,
                                       y: studentsButton.center.y + unusedLabelCount * (labelSize.height + 10))
            }
        }
    }
    
    
}

