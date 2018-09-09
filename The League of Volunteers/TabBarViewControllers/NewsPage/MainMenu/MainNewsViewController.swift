//
//  MainNewsViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 23.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class MainNewsViewController: UIViewController {

    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var usersAva: UIImageView!
    @IBOutlet weak var darkenForeground: UIView!
    
    var indexOfPage = 0
    var imagesForPost: [String] = []
    var avaForPost: String = ""
    var descriptionForPost: [String] = []
    var isUserEnteredTheFirstTime = false
    
    @IBOutlet weak var collectionViewFourPages: UICollectionView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        newsImage.layer.cornerRadius = 16
        newsImage.layer.masksToBounds = true
        
        usersAva.layer.cornerRadius = usersAva.frame.width / 2
        usersAva.layer.masksToBounds = true
        
        darkenForeground.layer.cornerRadius = 16
        darkenForeground.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        changeFontOfNavBar()
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data, error) -> Void in
            self.usersAva.image = UIImage(data: data!)
        }
        isUserEnteredTheFirstTime = false
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationVC = segue.destination as? GuideFirstViewController
//        {
//            destinationVC.isUserEnteredTheFirstTime = isUserEnteredTheFirstTime
//        }
//    }

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
