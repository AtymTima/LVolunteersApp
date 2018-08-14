//
//  ActivitiesDetailedViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 30.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

var postuuid = [String]()

class ActivitiesDetailedViewController: UIViewController {
    
    @IBAction func backButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    var imagesOfActivity = [PFFile]()
    var namesOfActivity = [String]()
    var descriptionsOfActivity = [String]()
    var dateAndTimeOfActivity = [String]()
    var rewardOfActivity = [String]()
    var locationOfActivity = [String]()
    var whenCreated = [Date?]()
    var uuidArray = [String]()
    var amount = [Int]()
    var usernameArray = [String]()
    var isButtonEnabled = true
    var ownPost = false
    var joined = false
    var finishing = [String]()
    var from = [String]()
    var counts = 0
    
    @IBOutlet weak var tableViewDetailed: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        swipeBack()
        findThePost()
        tableViewDetailed.allowsSelection = false
        self.tableViewDetailed.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: -statusBarHeight, left: 0, bottom: 0, right: 0)
        tableViewDetailed.contentInset = insets
        tableViewDetailed.scrollIndicatorInsets = insets
    }

    func findThePost()
    {
        let postQuery = PFQuery(className: "Posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                self.imagesOfActivity.removeAll(keepingCapacity: false)
                self.namesOfActivity.removeAll(keepingCapacity: false)
                self.descriptionsOfActivity.removeAll(keepingCapacity: false)
                self.dateAndTimeOfActivity.removeAll(keepingCapacity: false)
                self.rewardOfActivity.removeAll(keepingCapacity: false)
                self.locationOfActivity.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.amount.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.imagesOfActivity.append(object.value(forKey: "picture") as! PFFile)
                    self.namesOfActivity.append(object.value(forKey: "name") as! String)
                    self.descriptionsOfActivity.append(object.value(forKey: "title") as! String)
                    self.dateAndTimeOfActivity.append(object.value(forKey: "dateAndTime") as! String)
                    self.rewardOfActivity.append(object.value(forKey: "reward") as! String)
                    self.locationOfActivity.append(object.value(forKey: "location") as! String)
                    self.whenCreated.append(object.createdAt)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.amount.append(object.value(forKey: "amount") as! Int)
                    
                    if object.value(forKey: "username") as? String == (PFUser.current()?.object(forKey: "username") as? String)
                    {
                        self.isButtonEnabled = false
                        self.ownPost = true
                    }
                    
                    if object.value(forKey: "isFinished") as? String == "true"
                    {
                        self.isButtonEnabled = false
                        self.ownPost = false
                    }
                }
            }
            self.tableViewDetailed.reloadData()
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    @IBAction func joinToActivityButtonPressed(_ sender: UIButton)
    {
        let query = PFQuery(className: "Members")
        query.whereKey("from", equalTo: PFUser.current()!.username!)
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    if object.value(forKey: "from") as! String == PFUser.current()!.username! && object.value(forKey: "to") as! String == self.usernameArray.last! && object.value(forKey: "alreadyJoined") as! String == "true" && object.value(forKey: "isFinished") as! String == "false"
                    {
                        self.isButtonEnabled = true
                        self.joined = true
                        self.tableViewDetailed.reloadData()
                        self.showAlertMessge(title: "Вы уже участвуете", message: "в данном мероприятии", answer: "OK")
                    }
                }
            }
            self.checkIfNotJoined()
        })
    }
    
    func checkIfNotJoined()
    {
        var number = 0
        let query = PFQuery(className: "Members")
        query.whereKey("to", equalTo: self.usernameArray.last!)
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for obj in objects!
                {
                    if obj.value(forKey: "isFinished") as! String == "false"
                    {
                        number += 1
                    }
                }
                if number < self.amount.last!
                {
                    if self.joined == false
                    {
                        let object = PFObject(className: "Members")
                        object["from"] = PFUser.current()?.username
                        object["to"] = self.usernameArray.last!
                        object["uuid"] = self.uuidArray.last!
                        object["isFinished"] = "false"
                        object["alreadyJoined"] = "true"
                        print("success")
                        self.isButtonEnabled = false
                        
                        if self.joined == false
                        {
                            object.saveInBackground(block: { (success, error) -> Void in
                                if success
                                {
                                    print("more success")
                                    let newsObj = PFObject(className: "News")
                                    newsObj["by"] = PFUser.current()?.username
                                    newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                                    newsObj["to"] = self.usernameArray.last!
                                    newsObj["owner"] = ""
                                    newsObj["uuid"] = postuuid.last!
                                    newsObj["type"] = "joined"
                                    newsObj["checked"] = "no"
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "joined"), object: nil)
                                    
                                    self.showAlertAndDismiss(title: "Успешное присоединение", subtitle: "Вы стали участниками данного мероприятия, увидимся на проекте!", actionTitle: "OK", actionHandler: nil)
                                    
                                    newsObj.saveEventually()
                                }
                                else
                                {
                                    self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
                                }
                            })
                        }
                        
                    }
                }
                else
                {
                    self.showAlertMessge(title: "Лимит превышен", message: "Нужное количество людей уже участвует в проекте", answer: "OK")
                }
                
            }
        })
        
    }
    func showAlertAndDismiss(title:String? = nil,
                        subtitle:String? = nil,
                        actionTitle:String? = "Add",
                        actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
