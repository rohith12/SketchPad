//
//  DrawViewController.swift
//  SketchPad
//
//  Created by Rohith Raju on 29/05/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var lastPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let beginPoint = touches.first?.location(in: imageView){
            lastPoint = beginPoint
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let movedPoint = touches.first?.location(in: imageView){
            drawBetweenTwoPoints(lastPoint, movedPoint)
            lastPoint = movedPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let endPoint = touches.first?.location(in: imageView){
            drawBetweenTwoPoints(lastPoint, endPoint)
        }
    }
    
    func drawBetweenTwoPoints(_ point1: CGPoint,_ point2: CGPoint){
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        if let context = UIGraphicsGetCurrentContext(){
            context.move(to: point1)
            context.addLine(to: point2)
            context.setLineWidth(2.0)
            context.setLineCap(.round)
            context.setStrokeColor(UIColor.red.cgColor)
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
    }
    
}
