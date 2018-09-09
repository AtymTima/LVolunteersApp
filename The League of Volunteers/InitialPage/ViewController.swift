//
//  ViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 20.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Foundation
import Parse

class ViewController: UIViewController
{
    @IBOutlet weak var imageLightFilter: UIImageView!
    @IBOutlet weak var imageBackgroundDynamic: UIImageView!
    @IBOutlet weak var nameOfUserField: UITextField!
    @IBOutlet weak var containerOfShadow: UIView!
    @IBOutlet weak var containerPassword: UIView!
    @IBOutlet weak var passwordOfUserField: UITextField!
    @IBOutlet weak var enterButtonPressed: UIButton!
    
    var enteredMail: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        enterButtonPressed.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.enterButtonPressed.isEnabled = true
        }
        
        nameOfUserField.backgroundColor = UIColor(hue: 0.59, saturation: 0.216, brightness: 0.96, alpha: 0.75)
        passwordOfUserField.backgroundColor = UIColor(hue: 0.59, saturation: 0.216, brightness: 0.96, alpha: 0.75)
        
        containerPassword.setShadowWithCornerRadius(corners: 16)
        containerOfShadow.setShadowWithCornerRadius(corners: 16)
        nameOfUserField.setWhiteStyleTextfield(textField: nameOfUserField, placeholder: "Имя пользователя")
        passwordOfUserField.setWhiteStyleTextfield(textField: passwordOfUserField, placeholder: "Пароль")
        
        enterButtonPressed.backgroundColor = UIColor(red: 1, green: 0.72, blue: 0.0, alpha: 1.0)
        enterButtonPressed.setShadowForButton(corners: 8)
        
        hideKeyboardWhenTappedAround()
        addParallaxToView(vw: imageBackgroundDynamic)
    }
    
    func addParallaxToView(vw: UIImageView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if nameOfUserField.text!.isEmpty && passwordOfUserField.text!.isEmpty
        {
            self.showMeAlert(title: "Ошибка входа", message: "Заполните пустые поля", okButton: "Хорошо")
        }
        else
        {
            PFUser.logInWithUsername(inBackground: nameOfUserField.text!, password: passwordOfUserField.text!) { (user, error) -> Void in
                if error == nil
                {
                    UserDefaults.standard.set(user!.username, forKey: "username")
                    UserDefaults.standard.synchronize()

                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.login()
                }
                else
                {
                    self.showMeAlert(title: "Ошибка входа", message: error!.localizedDescription, okButton: "OK")
                }
            }
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton)
    {
        resetPasswordAlert(title: "Восстановление пароля", subtitle: "Введите пароль, который указывали при регистрации", actionTitle: "Восстановление", cancelTitle: "Отменить", inputPlaceholder: "Пример: batman@gmail.com", cancelHandler: nil, actionHandler: nil)
    }
    
    func showMeAlert(title: String, message: String, okButton: String)
    {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "\(okButton)", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func resetPasswordAlert(title:String? = nil,
                        subtitle:String? = nil,
                        actionTitle:String? = "Add",
                        cancelTitle:String? = "Cancel",
                        inputPlaceholder:String? = nil,
                        inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                        actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
            let answer = alert.textFields![0]
            self.enteredMail = answer.text!
            self.checkTheEnteredMail()
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkTheEnteredMail()
    {
        if enteredMail == ""
        {
            showMeAlert(title: "Пустое поле", message: "Вы не ввели почту, попробуйте снова", okButton: "Попробовать")
        }
        else
        {
            PFUser.requestPasswordResetForEmail(inBackground: enteredMail) { (success, error) -> Void in
                if success
                {
                    self.showMeAlert(title: "Войдите в указанную почту", message: "чтобы восстановить ваш пароль", okButton: "OK")
                }
                else
                {
                    self.showMeAlert(title: "Возникла ошибка", message: error!.localizedDescription, okButton: "OK")
                }
            }
            enteredMail = ""
        }
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

