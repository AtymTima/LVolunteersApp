//
//  GuestViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 08.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

var guestName = [String]()

class GuestViewController: UIViewController {

    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var collectionViewWithAllPosts: UICollectionView!
    @IBOutlet weak var ownActivitiesNumber: UILabel!
    @IBOutlet weak var usernameOfMember: UILabel!
    @IBOutlet weak var ownRank: UILabel!
    
    var refresher: UIRefreshControl!
    var page: Int = 8
    var uuidArray = [String]()
    var picturesArray = [PFFile]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.collectionViewWithAllPosts?.alwaysBounceVertical = true
        avaOfTheUser.layer.cornerRadius = avaOfTheUser.frame.width / 2
        avaOfTheUser.layer.masksToBounds = true
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(GuestViewController.refresh), for: UIControlEvents.valueChanged)
        collectionViewWithAllPosts?.addSubview(refresher)
        NotificationCenter.default.addObserver(self, selector: #selector(GuestViewController.reload(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)

        loadMainInfoOfGuestUser()
        loadPosts()
        
        if self.tabBarController?.tabBar.isHidden == false
        {
            let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.back))
            backSwipe.direction = UISwipeGestureRecognizerDirection.right
            self.view.addGestureRecognizer(backSwipe)
        }
        else
        {
            swipeBack()
        }
        
    }
    
    func loadMainInfoOfGuestUser()
    {
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestName.last!)
        infoQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                if objects!.isEmpty
                {
                    self.showAlertMessge(title: "Ошибка", message: "Такого пользователя не существует", answer: "OK")
                }
                else
                {
                    for object in objects!
                    {
                        self.usernameOfMember.text = object.value(forKey: "username") as? String
                        let avaQuery = object.value(forKey: "ava") as? PFFile
                        avaQuery?.getDataInBackground { (data, error) -> Void in
                            self.avaOfTheUser.image = UIImage(data: data!)
                        }
                        self.ownRank.text = object.value(forKey: "rank") as? String
                    }
                }
            }
        })
    }
    
    func loadPosts()
    {
        let query = PFQuery(className: "Posts")
        query.whereKey("username", equalTo: guestName.last!)
        query.limit = page
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil {
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picturesArray.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picturesArray.append(object.value(forKey: "picture") as! PFFile)
                }
                
                self.collectionViewWithAllPosts?.reloadData()
                self.ownActivitiesNumber.text = "\(self.picturesArray.count)"
                
            } else {
                self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
            }
        })
    }
    
    @objc func refresh()
    {
        loadPosts()
        refresher.endRefreshing()
    }
    
    @objc func reload(_ notification:Notification)
    {
        collectionViewWithAllPosts?.reloadData()
    }
    
    @objc func back(_ sender : UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
        if !guestName.isEmpty {
            guestName.removeLast()
        }
    }
    

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

extension GuestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return picturesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guestProfileCell", for: indexPath) as! UsersProfilePostCollectionViewCell
        picturesArray[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil
            {
                cell.imageOfUserPost.image = UIImage(data: data!)
            }
            else
            {
                self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let itemSize = collectionViewWithAllPosts.frame.size.width / 2 - padding
        let itemHeight = itemSize / 1.77
        
        return CGSize(width: itemSize, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        postuuid.append(uuidArray[indexPath.row])
        let post = self.storyboard?.instantiateViewController(withIdentifier: "ActivitiesDetailedViewController") as! ActivitiesDetailedViewController
        self.present(post, animated: true, completion: nil)
    }
    
}
