//
//  AboutLeagueViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 25.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class AboutLeagueViewController: UIViewController {

    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var programmsButton: UIButton!
    @IBOutlet weak var dataButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        makeOrangeButton(button: aboutUsButton)
        makeOrangeButton(button: programmsButton)
        makeOrangeButton(button: dataButton)
        swipeBack()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showAlertMessge(title: "В разработке", message: "Временно: перейдите во вкладку 'контакты' и зайдите на сайт/соц. аккаунт Лиги", answer: "OK")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
