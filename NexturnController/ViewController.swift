//
//  ViewController.swift
//  NexturnController
//
//  Created by Kengo Yokoyama on 2014/12/24.
//  Copyright (c) 2014年 Kengo Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var redButton: UIButton!
    @IBOutlet fileprivate weak var greenButton: UIButton!
    @IBOutlet fileprivate weak var blueButton: UIButton!
    @IBOutlet fileprivate weak var whiteButton: UIButton!
    @IBOutlet fileprivate weak var randomButton: UIButton!
    @IBOutlet fileprivate weak var offButton: UIButton!
    
    var centralManager = CentralManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue.global(qos: .default)
        centralManager = CentralManager(delegate: self.centralManager, queue: queue, options: nil)
    }

    @IBAction func ledButtonTapped(_ sender: AnyObject) {
        centralManager.ledButtonTapped(sender.tag)
    }
}
