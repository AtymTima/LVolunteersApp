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
        upgradeUser.isEnabled = false
        upgradeUser.isHidden = true
        
        self.collectionViewWithAllPosts?.alwaysBounceVertical = true
        avaOfTheUser.layer.cornerRadius = avaOfTheUser.frame.width / 2
        avaOfTheUser.layer.masksToBounds = true
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(GuestViewController.refresh), for: UIControlEvents.valueChanged)
        collectionViewWithAllPosts?.addSubview(refresher)
        NotificationCenter.default.addObserver(self, selector: #selector(GuestViewController.reload(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)

        loadMainInfoOfGuestUser()
        loadPosts()
        checkTheRole()
        
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
    
    func checkTheRole()
    {
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    if object.value(forKey: "role") as! String == "admin"
                    {
                        self.upgradeUser.isHidden = false
                        self.upgradeUser.isEnabled = true
                    }
                }
            }
        })
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
                        
                        let foreignQuery = PFQuery(className: "Foreign")
                        foreignQuery.whereKey("username", equalTo: guestName.last!)
                        foreignQuery.findObjectsInBackground { (objs, error) -> Void in
                            if error == nil
                            {
                                for obj in objs!
                                {
                                    let rank = obj["rank"] as! String
                                    self.ownRank.text = rank
                                }
                            }
                        }
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
    
    @IBOutlet weak var upgradeUser: UIButton!
    @IBAction func upgradeUserButtonPressed(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Вы уверены?", message: "Подтвердив это действие, данный пользователь мгновенно повысит свой ранк", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Согласен", style: .destructive, handler: {(action:UIAlertAction!) in
            self.checkCurrentRank()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func checkCurrentRank()
    {
        let query = PFQuery(className: "Foreign")
        query.whereKey("username", equalTo: guestName.last!)
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    if object.value(forKey: "rank") as! String == "CC"
                    {
                        object["rank"] = "CB"
                        self.ownRank.text = "CB"
                    }
                    else if object.value(forKey: "rank") as! String == "CB"
                    {
                        object["rank"] = "CA"
                        self.ownRank.text = "CA"
                    }
                    else if object.value(forKey: "rank") as! String == "CA"
                    {
                        object["rank"] = "BC"
                        self.ownRank.text = "BC"
                    }
                    else if object.value(forKey: "rank") as! String == "BC"
                    {
                        object["rank"] = "BB"
                        self.ownRank.text = "BB"
                    }
                    else if object.value(forKey: "rank") as! String == "BB"
                    {
                        object["rank"] = "BA"
                        self.ownRank.text = "BA"
                    }
                    else if object.value(forKey: "rank") as! String == "BA"
                    {
                        object["rank"] = "AC"
                        self.ownRank.text = "AC"
                    }
                    else if object.value(forKey: "rank") as! String == "AC"
                    {
                        object["rank"] = "AB"
                        self.ownRank.text = "AB"
                    }
                    else if object.value(forKey: "rank") as! String == "AB"
                    {
                        object["rank"] = "AA"
                        self.ownRank.text = "AA"
                    }
                    object.saveEventually()
                }
            }
        })
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
