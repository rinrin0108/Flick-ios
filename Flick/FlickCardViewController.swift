//
//  FlickCardViewController.swift
//  Flick
//
//  Created by Takaaki on 2015/08/01.
//  Copyright (c) 2015年 takaaki. All rights reserved.
//
import UIKit

class FlickCardViewController: ZLSwipeableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var segmentControl = UISegmentedControl(items: [" ", "←", "↑", "→", "↓", "↔︎", "↕︎", "☩"])
        segmentControl.selectedSegmentIndex = 5
        navigationItem.titleView = segmentControl
        
        let directions: [ZLSwipeableViewDirection] = [.None, .Left, .Up, .Right, .Down, .Horizontal, .Vertical, .All]
        segmentControl.forControlEvents(.ValueChanged) { control in
            if let control = control as? UISegmentedControl {
                self.swipeableView.direction = directions[control.selectedSegmentIndex]
            }
        }
    }
    
}
