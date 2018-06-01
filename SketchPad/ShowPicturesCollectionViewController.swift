//
//  ShowPicturesCollectionViewController.swift
//  SketchPad
//
//  Created by Rohith Raju on 31/05/18.
//  Copyright © 2018 Rohith Raju. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class ShowPicturesCollectionViewController: UICollectionViewController {

    var pictures: [Picture] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getPictures()
    }
   
    func getPictures(){
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            do{
                let pics = try context.fetch(Picture.fetchRequest()) as? [Picture]
                if let pics = pics{
                    self.pictures = pics
                    collectionView?.reloadData()
                }
            }catch{
                print("error fetching data:\(error)")
            }
            
           
            
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureCell{
            let picture = self.pictures[indexPath.row]
            cell.label.text = picture.name
            if let imageData = picture.image{
              cell.imageView.image = UIImage(data: imageData)
            }
            return cell
        }
      
        return UICollectionViewCell()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


class PictureCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
}

