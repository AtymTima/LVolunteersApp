//
//  ContactsViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 24.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {


    @IBOutlet weak var firstImageView: UIView!
    @IBOutlet weak var secondImageView: UIView!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var descriptionOfButtonText: UILabel!
    @IBOutlet weak var buttonTextView: UIView!
    @IBOutlet weak var iconOfAction: UIImageView!
    
    var whichButtonIsPressed = 1
    
    @IBOutlet weak var allThreeButtons: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeGreenButtons(button: contactButton)
        makeGreenButtons(button: websiteButton)
        makeGreenButtons(button: mailButton)
        
        descriptionOfButtonText.textColor = UIColor(hue: 0.451, saturation: 0.408, brightness: 0.757, alpha: 1)
        buttonTextView.layer.borderWidth = 2
        buttonTextView.layer.borderColor = UIColor(hue: 0.451, saturation: 0.408, brightness: 0.757, alpha: 0.6).cgColor
        buttonTextView.setShadowWithCornerRadius(corners: 16)
        buttonTextView.layer.shadowOpacity = 0.15
        buttonTextView.layer.opacity = 1
        
        contactsButtonPressed((Any).self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        buttonTextView.addGestureRecognizer(tap)
        
        swipeBack()
        
//        buttonTextView.layer.shadowOffset = CGSize(width: 0.0, height: 20.0)
    }
    
    @IBAction func techHelperImageTappedButton(_ sender: Any)
    {
        UIApplication.shared.open(URL(string: "https://vk.com/atym_tyma")! as URL, options: [:], completionHandler: nil)
    }
    @IBAction func mailButtonPressed(_ sender: Any)
    {
        iconOfAction.image = #imageLiteral(resourceName: "InstagramSquare")
        descriptionOfButtonText.text = "Instagram"
        contactButton.isEnabled = true
        websiteButton.isEnabled = true
        mailButton.isEnabled = false
        whichButtonIsPressed = 3
    }
    @IBAction func websiteButtonPressed(_ sender: Any)
    {
        iconOfAction.image = #imageLiteral(resourceName: "websiteICon")
        descriptionOfButtonText.text = "http://vlige.kz"
        contactButton.isEnabled = true
        websiteButton.isEnabled = false
        mailButton.isEnabled = true
        whichButtonIsPressed = 2
    }
    @IBAction func contactsButtonPressed(_ sender: Any)
    {
        iconOfAction.image = #imageLiteral(resourceName: "vkIcon")
        descriptionOfButtonText.text = "VKontakte"
        contactButton.isEnabled = false
        websiteButton.isEnabled = true
        mailButton.isEnabled = true
        whichButtonIsPressed = 1
    }
    
    func makeAnActionAfterTapping()
    {
        switch whichButtonIsPressed {
        case 1:
            UIApplication.shared.open(URL(string: "https://vk.com/league_volunteers")! as URL, options: [:], completionHandler: nil)
        case 2:
            UIApplication.shared.open(URL(string: "http://vlige.kz")! as URL, options: [:], completionHandler: nil)
        case 3:
            UIApplication.shared.open(URL(string: "https://www.instagram.com/league_volunteers/?hl=ru")! as URL, options: [:], completionHandler: nil)
        default:
            print("Что то пошло не так...")
        }
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        makeAnActionAfterTapping()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
