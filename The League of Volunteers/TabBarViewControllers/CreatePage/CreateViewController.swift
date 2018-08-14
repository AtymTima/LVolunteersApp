//
//  CreateViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 23.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class CreateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var photoOfTheActivity: UIImageView!
    @IBOutlet weak var nameOfActivity: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var dateAndTimeButton: UITextField!
    @IBOutlet weak var descriptionOfActivity: UITextView!
    @IBOutlet weak var dateAndTimeBorderView: UIView!
    
    var isFinished = true
    
    @IBAction func createButtonPressed(_ sender: UIButton)
    {
        if (dateAndTimeButton.text == "Дата/время") || (dateAndTimeButton.text == "") || (locationButton.titleLabel?.text == "Локация") || (rewardButton.titleLabel?.text == "Награда") || (nameOfActivity.text == "Название мероприятия") || (nameOfActivity.text == "") || (descriptionOfActivity.text == "Описание мероприятия") || (descriptionOfActivity.text == "")
        {
            showAlertAfterCreateButtonTapped(title: "Пустые поля", message: "Заполните все поля для создания нового дела")
        }
        else
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
                            self.showAlertMessge(title: "Ошибка", message: "У вас уже имеется одно активное дело. \n Завершите его для создания нового", answer: "OK")
                            self.isFinished = false
                        }
                        if self.isFinished == true
                        {
                            self.askAmountOfMemberAlert(title: "Количество участников", subtitle: "Введите количество участников для мероприятия. \n \n Оставьте поле пустым если количество неограниченно", actionTitle: "Добавить", inputPlaceholder: "Пример: 50", inputKeyboardType: .numberPad, actionHandler: nil)
                        }
                    }
                }
            })
            
        }
    }
    
    func createPost(answer: Int)
    {
        self.view.endEditing(true)
        self.showAlertAfterCreateButtonTapped(title: "Дело создано", message: "Поздравляем с успешным созданием нового дела!")
        
        let object = PFObject(className: "Posts")
        object["username"] = PFUser.current()?.username
        object["ava"] = PFUser.current()!.value(forKey: "ava") as! PFFile
        let uuid = UUID().uuidString
        object["uuid"] = "\(PFUser.current()!.username!) \(uuid)"
        object["title"] = self.descriptionOfActivity.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let imageData = UIImageJPEGRepresentation(self.photoOfTheActivity.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["picture"] = imageFile
        object["reward"] = self.rewardButton.currentTitle
        object["location"] = self.locationButton.currentTitle
        object["name"] = self.nameOfActivity.text
        object["dateAndTime"] = self.dateAndTimeButton.text
        if answer != 0
        {
            object["amount"] = answer
        }
        else
        {
            object["amount"] = 10000
        }
        object["isFinished"] = "false"
        
        self.dateAndTimeButton.text = "Дата/время"
        self.locationButton.setTitle("Локация", for: .normal)
        self.rewardButton.setTitle("Награда", for: .normal)
        self.nameOfActivity.text = ""
        self.descriptionOfActivity.text = "Описание мероприятия"
        self.descriptionOfActivity.textColor = .lightGray
        self.photoOfTheActivity.image = UIImage(named: "nightSky.png")
        
        object.saveInBackground (block: { (success, error) -> Void in
            if error == nil
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "uploaded"), object: nil)
                self.tabBarController?.selectedIndex = 1
            }
        })
    }
    
    func askAmountOfMemberAlert(title:String? = nil,
                        subtitle:String? = nil,
                        actionTitle:String? = "Добавить",
                        inputPlaceholder:String? = nil,
                        inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                        actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
            let answer = Int(alert.textFields![0].text!)
            if answer != nil
            {
                self.createPost(answer: answer!)
            }
            else
            {
                self.createPost(answer: 0)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAfterCreateButtonTapped(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    var isKeyboardAppear = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        changeFontOfNavBar()
        addPhotoButton.layer.borderWidth = 1
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.cornerRadius = 10
        
        hideKeyboardWhenTappedAround()
        makeBlueView(TF: dateAndTimeBorderView)
        dateAndTimeButton.textColor = UIColor(hue: 0.583, saturation: 0.722, brightness: 0.875, alpha: 1)
        makeBlueButton(button: locationButton)
        makeBlueButton(button: rewardButton)

        descriptionOfActivity.textColor = .lightGray
        descriptionOfActivity.text = "Описание мероприятия"
        
        self.descriptionOfActivity.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.month = +6
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.month = 0
        components.day = -0
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        
        
            let datePickerView = UIDatePicker()
            
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            datePickerView.addTarget(self, action: #selector(CreateViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
            
            dateAndTimeButton.inputView = datePickerView
            datePickerView.minimumDate = minDate
            datePickerView.maximumDate = maxDate
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dateAndTimeButton.text = formatter.string(from: sender.date)
    }
    
    @IBAction func dateAndTimeEditingBegin(_ sender: UITextField)
    {
        dateAndTimeButton.clearsOnInsertion = true
        nameOfActivity.isEnabled = false
        descriptionOfActivity.isUserInteractionEnabled = false
    }
    @IBAction func locationButtonPressed(_ sender: Any)
    {
        showInputAlert(title: "Локация", subtitle: "Выберите месторасположение", actionTitle: "Добавить", cancelTitle: "Отменить", inputPlaceholder: "Место встречи", inputKeyboardType: .default, cancelHandler: nil, actionHandler: nil, buttonField: locationButton)
        nameOfActivity.isEnabled = false
        descriptionOfActivity.isUserInteractionEnabled = false
    }
    @IBAction func rewardButtonPressed(_ sender: Any)
    {
        showInputAlert(title: "Награда", subtitle: "Выберите вознаграждение", actionTitle: "Добавить", cancelTitle: "Отменить", inputPlaceholder: "Пример: рекомендательное письмо", inputKeyboardType: .default, cancelHandler: nil, actionHandler: nil, buttonField: rewardButton)
        nameOfActivity.isEnabled = false
        descriptionOfActivity.isUserInteractionEnabled = false
    }
    @IBAction func nameOfActivityEditingBegin(_ sender: UITextField)
    {
        dateAndTimeButton.isEnabled = false
        locationButton.isEnabled = false
        rewardButton.isEnabled = false
    }
    @IBAction func descriptionOfActivityEditingBegin(_ sender: UITextField)
    {
        dateAndTimeButton.isEnabled = false
        locationButton.isEnabled = false
        rewardButton.isEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        dateAndTimeButton.isEnabled = false
        locationButton.isEnabled = false
        rewardButton.isEnabled = false
        
        if descriptionOfActivity.isFirstResponder && (descriptionOfActivity.text == "" || descriptionOfActivity.text == "Описание мероприятия") {
            descriptionOfActivity.text = nil
            descriptionOfActivity.textColor = .black
            descriptionOfActivity.tintColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        dateAndTimeButton.isEnabled = true
        locationButton.isEnabled = true
        rewardButton.isEnabled = true
        
        if descriptionOfActivity.text.isEmpty || descriptionOfActivity.text == "" {
            descriptionOfActivity.textColor = .lightGray
            descriptionOfActivity.text = "Описание мероприятия"
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height - (tabBarController?.tabBar.frame.size.height)!
                }
            }
            isKeyboardAppear = true
            locationButton.isEnabled = false
            rewardButton.isEnabled = false
            createButton.isEnabled = false
            createButton.alpha = 0.5
            dateAndTimeButton.textColor = UIColor.lightGray
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if isKeyboardAppear {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height - (tabBarController?.tabBar.frame.size.height)!
                }
            }
            dateAndTimeButton.isEnabled = true
            isKeyboardAppear = false
            locationButton.isEnabled = true
            rewardButton.isEnabled = true
            createButton.isEnabled = true
            createButton.alpha = 1
            nameOfActivity.isEnabled = true
            descriptionOfActivity.isUserInteractionEnabled = true
            dateAndTimeButton.textColor = UIColor(hue: 0.583, saturation: 0.722, brightness: 0.875, alpha: 1)
        }
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: Any)
    {
        choosePhotoAfterTapping()
        addImage()
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
