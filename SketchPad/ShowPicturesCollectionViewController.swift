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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let picture = self.pictures[indexPath.row]
        performSegue(withIdentifier: "details", sender: picture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc =  segue.destination as? DetailViewController{
            if let pic = sender as? Picture{
                dvc.picture = pic
            }
        }
    }

}


class PictureCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    
}

