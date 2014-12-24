//
//  ViewController.swift
//  NexturnController
//
//  Created by Y.K on 2014/12/24.
//  Copyright (c) 2014年 Yokoyama Kengo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var redButton: UIButton!
    @IBOutlet private weak var greenButton: UIButton!
    @IBOutlet private weak var blueButton: UIButton!
    @IBOutlet private weak var whiteButton: UIButton!
    @IBOutlet private weak var randomButton: UIButton!
    @IBOutlet private weak var offButton: UIButton!
    var centralManager = CentralManager.alloc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        centralManager = CentralManager(delegate: self.centralManager, queue: queue, options: nil)
    }

    // 押されたボタンに対応したデータを渡す
    @IBAction func ledButtonTapped(sender: AnyObject) {
        centralManager.ledButtonTapped(sender.tag)
    }
}
