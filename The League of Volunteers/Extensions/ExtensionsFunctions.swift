//
//  ExtensionsFunctions.swift
//  The League of Volunteers
//
//  Created by  Тима on 20.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func setShadowWithCornerRadius(corners : CGFloat)
    {
        self.layer.cornerRadius = corners
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        self.layer.shadowOpacity = 1
        
        
        self.layer.opacity = 0.25
    }
}

extension UIButton
{
    func setShadowForButton(corners : CGFloat)
    {
        self.layer.cornerRadius = corners
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        self.layer.shadowOpacity = 0.25
        
    }
}

extension UIImageView
{
    func setShadowForImage(corners: CGFloat)
    {
        self.layer.cornerRadius = corners
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        self.layer.shadowOpacity = 0.25
        
    }
}

extension UITextField
{
    func setWhiteStyleTextfield(textField: UITextField, placeholder: String)
    {
        textField.layer.borderColor = UIColor.white.cgColor
        textField.tintColor = UIColor.white
        textField.textColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
}

extension UIViewController
{
    func makeGreenButtons(button: UIButton)
    {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hue: 0.451, saturation: 0.408, brightness: 0.757, alpha: 0.6).cgColor
        button.tintColor = UIColor(hue: 0.451, saturation: 0.408, brightness: 0.757, alpha: 1)
    }
    func makeOrangeButton(button: UIButton)
    {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hue: 0.997, saturation: 0.616, brightness: 0.643, alpha: 0.7).cgColor
        button.tintColor = UIColor(hue: 0.997, saturation: 0.616, brightness: 0.643, alpha: 1)
    }
    func makeBlueButton(button: UIButton)
    {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hue: 0.583, saturation: 0.722, brightness: 0.875, alpha: 1).cgColor
        button.tintColor = UIColor(hue: 0.583, saturation: 0.722, brightness: 0.875, alpha: 1)
    }
    func makeBlueView(TF: UIView)
    {
        TF.layer.borderWidth = 2
        TF.layer.borderColor = UIColor(hue: 0.583, saturation: 0.722, brightness: 0.875, alpha: 1).cgColor
        TF.tintColor = UIColor(hue: 0.583, saturation: 0.722, brightness: 0.875, alpha: 1)
    }
    func changeFontOfNavBar()
    {
        self.navigationController?.navigationBar.titleTextAttributes = [ kCTFontAttributeName: UIFont(name: "Didot", size: 20)!] as [NSAttributedStringKey : Any]
    }
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showInputAlert(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil, buttonField: UIButton?) {
        
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
            let answer = alert.textFields![0]
            buttonField?.setTitle(answer.text, for: .normal)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessge(title: String, message: String, answer: String)
    {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "\(answer)", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeToogle(textView: UITextView, tableView: UITableView)
    {
        if textView.isHidden
        {
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        else
        {
            tableView.estimatedRowHeight = 40
        }
    }
    
    func swipeBack()
    {
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.returnBack))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
    }
    
    @objc func returnBack()
    {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
        
        if !postuuid.isEmpty
        {
            postuuid.removeLast()
        }
        if !commentuuid.isEmpty
        {
            commentuuid.removeLast()
        }
        if !commentowner.isEmpty
        {
            commentowner.removeLast()
        }
        if !guestName.isEmpty
        {
            guestName.removeLast()
        }
    }
    
}

extension MainNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainMenuCell", for: indexPath) as! MainMenuCollectionViewCell
        if indexOfPage == 0
        {
            cell.titleOfPage.text = "О лиге"
            cell.imageOfPage.image =  #imageLiteral(resourceName: "orangeCrystalBackground")
            cell.descriptionOfPage.text = "Кто мы и что делаем"
        }
        else if indexOfPage == 1
        {
            cell.titleOfPage.text = "Контакты"
            cell.imageOfPage.image =  #imageLiteral(resourceName: "greenCrystalBackground")
            cell.descriptionOfPage.text = "Мы в других сетях"
        }
        else if indexOfPage == 2
        {
            cell.titleOfPage.text = "Ответы"
            cell.imageOfPage.image =  #imageLiteral(resourceName: "skyCrystalBackground")
            cell.descriptionOfPage.text = "Задаваемые вопросы"
        }
        else if indexOfPage == 3
        {
            cell.titleOfPage.text = "Туториал"
            cell.imageOfPage.image =  #imageLiteral(resourceName: "blueCrystalBackground")
            cell.descriptionOfPage.text = "Гайд по приложению"
        }
        cell.imageOfPage.layer.cornerRadius = 16
        cell.imageOfPage.layer.masksToBounds = true
        cell.borderOfCell.layer.borderWidth = 0.2
        cell.borderOfCell.layer.borderColor = UIColor.lightGray.cgColor
        cell.borderOfCell.layer.cornerRadius = 16
        cell.borderOfCell.layer.masksToBounds = true
        
        cell.setShadowWithCornerRadius(corners: 16)
        cell.layer.shadowOpacity = 0.1
        
        indexOfPage += 1
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let itemSize = collectionViewFourPages.bounds.width/2 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        let itemHeight = itemSize * 1.1
        layout.itemSize = CGSize(width: itemSize, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionViewFourPages.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row == 0
        {
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "AboutLeagueViewController") as! AboutLeagueViewController
            present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 1
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contactsVC: ContactsViewController = storyboard.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
            present(contactsVC, animated: true, completion: nil)
        }
        else if indexPath.row == 2
        {
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            present(vc, animated: true, completion: nil)
        }
        else
        {
            self.showAlertMessge(title: "В разработке", message: "P.s. если не видите кнопки назад и не знаете как вернуться - свайпните вправо", answer: "OK")
        }
        
    }
    
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func choosePhotoAfterTapping()
    {
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.loadImage(_:)))
        avaTap.numberOfTapsRequired = 1
        photoOfTheActivity.isUserInteractionEnabled = true
        photoOfTheActivity.addGestureRecognizer(avaTap)
    }
    
    @objc func loadImage(_ recognizer: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        photoOfTheActivity.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func addImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func choosePhotoAfterTapping()
    {
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.loadImage(_:)))
        avaTap.numberOfTapsRequired = 1
        avaOfTheUser.isUserInteractionEnabled = true
        avaOfTheUser.addGestureRecognizer(avaTap)
    }
    
    @objc func loadImage(_ recognizer: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        avaOfTheUser.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func addImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func choosePhotoAfterTapping()
    {
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.loadImage(_:)))
        avaTap.numberOfTapsRequired = 1
        avaOfTheUser.isUserInteractionEnabled = true
        avaOfTheUser.addGestureRecognizer(avaTap)
    }
    
    @objc func loadImage(_ recognizer: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        avaOfTheUser.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func addImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAnswer", for: indexPath) as! FAQTableViewCell
        
        if indexPath.row == 0
        {
            let textOne = "Чтобы официально стать членом Лиги волонтеров, нужно получить бейджик СС (самой первой категории). \n \n Для этого необходимо сделать доброе дело (например: посетить детский дом, навестить ветерана) и выложить видео и фото отчеты в Facebook, Instagram или ВКонтакте и указать #чуточкудобрее. \n Скопировать ссылку и отправить ее координатору, после ждать приглашения на тренинг, где вы и получите свой бейджик."
            cell.answerText.text = textOne
            cell.answerbutton.setTitle("Как вступить в Лигу Волонтеров?", for: .normal)
            cell.answerbutton.tag = 0
        }
        else if indexPath.row == 1
        {
            let textOne = "Каждый участник Лиги Волонтеров оценивается по геймифицированной системе отбора, проще говоря имеет ранг. Для повышения квалификации необходимо следующее: \n \n СС - 1 доброе дело + 1 пройденный тренинг \n СВ - 2 тренинга + 1 собственное мероприятие от 10 человек + 1 участие в мероприятии Лиги \n СА - 3 тренинга + своя команда от 10 человек с СС \n \n ВС - 4 тренинга + 1 собственное дело от 50 человек + 3 участия в мероприятиях Лиги \n ВВ - 5 тренингов + команда с СВ + 3 участия в мероприятиях Лиги с командой \n ВА - 6 тренингов + команда СА \n \n АС - команда ВА + проведение городского мероприятия с 1000+ людей \n АВ - ТОП 5 волонтеров \n АА - за выдающиеся заслуги перед Лигой Волонтеров"
            cell.answerText.text = textOne
            cell.answerbutton.setTitle("Что такое СС, СВ, СА и.т.д?", for: .normal)
            cell.answerbutton.tag = 1
        }
        else if indexPath.row == 2
        {
            let textOne = "Координаторы - это своеобразные менторы новых участников ЛВ, помогающие им в продвижении и объяснении принципов организации."
            cell.answerText.text = textOne
            cell.answerbutton.setTitle("Кто такой координатор?", for: .normal)
            cell.answerbutton.tag = 2
        }
        else if indexPath.row == 3
        {
            let textOne = "ОФ 'Лига Волонтеров' был создан 4 июня 2014 года.\n \n Лига Волонтеров - это организация единомышленников, объединенных желанием помогать и делать этот мир чуточку добрее. \n Что мы для этого делаем? Принимаем участие в различных социально-значимых кампаниях: распространении необходимой информации, подготовке и проведении общественных акций, обучении и многое другое. "
            cell.answerText.text = textOne
            cell.answerbutton.setTitle("Как давно существует Лига?", for: .normal)
            cell.answerbutton.tag = 3
        }
        expandText = cell.answerText
        cell.answerbutton.addTarget(self, action: #selector(FAQViewController.changeTheHeightOfContentAnswer) , for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func changeTheHeightOfContentAnswer(button: UIButton)
    {
        shouldCellBeExpanded = !shouldCellBeExpanded
        indexOfExpendedCell = button.tag
        if shouldCellBeExpanded
        {
            print("expand")
            self.tableVIewFAQ.beginUpdates()
            self.tableVIewFAQ.endUpdates()
        }
        else
        {
            print("collapse")
            tableVIewFAQ.reloadData()
            self.tableVIewFAQ.beginUpdates()
            self.tableVIewFAQ.endUpdates()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAnswer") as! FAQTableViewCell
        
        if cell.answerText.isHidden == false
        {
            checkStateOfTexts = 1
        }
        if checkStateOfTexts == 0
        {
            cell.answerText.isHidden = true
        }
        
        if shouldCellBeExpanded && indexPath.row == indexOfExpendedCell
        {
            return UITableViewAutomaticDimension
        } else
        {
            return 40
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        tableVIewFAQ.estimatedRowHeight = 40
        tableVIewFAQ.rowHeight = 40
        tableVIewFAQ.allowsSelection = false
    }
    
}
