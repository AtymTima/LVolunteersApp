//
//  SettingsViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 09.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

var stateOfChanges = 0

class SettingsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var descriptionOfTheUser: UITextView!
    @IBOutlet weak var usernameOfTheUser: UITextField!
    @IBOutlet weak var nameOfTheUser: UITextField!
    @IBOutlet weak var surnameOfTheUser: UITextField!
    @IBOutlet weak var phoneOfTheUser: UITextField!
    @IBOutlet weak var emailOfTheUser: UITextField!
    @IBOutlet weak var roleOfTheUser: UILabel!
    @IBOutlet weak var topBackgroundColor: UIView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var gradientLayer: CAGradientLayer!
    var profileInstance = ProfileViewController()
    var isKeyboardAppear = false
    var isTextEditable = false
    var avaOfPosts = [PFFile]()
    
    @IBAction func changePhotoButtonTapped(_ sender: UIButton)
    {
        addImage()
    }
    @IBAction func submitChangesButtonTapped(_ sender: Any)
    {
        if !validateEmail(emailOfTheUser.text!) {
            showAlertMessge(title: "Ошибочные данные", message: "Введите корректный email адрес", answer: "OK")
            return
        }

        let user = PFUser.current()!
        user.username = usernameOfTheUser.text
        user.email = emailOfTheUser.text
        user["name"] = nameOfTheUser.text
        user["surname"] = surnameOfTheUser.text
        user["bio"] = descriptionOfTheUser.text
        
        let postQuery = PFQuery(className: "Posts")
        postQuery.whereKey("username", equalTo: user.username!)
        postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for obj in objects!
                {
                    obj["ava"] = PFUser.current()!.value(forKey: "ava") as! PFFile
                    obj.saveInBackground(block: { (success, error) -> Void in
                        if error == nil
                        {
                            print("OK")
                        }
                    })
                }
            }
        })
        
        if phoneOfTheUser.text!.isEmpty {
            user["phone"] = ""
        } else {
            user["phone"] = phoneOfTheUser.text
        }

        let avaData = UIImageJPEGRepresentation(avaOfTheUser.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        

        user.saveInBackground (block: { (success, error) -> Void in
            if success{
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
                stateOfChanges = 1
            } else {
                self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
            }
        })
        
    }
    
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        showInformation()
        swipeBack()
        
        self.avaOfTheUser.alpha = 0
        self.descriptionOfTheUser.alpha = 0
        self.changePhotoButton.alpha = 0
        
        avaOfTheUser.layer.cornerRadius = avaOfTheUser.frame.size.width / 2
        avaOfTheUser.layer.masksToBounds = true
        choosePhotoAfterTapping()
       
        self.scrollView.alwaysBounceVertical = true
        descriptionOfTheUser.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1)
        {
            let blueDownColor = UIColor(red: 228/255.0, green: 241/255.0, blue: 247/255.0, alpha: 1)
            let whiteTopColor = UIColor(red: 253/255.0, green: 252/255.0, blue: 255/255.0, alpha: 1)
            
            self.gradientLayer = CAGradientLayer()
            self.gradientLayer.frame = self.topBackgroundColor.bounds
            self.gradientLayer.colors = [whiteTopColor.cgColor, blueDownColor.cgColor]
            self.topBackgroundColor.layer.insertSublayer(self.gradientLayer, at: 0)
            
            self.avaOfTheUser.alpha = 1
            self.descriptionOfTheUser.alpha = 1
            self.changePhotoButton.alpha = 1
        }
    }
    
    func showInformation()
    {
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFile
        ava.getDataInBackground { (data, error) -> Void in
            self.avaOfTheUser.image = UIImage(data: data!)
        }
        usernameOfTheUser.text = PFUser.current()?.username
        nameOfTheUser.text = PFUser.current()?.object(forKey: "name") as? String
        surnameOfTheUser.text = PFUser.current()?.object(forKey: "surname") as? String
        if PFUser.current()?.object(forKey: "bio") as? String == nil
        {
            descriptionOfTheUser.text = ""
        }
        else
        {
            descriptionOfTheUser.text = PFUser.current()?.object(forKey: "bio") as? String
        }
        
        
        emailOfTheUser.text = PFUser.current()?.email
        phoneOfTheUser.text = PFUser.current()?.object(forKey: "phone") as? String
        let role = PFUser.current()?.object(forKey: "role") as? String
        if role == "member"
        {
            roleOfTheUser.text = "Участник Лиги Волонтеров"
        }
        else if role == "coordinator"
        {
            roleOfTheUser.text = "Координатор"
        }
        else if role == "admin"
        {
            roleOfTheUser.text = "Админ"
            roleOfTheUser.textColor = .red
        }
    }
    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        isTextEditable = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        isTextEditable = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if (usernameOfTheUser.isEditing == false) && isTextEditable == false
        {
            if !isKeyboardAppear
            {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()}}
