//
//  ViewController.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/22/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    let classroom = Classroom()
    var classroomBackingView: UIView!
    var classroomView: UIView!
    
    @IBOutlet weak var toolArea: UIView!
    
    var studentLabels: [StudentLabel]!
    
    var fixtureViews = [FixtureView]()
    
    var activeMarker: UIView!
    var markerHome: CGPoint!
    
    var activeFixture: FixtureView?
    var activeStudentLabel: StudentLabel?
    
    var cameraIsOn = false
    
    var captureSession: AVCaptureSession?
    
    @IBOutlet weak var fixtureTypes: UISegmentedControl!
    
    @IBOutlet weak var studentsButton: UIButton!
    
    @IBOutlet weak var threeDSlider: UISlider!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var panSlider: UISlider!
    
    @IBOutlet weak var zoomSlider: UISlider!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let classroomFrame = CGRect(origin: CGPoint(x: 0, y: 0),
                                    size: classroom.roomSize)
        
        classroomView = UIView(frame: classroomFrame)
        
        classroomView.backgroundColor = UIColor.clearColor()
        
        self.view.insertSubview(classroomView, atIndex:0)
        
        classroomBackingView = UIView(frame: classroomFrame)
        
        classroomBackingView.backgroundColor = UIColor.whiteColor()
        
        self.view.insertSubview(classroomBackingView, atIndex: 0)
        
        addStudentLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func questionPressed(sender: AnyObject) {
    }
    
    
    @IBAction func answerPressed(sender: AnyObject) {
    }
    
    @IBAction func classroomPressed(sender: AnyObject) {
    }
    
    @IBAction func videoToggled(sender: UISwitch)
    {
        if sender.on
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
                
                self.classroomBackingView.layer.addSublayer(previewLayer!)
                
                previewLayer!.frame = self.classroomBackingView.frame
                
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
            if touch.view?.tag == 43 || touch.view?.tag == 47
            {
                activeMarker = touch.view
                markerHome = touch.view!.center
            }
            else if touch.view == classroomView
            {
                if true // May add a test later that allows us to turn off adding fixtures
                {
                    activeFixture = fixtureTypes.selectedSegmentIndex == 0 ? DeskView() : ChairView()
                    
                    activeFixture!.frame = CGRectZero
                    
                    activeFixture!.center = touch.locationInView(classroomView)
                    
                    classroomView.addSubview(activeFixture!)
                    
                    fixtureViews.append(activeFixture!)
                    
                    UIView.animateWithDuration(1.0)
                    {
                        let fixtureSize = self.fixtureTypes.selectedSegmentIndex == 0 ? self.classroom.deskSize : self.classroom.chairSize
                        
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
                if let studentFixture = selectedStudent.student.desk
                {
                    activeFixture = studentFixture
                }
                else
                {
                    activeStudentLabel = selectedStudent
                }
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
            if touch.view?.tag == 43 || touch.view?.tag == 47
            {
                for fixtureView in fixtureViews
                {
                    if fixtureView.studentLabel != nil && fixtureView.pointInside(touch.locationInView(fixtureView), withEvent: event)
                    {
                        let markerString = touch.view?.tag == 47 ? "🔶" : "🔷"
                        
                        fixtureView.studentLabel?.addMarker(markerString)
                        
                        activeMarker.center = markerHome
                    
                        break
                    }
                }

            }
            else if let touchFixture = self.activeFixture
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
        activeStudentLabel = nil
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if touches.count > 1
        {
            NSLog("Unexpectedly got multi-touch action!")
            return
        }
        
        for touch in touches
        {
            if touch.view?.tag == 43 || touch.view?.tag == 47
            {
                let previousLocation = touch.previousLocationInView(classroomView)
                let currentLocation = touch.locationInView(classroomView)
                
                let xDelta = currentLocation.x - previousLocation.x
                let yDelta = currentLocation.y - previousLocation.y
                
                let oldCenter = activeMarker.center
                
                activeMarker.center = CGPoint(x: oldCenter.x + xDelta,
                                           y: oldCenter.y + yDelta)
            }
            else if let touchDesk = self.activeFixture
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
            UIView.animateWithDuration(0.5)
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
    
    
    @IBAction func transformView(sender: AnyObject)
    {
        //classroomView.layer.zPosition = 100
        
        classroomView.layer.anchorPoint = CGPointMake(CGFloat(panSlider.value), CGFloat(zoomSlider.value));
        
        var projection = CATransform3DIdentity
        projection.m34 = CGFloat(self.threeDSlider.value) / 100
        let scale = CATransform3DMakeScale(1.0, /* 7 * sqrt(2) */ 1.5, 1.0)
        let translation = CATransform3DRotate(scale, CGFloat(-M_PI) / 4, 1, 0, 0)
        classroomView.layer.transform = CATransform3DConcat(translation, projection);
    }

    
}

