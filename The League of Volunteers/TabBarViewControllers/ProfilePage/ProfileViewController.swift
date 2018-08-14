//
//  ProfileViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 23.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var collectionViewWithAllPosts: UICollectionView!
    @IBOutlet weak var ownActivitiesNumber: UILabel!
    @IBOutlet weak var usernameOfMember: UILabel!
    @IBOutlet weak var ownRank: UILabel!
    @IBOutlet weak var descriptionOfTheUser: UITextView!
    @IBOutlet weak var foreignActivities: UILabel!
    
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
        changeFontOfNavBar()
        
        myMainInfo()
        
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ProfileViewController.refresh), for: UIControlEvents.valueChanged)
        collectionViewWithAllPosts?.addSubview(refresher)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.reload(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        loadPosts()
        if self.tabBarController?.tabBar.isHidden == false{}
        else
        {
            swipeBack()
        }
    }
    
    func myMainInfo()
    {
        usernameOfMember.text = (PFUser.current()?.object(forKey: "username") as? String)
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground { (data, error) -> Void in
            self.avaOfTheUser.image = UIImage(data: data!)
        }
        ownRank.text = (PFUser.current()?.object(forKey: "rank") as? String)
        if PFUser.current()?.object(forKey: "bio") as? String == nil
        {
            descriptionOfTheUser.text = ""
        }
        else
        {
            descriptionOfTheUser.text = PFUser.current()?.object(forKey: "bio") as? String
        }
        let foreignQuery = PFQuery(className: "Foreign")
        foreignQuery.whereKey("username", equalTo: PFUser.current()!.username!)
        foreignQuery.findObjectsInBackground { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    let foreign = object["foreign"] as! String
                    self.foreignActivities.text = foreign
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        refresher.didMoveToSuperview()
        if stateOfChanges == 1
        {
            myMainInfo()
            stateOfChanges = 0
        }
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
    
    func loadPosts()
    {
        let query = PFQuery(className: "Posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picturesArray.removeAll(keepingCapacity: false)
                
                for object in objects!
                {
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picturesArray.append(object.value(forKey: "picture") as! PFFile)
                }
                self.collectionViewWithAllPosts.reloadData()
                self.ownActivitiesNumber.text = "\(self.picturesArray.count)"
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height
        {
            loadMorePosts()
        }
    }
    
    func loadMorePosts()
    {
        if page <= picturesArray.count
        {
            page = page + 8
            loadPosts()
        }
    }
    
    @IBAction func SettingsButtonPressed(_ sender: UIBarButtonItem)
    {
        PFUser.logOutInBackground { (error) -> Void in
            if error == nil
            {
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
            }
        }
    }
    @IBAction func editProfileButtonPressed(_ sender: UIBarButtonItem)
    {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        present(vc, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return picturesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "usersProfileCell", for: indexPath) as! UsersProfilePostCollectionViewCell
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
//        cell.imageOfUserPost.image = allUserPostsImages[indexPath.row]
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
