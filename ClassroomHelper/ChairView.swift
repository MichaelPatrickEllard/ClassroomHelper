//
//  ChairView.swift
//  ClassroomHelper
//
//  Created by Rescue Mission Software on 7/23/16.
//  Copyright © 2016 RescueMissionSoftware. All rights reserved.
//

import UIKit

class ChairView: FixtureView {

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.75, alpha: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
