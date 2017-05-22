//
//  ViewController.swift
//  Progress
//
//  Created by Henrique Valcanaia on 22/05/17.
//  Copyright © 2017 Henrique Valcanaia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let rootProgress = Progress()
    private let sizeTask1 = 30000
    private let progressObjectKeyPath = "fractionCompleted"
    
    @IBOutlet private weak var progressBar: UIProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        progressBar?.observedProgress = rootProgress
        rootProgress.addObserver(self, forKeyPath: progressObjectKeyPath, options: [.new, .old, .prior, .initial], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let progress = object as? Progress, progress == rootProgress {
            if keyPath == progressObjectKeyPath {
                DispatchQueue.main.async {
                    let progressValue = Float(progress.fractionCompleted)
                    print("Progress: \(progressValue)")
                    self.progressBar?.progress = progressValue
                }
            }
        }
    }
    
    @IBAction func performTasks() {
        performTask1()
        performTask2()
    }
    
    private func performTask1() {
        let p1 = Progress(totalUnitCount: Int64(sizeTask1))
        rootProgress.addChild(p1, withPendingUnitCount: 1)
        DispatchQueue.global(qos: .background).async {
            for i in 0..<self.sizeTask1 {
//                print("Task1: \(i)")
                DispatchQueue.main.async { p1.completedUnitCount += 1 }
            }
        }
    }
    private func performTask2() {
        // Three times longer than task1
        let size2 = sizeTask1*3
        let p2 = Progress(totalUnitCount: Int64(size2))
        rootProgress.addChild(p2, withPendingUnitCount: Int64(size2/sizeTask1))
        DispatchQueue.global(qos: .background).async {
            for i in 0..<size2 {
//                print("Task2: \(i)")
                DispatchQueue.main.async { p2.completedUnitCount += 1 }
            }
        }
    }
    
}

