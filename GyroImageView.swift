//
//  GyroImageView.swift
//  newQ8App
//
//  Created by Anton Sleptsov on 26/07/17.
//  Copyright © 2017 Anton Sleptsov. All rights reserved.
//

import Foundation
import CoreMotion

private let gyroUpdateInterval: TimeInterval = 0.1

class GyroImageView: UIView
{
    var xMaxOffset = CGFloat(20)
    var yMaxOffset = CGFloat(20)
    
    private var motionManager = CMMotionManager()
    private var imageView = UIImageView()
    
    private var imageViewCenter: CGPoint = .zero
    
    var imageContentMode: UIViewContentMode = UIViewContentMode.scaleToFill{
        didSet{
            imageView.contentMode = imageContentMode
        }
    }
    
    var image: UIImage? = nil{
        didSet{
            imageView.image = image
        }
    }
    
    override var frame: CGRect{
        didSet{
            imageView.frame = CGRect(origin: .zero, size: frame.size)
            imageViewCenter = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            
            imageView.contentMode = .bottom
        }
    }    
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView(){
        addSubview(imageView)
        
        if motionManager.isGyroAvailable{
            if !motionManager.isGyroActive{
                motionManager.gyroUpdateInterval = gyroUpdateInterval
                
                motionManager.startDeviceMotionUpdates(to: .main){
                    [weak self] (data: CMDeviceMotion?, error: Error?) in
                    if let gravity = data?.gravity{
                        let xG = CGFloat(gravity.x)
                        let yG = CGFloat(gravity.y)
                        
                        let xOffset = xG * (self?.xMaxOffset)!
                        let yOffset = yG * (self?.yMaxOffset)!
                        
                        self?.offsetImage(xOffset: -xOffset, yOffset: yOffset)
                    }
                }
            }
        }
    }
    
    private func offsetImage(xOffset: CGFloat, yOffset: CGFloat){
        var newCenter = imageViewCenter
        newCenter.x += xOffset
        newCenter.y += yOffset
        
        imageView.center = newCenter
    }
}
