//
//  NotificationsViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 23.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class NotificationsViewController: UIViewController {

    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var viewWithContentOfActivity: UIView!
    @IBOutlet weak var lookAtAllMembersButton: UIButton!
    @IBOutlet weak var imageOfCurrentActivity: UIImageView!
    @IBOutlet weak var nameOfCurrentActivity: UILabel!
    @IBOutlet weak var numberOfMembers: UILabel!
    @IBOutlet weak var addedActivitiesText: UILabel!
    @IBOutlet weak var activeOrNotText: UILabel!
    @IBOutlet weak var tableViewNotifications: UITableView!
    
    var gradientLayer: CAGradientLayer!
    var isFinished = true
    var pictures = [PFFile]()
    var names = [String]()
    
    var username = [String]()
    var ava = [PFFile]()
    var types = [String]()
    var whenCreated = [Date?]()
    var uuid = [String]()
    var owner = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        changeFontOfNavBar()
        behindView.backgroundColor = UIColor(red: 43/255.0, green: 49/255.0, blue: 83/255.0, alpha: 1)
        imageOfCurrentActivity.layer.cornerRadius = 8
        imageOfCurrentActivity.layer.masksToBounds = true
        
        
        showAllNotifications()
        
        self.lookAtAllMembersButton.alpha = 0
        self.imageOfCurrentActivity.alpha = 0
        self.numberOfMembers.alpha = 0
        self.activeOrNotText.alpha = 0
        self.nameOfCurrentActivity.alpha = 0
        self.addedActivitiesText.alpha = 0
        self.lookAtAllMembersButton.isEnabled = false
        self.tableViewNotifications.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        findCurrentActivities()
    }
    
    func showAllNotifications()
    {
        let query = PFQuery(className: "News")
        query.whereKey("to", equalTo: PFUser.current()!.username!)
        query.limit = 20
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil {
                self.username.removeAll(keepingCapacity: false)
                self.ava.removeAll(keepingCapacity: false)
                self.types.removeAll(keepingCapacity: false)
                self.whenCreated.removeAll(keepingCapacity: false)
                self.uuid.removeAll(keepingCapacity: false)
                self.owner.removeAll(keepingCapacity: false)
                for object in objects! {
                    self.username.append(object.object(forKey: "by") as! String)
                    self.ava.append(object.object(forKey: "ava") as! PFFile)
                    self.types.append(object.object(forKey: "type") as! String)
                    self.whenCreated.append(object.createdAt)
                    self.uuid.append(object.object(forKey: "uuid") as! String)
                    self.owner.append(object.object(forKey: "owner") as! String)
                    object["checked"] = "yes"
                    object.saveEventually()
                }

                self.tableViewNotifications.reloadData()
            }
        })
    }
    
    func findCurrentActivities()
    {
        let postQuery = PFQuery(className: "Posts")
        postQuery.whereKey("username", equalTo: PFUser.current()!.username!)
        postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    if object.value(forKey: "isFinished") as! String == "false"
                    {
                        self.isFinished = false
                        self.names.removeAll(keepingCapacity: false)
                        self.pictures.removeAll(keepingCapacity: false)
                        self.names.append(object.value(forKey: "name") as! String)
                        self.pictures.append(object.value(forKey: "picture") as! PFFile)
                        
                        self.nameOfCurrentActivity.text = self.names[0]
                        self.pictures[0].getDataInBackground { (data, error) -> Void in
                            if error == nil
                            {
                                self.imageOfCurrentActivity.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                if self.isFinished == true
                {
                    self.lookAtAllMembersButton.isEnabled = false
                    self.lookAtAllMembersButton.isHidden = true
                    self.imageOfCurrentActivity.isHidden = true
                    self.numberOfMembers.isHidden = true
                    self.activeOrNotText.isHidden = false
                    self.activeOrNotText.sizeToFit()
                    self.nameOfCurrentActivity.isHidden = true
                    self.addedActivitiesText.isHidden = true
                }
                else if self.isFinished == false
                {
                    self.lookAtAllMembersButton.isEnabled = true
                    self.lookAtAllMembersButton.isHidden = false
                    self.imageOfCurrentActivity.isHidden = false
                    self.numberOfMembers.isHidden = false
                    self.activeOrNotText.isHidden = true
                    self.nameOfCurrentActivity.isHidden = false
                    self.addedActivitiesText.isHidden = false
                }
            }
            self.showAllElements()
        })
    }
    
    func showAllElements()
    {
        UIView.animate(withDuration: 1)
        {
            self.gradientLayer = CAGradientLayer()
            self.gradientLayer.frame = self.viewWithContentOfActivity.bounds
            let grayTopColor = UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1)
            let whiteDownColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            self.gradientLayer.colors = [grayTopColor.cgColor, whiteDownColor.cgColor]
            self.viewWithContentOfActivity.layer.insertSublayer(self.gradientLayer, at: 0)
            self.viewWithContentOfActivity.setShadowWithCornerRadius(corners: 0)
            self.viewWithContentOfActivity.layer.opacity = 1
            self.viewWithContentOfActivity.layer.shadowOpacity = 0.25
            
            self.lookAtAllMembersButton.alpha = 1
            self.imageOfCurrentActivity.alpha = 1
            self.numberOfMembers.alpha = 1
            self.activeOrNotText.alpha = 1
            self.nameOfCurrentActivity.alpha = 1
            self.addedActivitiesText.alpha = 1
        }
    }
    
    @IBAction func lookAllMembersOfActivityButtonPressed(_ sender: UIButton)
    {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "joinedMembers") as! JoinedMembersViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
