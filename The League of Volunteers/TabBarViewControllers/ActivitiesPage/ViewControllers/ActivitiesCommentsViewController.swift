//
//  ActivitiesCommentsViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 01.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

var commentuuid = [String]()
var commentowner = [String]()

class ActivitiesCommentsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var viewWithContentComments: UIView!
    @IBOutlet weak var imageOfCurrentActivity: UIImageView!
    @IBOutlet weak var nameOfCurrentActivity: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var tableViewWithComments: UITableView!
    @IBOutlet weak var addCommentTextField: UITextView!
    @IBOutlet weak var sendButtonPressed: UIButton!
    
    var usernames = [String]()
    var ava = [PFFile]()
    var comments = [String]()
    var whenCreated = [Date?]()
    
    var pictureOfImage = [PFFile]()
    var nameOfActivity = [String]()
    
    var page: Int32 = 10
    
    var gradientLayer: CAGradientLayer!
    var refresher = UIRefreshControl()
    var isKeyboardAppear = false
    
    var tableViewHeight : CGFloat = 0
    var commentY : CGFloat = 0
    var commentHeight : CGFloat = 0
    var keyboard = CGRect()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        behindView.backgroundColor = UIColor(red: 43/255.0, green: 49/255.0, blue: 83/255.0, alpha: 1)
        viewWithContentComments.backgroundColor = .none
        imageOfCurrentActivity.alpha = 0
        nameOfCurrentActivity.alpha = 0
        numberOfComments.alpha = 0
        sendButtonPressed.isEnabled = false
        
        avaOfTheUser.layer.cornerRadius = avaOfTheUser.frame.size.width / 2
        avaOfTheUser.layer.masksToBounds = true
        
        addCommentTextField.layer.borderWidth = 1
        addCommentTextField.layer.borderColor = UIColor.lightGray.cgColor
        addCommentTextField.layer.cornerRadius = 16
        addCommentTextField.layer.masksToBounds = true
        
        addCommentTextField.textColor = .lightGray
        addCommentTextField.text = "Ваш комментарий..."
        self.addCommentTextField.delegate = self
        
        var topCorrect = (addCommentTextField.bounds.size.height - addCommentTextField.contentSize.height * addCommentTextField.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        addCommentTextField.contentInset.top = topCorrect
        
        hideKeyboardWhenTappedAround()
        
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
        
        loadComments()
        
        self.tableViewWithComments.separatorStyle = .none
        
        let postQuery = PFQuery(className: "Posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                self.nameOfActivity.removeAll(keepingCapacity: false)
                self.pictureOfImage.removeAll(keepingCapacity: false)
                
                for object in objects!
                {
                    self.nameOfActivity.append(object.value(forKey: "name") as! String)
                    self.pictureOfImage.append(object.value(forKey: "picture") as! PFFile)
                }
                
                self.nameOfCurrentActivity.text = self.nameOfActivity[0]
                self.pictureOfImage[0].getDataInBackground { (data, error) -> Void in
                    if error == nil
                    {
                        self.imageOfCurrentActivity.image = UIImage(data: data!)
                    }
                }
            }
        })
        
    }
    
    @objc func back(_ sender : UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
        if !guestName.isEmpty {
            guestName.removeLast()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let grayTopColor = UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1)
        let whiteDownColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
        UIView.animate(withDuration: 1)
        {
            self.gradientLayer = CAGradientLayer()
            self.gradientLayer.frame = self.viewWithContentComments.bounds
            self.gradientLayer.colors = [grayTopColor.cgColor, whiteDownColor.cgColor]
            self.viewWithContentComments.layer.insertSublayer(self.gradientLayer, at: 0)
            self.viewWithContentComments.setShadowWithCornerRadius(corners: 0)
            self.viewWithContentComments.layer.opacity = 1
            self.viewWithContentComments.layer.shadowOpacity = 0.25
            
            self.imageOfCurrentActivity.layer.cornerRadius = 8
            self.imageOfCurrentActivity.layer.masksToBounds = true
            self.imageOfCurrentActivity.alpha = 1
            self.nameOfCurrentActivity.alpha = 1
            self.numberOfComments.alpha = 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !addCommentTextField.text.trimmingCharacters(in: spacing).isEmpty {
            sendButtonPressed.isEnabled = true
        } else {
            sendButtonPressed.isEnabled = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if addCommentTextField.isFirstResponder && (addCommentTextField.text == "" || addCommentTextField.text == "Ваш комментарий...")
        {
            addCommentTextField.text = nil
            addCommentTextField.textColor = .black
            addCommentTextField.tintColor = .black
            sendButtonPressed.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if addCommentTextField.text.isEmpty || addCommentTextField.text == ""
        {
            addCommentTextField.textColor = .lightGray
            addCommentTextField.text = "Ваш комментарий..."
            sendButtonPressed.isEnabled = false
        }
        else
        {
            sendButtonPressed.isEnabled = true
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if !isKeyboardAppear
        {
            keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                if self.view.frame.origin.y == 0
                {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
            isKeyboardAppear = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if isKeyboardAppear
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0
                {
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
            isKeyboardAppear = false
        }
    }
    
    func changeStyleOfNumberOfComments()
    {
        let numberOfCommentaries = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.blue]
        let correctCommentText = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.black]
        let numberString = NSMutableAttributedString(string:"\(usernames.count)", attributes:numberOfCommentaries)
        var correctPhrase = ""
        if usernames.count == 1
        {
            correctPhrase = "комментарий"
        }
        else if usernames.count == 2 || usernames.count == 3 || usernames.count == 4
        {
            correctPhrase = "комментария"
        }
        else
        {
            correctPhrase = "комментариев"
        }
        let commentsString = NSMutableAttributedString(string:" \(correctPhrase)", attributes:correctCommentText)
        
        numberString.append(commentsString)
        numberOfComments.attributedText = numberString
    }
    
    func loadComments()
    {
        let countQuery = PFQuery(className: "Comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        countQuery.countObjectsInBackground (block: { (count, error) -> Void in
            if self.page < count {
                self.refresher.addTarget(self, action: #selector(self.loadMoreComments), for: UIControlEvents.valueChanged)
                self.tableViewWithComments.addSubview(self.refresher)
            }
            let query = PFQuery(className: "Comments")
            query.whereKey("to", equalTo: commentuuid.last!)
            
            query.addAscendingOrder("createdAt")
            query.findObjectsInBackground (block: { (objects, error) -> Void in
                if error == nil {
                    self.usernames.removeAll(keepingCapacity: false)
                    self.ava.removeAll(keepingCapacity: false)
                    self.comments.removeAll(keepingCapacity: false)
                    self.whenCreated.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        self.usernames.append(object.object(forKey: "username") as! String)
                        self.ava.append(object.object(forKey: "ava") as! PFFile)
                        self.comments.append(object.object(forKey: "comment") as! String)
                        self.whenCreated.append(object.createdAt)
                        self.tableViewWithComments.reloadData()

                        self.tableViewWithComments.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                        self.changeStyleOfNumberOfComments()
                    }
                }
                else
                {
                    self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
                }
            })
        })
    }
    
    @objc func loadMoreComments()
    {
        let countQuery = PFQuery(className: "Comments")
        countQuery.whereKey("to", equalTo: commentuuid.last!)
        countQuery.countObjectsInBackground (block: { (count, error) -> Void in
            self.refresher.endRefreshing()
            if self.page >= count {
                self.refresher.removeFromSuperview()
            }
            if self.page < count {
                self.page = self.page + 10
                
                let query = PFQuery(className: "Comments")
                query.whereKey("to", equalTo: commentuuid.last!)
                query.skip = count.distance(to: self.page)
                query.addAscendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects, erro) -> Void in
                    if error == nil {
                        self.usernames.removeAll(keepingCapacity: false)
                        self.ava.removeAll(keepingCapacity: false)
                        self.comments.removeAll(keepingCapacity: false)
                        self.whenCreated.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            self.usernames.append(object.object(forKey: "username") as! String)
                            self.ava.append(object.object(forKey: "ava") as! PFFile)
                            self.comments.append(object.object(forKey: "comment") as! String)
                            self.whenCreated.append(object.createdAt)
                            self.tableViewWithComments.reloadData()
                            
                            self.tableViewWithComments.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                        }
                    }
                    else
                    {
                        self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
                    }
                })
            }
        })
    }
    
    @IBAction func sendButtonPressed(_ sender: Any)
    {
        usernames.append(PFUser.current()!.username!)
        ava.append(PFUser.current()?.object(forKey: "ava") as! PFFile)
        whenCreated.append(Date())
        comments.append(addCommentTextField.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        tableViewWithComments.reloadData()
        
        let commentObject = PFObject(className: "Comments")
        commentObject["to"] = commentuuid.last
        commentObject["username"] = PFUser.current()?.username
        commentObject["ava"] = PFUser.current()?.value(forKey: "ava")
        commentObject["comment"] = addCommentTextField.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        commentObject.saveEventually()
        
        if commentowner.last != PFUser.current()?.username {
            let newsObj = PFObject(className: "News")
            newsObj["by"] = PFUser.current()?.username
            newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
            newsObj["to"] = commentowner.last
            newsObj["owner"] = commentowner.last
            newsObj["uuid"] = commentuuid.last
            newsObj["type"] = "comment"
            newsObj["checked"] = "no"
            newsObj.saveEventually()
        }
        
        self.tableViewWithComments.scrollToRow(at: IndexPath(item: comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        addCommentTextField.text = "Ваш комментарий..."
        addCommentTextField.textColor = .lightGray
        sendButtonPressed.isEnabled = false
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
