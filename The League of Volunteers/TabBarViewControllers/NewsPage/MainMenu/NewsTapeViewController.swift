//
//  NewsTapeViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 24.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTapeViewController: UIViewController {
    
    let newsFeedInstance = newsFeedApi()
    var newsFeedAllImages: [String] = []
    var newsFeedAvaLOV: String = ""
    var newsFeedAllDescriptions: [String] = []
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var tableViewNewsFeed: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.parseJson()
        }
        print(newsFeedInstance.imagesOfThePostLOV.count)
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(NewsTapeViewController.reloadNewsFeed), for: UIControlEvents.valueChanged)
        tableViewNewsFeed?.addSubview(refresher)
        swipeBack()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if self.newsFeedInstance.imagesOfThePostLOV.count == 0
            {
                self.showAlertMessge(title: "Немного подождите.", message: "Если посты так и не появились, возможно у вас ошибка соединения", answer: "ОК")
            }
        }
        
    }

    @objc func reloadNewsFeed()
    {
        tableViewNewsFeed?.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    @IBAction func returnToMainButton(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

extension NewsTapeViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return newsFeedInstance.imagesOfThePostLOV.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNewsFeed", for: indexPath) as! NewsFeedTableViewCell
        let url = URL(string: newsFeedInstance.imagesOfThePostLOV[indexPath.row])
        cell.imageOfPostOfLOV.kf.setImage(with: url)
        let urlAva = URL(string: newsFeedInstance.avaOfTheLOV)
        cell.avaOfTheLOV.kf.setImage(with: urlAva)
        cell.descriptionOfPostLOV.text = newsFeedInstance.descriptionsOfThePostLOV[indexPath.row]
        cell.selectionStyle = .none
        cell.imageOfPostOfLOV.layer.borderWidth = 0.5
        cell.imageOfPostOfLOV.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}
