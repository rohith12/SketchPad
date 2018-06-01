//
//  DetailViewController.swift
//  SketchPad
//
//  Created by Rohith Raju on 31/05/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var picture: Picture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = picture?.name
        if let imageData = picture?.image{
            imageView.image = UIImage(data:imageData)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            if let picToBeDeleted = picture{
                context.delete(picToBeDeleted)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        if let image = imageView.image{
            let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(shareVC, animated: true, completion: nil)
        }
    
    }


}
