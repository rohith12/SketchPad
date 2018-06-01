//
//  DrawViewController.swift
//  SketchPad
//
//  Created by Rohith Raju on 29/05/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import UIKit
import ChromaColorPicker

class DrawViewController: UIViewController,ChromaColorPickerDelegate {
   

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    var lastPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var brushSize: Float = 2.0
    var selectedColor: CGColor = UIColor.blue.cgColor
    var colorPicker: ChromaColorPicker?
    var grayedOut = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        grayedOut = UIView(frame: view.frame)
        grayedOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(grayedOut)
        
        colorPicker = ChromaColorPicker(frame: CGRect(x: view.frame.size.width/2-100, y: view.frame.size.height/2-100, width: 200, height: 200))
        if let picker = colorPicker{
            picker.delegate = self
            picker.padding = 5
            picker.stroke = 3
            picker.hexLabel.isHidden = true
            view.addSubview(picker)
        }
        colorPicker?.isHidden = true
        grayedOut.isHidden = true
    }

    @IBAction func saveAction(_ sender: Any) {
        
        let ac = UIAlertController(title: "Name your picture", message: nil, preferredStyle: .alert)
        ac.addTextField { (textfield) in
            textfield.placeholder = "My Masterpeice"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let name = ac.textFields?.first?.text{
                if name != ""{
                    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                      let picture = Picture(context: context)
                      picture.name = name
                      if let image = self.imageView.image{
                         picture.image = UIImageJPEGRepresentation(image, 1)
                        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                      }
                   }
                  self.dismiss(animated: true, completion: nil)
               }
             }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        ac.addAction(cancel)
        ac.addAction(saveAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteArt(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    @IBAction func colorTapped(_ sender: Any) {
        colorPicker?.adjustToColor(UIColor(cgColor: selectedColor))
        colorPicker?.isHidden = false
        grayedOut.isHidden = false

    }
    
    @IBAction func sizeTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "Brush Size", message: "\n\n", preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 10, y: 70, width: 250, height: 30))
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
        stackView.isHidden = true
        
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
        
        stackView.isHidden = false

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
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        selectedColor = color.cgColor
        colorPicker.isHidden = true
        grayedOut.isHidden = true

    }
    
    
}
