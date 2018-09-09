//
//  GuideFirstViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 15.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class GuideFirstViewController: UIViewController {
    
    @IBOutlet weak var imageCorner: UIImageView!
    @IBOutlet weak var guideText: UILabel!
    
    var page = 0
    var checkSwipe = false
    var isUserEnteredTheFirstTime = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageCorner.layer.borderWidth = 5
        imageCorner.layer.borderColor = UIColor.black.cgColor
        self.view.backgroundColor = UIColor(red: 185/255.0, green: 91/255.0, blue: 91/255.0, alpha: 1)
        
        self.guideText.text = "В первой вкладке вы можете: \n 1) Найти все последние новости касательно Лиги Волонтеров \n 2) Найти нужные контакты для связи с Лигой \n 3) Ответы на все часто задаваемые вопросы"
    }
    
    @IBAction func nextButtonTapped(_ sender: Any)
    {
        if page == 0
        {
            if checkSwipe == false
            {
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "GuideSecondViewController") as! GuideSecondViewController
                present(vc, animated: true, completion: nil)
                checkSwipe = true
                makeFadetransition(image: #imageLiteral(resourceName: "guideMain"), text: "Неплохо! Продолжаем обучение")
            }
            else
            {
                page = 1
                makeFadetransition(image: #imageLiteral(resourceName: "guideTape"), text: "Во второй вкладке вы можете пролистать ленту всех самых последних мероприятий и узнать всю нужную информацию \n Иконка яблока - детальная информация, вторая красная иконка - комментарии")
            }
        }
        else if page == 1
        {
            page = 2
            makeFadetransition(image: #imageLiteral(resourceName: "guideDetailed"), text: "Нажав на яблоко, вы можете просмотреть всю детальную информацию (описание, время, место) о мероприятии и присоединиться при возможности и желании")
        }
        else if page == 2
        {
            page = 3
            makeFadetransition(image: #imageLiteral(resourceName: "GuideComments"), text: "Если у вас остались вопросы, вы можете задать их в комментариях под данным делом и ждать ответа")
        }
        else if page == 3
        {
            page = 4
            makeFadetransition(image: #imageLiteral(resourceName: "guideCreate"), text: "В третьей вкладке вы можете создавать собственные проекты \n \n (Перед созданием, внимательно ознакомьтесь с правилами создания постов)")
        }
        else if page == 4
        {
            page = 5
            makeFadetransition(image: #imageLiteral(resourceName: "guideNotifications"), text: "В четвертой вкладке вам будут приходить уведомления о комментариях или присоединении нового Волонтера к вашему мероприятию")
        }
        else if page == 5
        {
            page = 6
            makeFadetransition(image: #imageLiteral(resourceName: "guideProfile"), text: "В пятой вкладке вы можете просмотреть всю нужную информацию о себе, включая предыдущие дела, а также изменить эти данные при необходимости")
        }
        else if page == 6
        {
            page = 7
            makeFadetransition(image: #imageLiteral(resourceName: "guideProfile"), text: "Вы также можете переходить к другим пользователям, нажав на их имя в ленте!")
        }
        else if page == 7
        {
            let alert = UIAlertController(title: "Добро пожаловать!", message: "Если вы здесь впервые, зайдите в секцию 'часто задаваемые вопросы' для начала", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Согласен", style: .destructive, handler: {(action:UIAlertAction!) in
                if self.isUserEnteredTheFirstTime == true
                {
//                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.login()
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func makeFadetransition(image: UIImage, text: String)
    {
        UIView.transition(with: imageCorner,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations:
            {
                self.imageCorner.image = image
                self.guideText.text = "\(text)"
        },
                          completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}

    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
