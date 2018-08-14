//
//  RegistrationViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 02.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {

    @IBOutlet weak var topBackgroundVIew: UIView!
    @IBOutlet weak var downBackgroundView: UIView!
    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAgainField: UITextField!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tableViewRegistrationForm: UITableView!
    var isKeyboardAppear = false
    
    let registrationInstance = registrationData()
    
    var gradientLayer: CAGradientLayer!
    var bottomGradient: CAGradientLayer!
    
    @IBAction func backButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        avaOfTheUser.layer.cornerRadius = avaOfTheUser.layer.frame.size.width / 2
        avaOfTheUser.layer.masksToBounds = true
        avaOfTheUser.image = #imageLiteral(resourceName: "noAva")
        avaOfTheUser.alpha = 0
        
        usernameField.contentVerticalAlignment  = UIControlContentVerticalAlignment.center
        usernameField.placeholderColor(UIColor.white)
        usernameField.layer.cornerRadius = 8
        usernameField.layer.masksToBounds = true
        usernameField.alpha = 0
        
        passwordField.contentVerticalAlignment  = UIControlContentVerticalAlignment.center
        passwordField.placeholderColor(UIColor.white)
        passwordField.layer.cornerRadius = 8
        passwordField.layer.masksToBounds = true
        passwordField.alpha = 0
        
        passwordAgainField.contentVerticalAlignment  = UIControlContentVerticalAlignment.center
        passwordAgainField.placeholderColor(UIColor.white)
        passwordAgainField.layer.cornerRadius = 8
        passwordAgainField.layer.masksToBounds = true
        passwordAgainField.alpha = 0
        
        changePhotoButton.alpha = 0
        tableViewRegistrationForm.separatorStyle = .none
        tableViewRegistrationForm.isScrollEnabled = false
        
        hideKeyboardWhenTappedAround()
        swipeBack()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        UIView.animate(withDuration: 1)
        {
            let blueDownColor = UIColor(red: 228/255.0, green: 241/255.0, blue: 247/255.0, alpha: 1)
            let whiteTopColor = UIColor(red: 253/255.0, green: 252/255.0, blue: 255/255.0, alpha: 1)
            
            self.gradientLayer = CAGradientLayer()
            self.gradientLayer.frame = self.topBackgroundVIew.bounds
            self.gradientLayer.colors = [whiteTopColor.cgColor, blueDownColor.cgColor]
            self.topBackgroundVIew.layer.insertSublayer(self.gradientLayer, at: 0)
            
            self.avaOfTheUser.alpha = 1
            self.passwordField.alpha = 1
            self.passwordAgainField.alpha = 1
            self.usernameField.alpha = 1
            self.changePhotoButton.alpha = 1
        }
    }
    
    @IBAction func changeThePhotoButtonPressed(_ sender: UIButton)
    {
        print("worked")
        addImage()
        choosePhotoAfterTapping()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        registrationInstance.avaOfUser = avaOfTheUser.image!
        tableViewRegistrationForm.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65)
        {
            self.validateRegistrationForm()
        }
    }
    
    func validateRegistrationForm()
    {
        if (usernameField.text!.isEmpty) || (passwordField.text!.isEmpty) || (passwordAgainField.text!.isEmpty) || (registrationInstance.name.isEmpty || registrationInstance.name == "") || (registrationInstance.surname.isEmpty || registrationInstance.surname == "") || (registrationInstance.mail.isEmpty || registrationInstance.mail == "") || (registrationInstance.phoneNumber.isEmpty || registrationInstance.phoneNumber == "")
        {
            showAlertMessge(title: "Ошибка", message: "Проверьте свои данные, возможно вы что-то упустили", answer: "Спасибо")
        }
        else
        {
            if (registrationInstance.passwordOfUser != registrationInstance.passwordAgainOfUser)
            {
                showAlertMessge(title: "Ошибка", message: "Пароль не совпадает, проверьте его снова", answer: "Все будет сделано")
            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now())
                {
                    let userLeague = PFUser()
                    userLeague.username = self.registrationInstance.usernameOfUser
                    userLeague.password = self.registrationInstance.passwordOfUser
                    userLeague["name"] = self.registrationInstance.name
                    userLeague["surname"] = self.registrationInstance.surname
                    userLeague["phone"] = self.registrationInstance.phoneNumber
                    userLeague.email = self.registrationInstance.mail
                    userLeague["role"] = "member"
                    userLeague["rank"] = "CC"
                    
                    let array = ["Я участник Лиги Волонтеров и я горжусь этим!", "Не поменяю статус пока не совершу три различных дела", "Сделаем вместе мир чуточку добрее, товарищи", "Это приложение просто отпад, спасибо создателю!", "Добро пожаловать на страницу уникального Волонтера", "Запомните меня, я стане Хокаге, это мой путь Ниндзя!", "Я собираюсь сделать вам предложение, от которого вы не сможете отказаться", "Тото, у меня такое ощущение, что мы больше не в Канзасе", "Моя мама всегда говорила: «Жизнь как коробка шоколадных конфет: никогда не знаешь, какая начинка тебе попадётся»", "Да пребудет с нами сила"]
                    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
                    
                    userLeague["bio"] = "\(array[randomIndex])"
                    let foreign = PFObject(className: "Foreign")
                    foreign["foreign"] = "0"
                    foreign["username"] = self.registrationInstance.usernameOfUser
                    foreign.saveEventually()
                    
                    let avaOfUser = UIImageJPEGRepresentation(self.registrationInstance.avaOfUser, 0.5)
                    let avaFile = PFFile(name: "ava.jpg", data: avaOfUser!)
                    userLeague["ava"] = avaFile
                    
                    userLeague.signUpInBackground { (success, error) -> Void in
                        if success
                        {
                            UserDefaults.standard.set(userLeague.username, forKey: "username")
                            UserDefaults.standard.synchronize()
                            let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.login()
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        else
                        {
                            self.showAlertMessge(title: "Ошибка", message: "Что то пошло не так \n Возможно аккаунт с данным никнеймом уже существует, попробуйте другой \n Проверьте соединение с сетью", answer: "ОК")
                        }
                    }
                }
            }
        }
    }
    

    
    @IBAction func usernameEditingDidEnd(_ sender: UITextField)
    {
        registrationInstance.usernameOfUser = usernameField.text!
    }
    @IBAction func passwordEditingDidEnd(_ sender: UITextField)
    {
        registrationInstance.passwordOfUser = passwordField.text!
    }
    @IBAction func passwordAgainEditingDidEnd(_ sender: UITextField)
    {
        registrationInstance.passwordAgainOfUser = passwordAgainField.text!
    }
    
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

extension UITextField {
    func placeholderColor(_ color: UIColor){
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMain", for: indexPath) as! RegistrationMainInfoTableViewCell
            if indexPath.row == 0
            {
                registrationInstance.name = cell.dataTextField.text!
                cell.dataName.text = "Имя"
            }
            else if indexPath.row == 1
            {
                registrationInstance.surname = cell.dataTextField.text!
                cell.dataName.text = "Фамилия"
            }
            else if indexPath.row == 2
            {
                registrationInstance.phoneNumber = cell.dataTextField.text!
                cell.dataName.text = "Телефон"
            }
            else if indexPath.row == 3
            {
                registrationInstance.mail = cell.dataTextField.text!
                cell.dataName.text = "Почта"
            }
            cell.selectionStyle = .none
            
            cell.checkStateImage.image = #imageLiteral(resourceName: "arrowLeft")
//        else if indexPath.section == 2
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellLanguage", for: indexPath) as! RegistrationLanguagesTableViewCell
//            if indexPath.row == 0
//            {
//                if cell.languageLevel.selectedSegmentIndex == 0
//                {
//                    registrationInstance.english = "Good"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 1
//                {
//                    registrationInstance.english = "Medium"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 2
//                {
//                    registrationInstance.english = "Bad"
//                }
//
//                cell.languageName.text = "English"
//                cell.languageLevel.setTitle("Good", forSegmentAt: 0)
//                cell.languageLevel.setTitle("Medium", forSegmentAt: 1)
//                cell.languageLevel.setTitle("Bad", forSegmentAt: 2)
//            }
//            else if indexPath.row == 1
//            {
//                if cell.languageLevel.selectedSegmentIndex == 0
//                {
//                    registrationInstance.russian = "Хорошо"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 0
//                {
//                    registrationInstance.russian = "Средне"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 0
//                {
//                    registrationInstance.russian = "Плохо"
//                }
//
//                cell.languageName.text = "Русский"
//                cell.languageLevel.setTitle("Хорошо", forSegmentAt: 0)
//                cell.languageLevel.setTitle("Средне", forSegmentAt: 1)
//                cell.languageLevel.setTitle("Плохо", forSegmentAt: 2)
//            }
//            else if indexPath.row == 2
//            {
//                if cell.languageLevel.selectedSegmentIndex == 0
//                {
//                    registrationInstance.kazakh = "Тамаша"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 1
//                {
//                    registrationInstance.kazakh = "Орта"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 2
//                {
//                    registrationInstance.kazakh = "Жаман"
//                }
//
//                cell.languageName.text = "Казахский"
//                cell.languageLevel.setTitle("Тамаша", forSegmentAt: 0)
//                cell.languageLevel.setTitle("Орта", forSegmentAt: 1)
//                cell.languageLevel.setTitle("Жаман", forSegmentAt: 2)
//            }
//            else if indexPath.row == 3
//            {
//                if cell.languageLevel.selectedSegmentIndex == 0
//                {
//                    registrationInstance.currentStatus = "Школа"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 1
//                {
//                    registrationInstance.currentStatus = "Студент"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 2
//                {
//                    registrationInstance.currentStatus = "Работа"
//                }
//                else if cell.languageLevel.selectedSegmentIndex == 3
//                {
//                    registrationInstance.currentStatus = "Другое"
//                }
//
//                cell.languageName.text = "Занятие"
//                if cell.languageLevel.numberOfSegments == 3
//                {
//                    cell.languageLevel.insertSegment(withTitle: "Другое", at: 3, animated: true)
//                }
//                cell.languageLevel.setTitle("Школа", forSegmentAt: 0)
//                cell.languageLevel.setTitle("Студент", forSegmentAt: 1)
//                cell.languageLevel.setTitle("Работа", forSegmentAt: 2)
//            }
//            cell.selectionStyle = .none
//            return cell
//        } else
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellPreMedium", for: indexPath) as! RegistrationPreMediumTableViewCell
//            cell.selectionStyle = .none
//            return cell
//        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if (usernameField.isEditing == false) && (passwordField.isEditing == false) && (passwordAgainField.isEditing == false)
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
}
