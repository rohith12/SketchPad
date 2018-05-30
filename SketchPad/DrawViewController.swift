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
    var brushSize: Float = 2.0
    var selectedColor: CGColor = UIColor.blue.cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func colorTapped(_ sender: Any) {
    }
    
    @IBAction func sizeTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "Brush Size", message: "\n\n", preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 20, y: 70, width: 250, height: 30))
        slider.minimumValue = 1.0
        slider.maximumValue = 100.0
        slider.value = brushSize
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.brushSize = slider.value
        }
        ac.view.addSubview(slider)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func eraseTapped(_ sender: Any) {
        selectedColor = UIColor.white.cgColor
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
            context.setLineWidth(CGFloat(brushSize/3.0))
            context.setLineCap(.round)
            context.setStrokeColor(selectedColor)
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
    }
    
}
