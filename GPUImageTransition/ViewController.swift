//
//  ViewController.swift
//  GPUImageTransition
//
//  Created by dimsky on 16/8/14.
//  Copyright © 2016年 dimsky. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    var gpuImageView: GPUImageView!
    let actionButton = UIButton()

    var filter: GPUImagePixellateFilter!
    var gpuImagePic: GPUImagePicture!

    let imageView = UIImageView()
    let image = UIImage(named: "a")
    var displayLink: CADisplayLink!
    var startTime: NSTimeInterval = 0
    var isShow: Bool = false
    let duration: CGFloat = 2
    var progress: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        actionButton.frame = CGRect(x: 10, y: 80, width: 100, height: 40)
        actionButton.setTitle("Show", forState: .Normal)
        actionButton.backgroundColor = UIColor.greenColor()
        self.view.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(imageAction), forControlEvents: .TouchUpInside)


        gpuImageView = GPUImageView()
        gpuImageView.frame = CGRect(x: 0, y: 140, width: CGRectGetWidth(self.view.frame), height: 550)

        gpuImagePic = GPUImagePicture(image: image)
        filter = GPUImagePixellateFilter()
        filter.addTarget(gpuImageView)
        filter.forceProcessingAtSize(image!.size)
        filter.fractionalWidthOfAPixel = 0.1
        filter.useNextFrameForImageCapture()
        gpuImagePic.addTarget(filter)
        gpuImagePic.processImage()
        self.view.addSubview(gpuImageView)

        displayLink = CADisplayLink(target: self, selector: #selector(transition(_:)))
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        displayLink.paused = true
    }

    func imageAction() {
        progress = 0
        startTime = 0
        displayLink.paused = false

        if isShow {
            isShow = false
            actionButton.setTitle("Show", forState: .Normal)
        } else {
            isShow = true
            actionButton.setTitle("Hide", forState: .Normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func transition(link: CADisplayLink) {
        if startTime == 0 {
            startTime = link.timestamp
        }
        progress = max(0, min(CGFloat(link.timestamp - startTime) / duration, 1))

        if isShow {
            filter.fractionalWidthOfAPixel = 0.1 * (1 - progress)
        } else {
            filter.fractionalWidthOfAPixel = 0.1 * progress
        }

        gpuImagePic.processImage()

        if progress == 1 {
            displayLink.paused = true
        }
    }

}

