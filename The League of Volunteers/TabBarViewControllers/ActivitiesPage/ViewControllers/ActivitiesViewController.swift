//
//  ActivitiesViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 23.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class ActivitiesViewController: UIViewController {
    
    @IBOutlet weak var tableViewFeed: UITableView!
    var usernames = [String]()
    var ava = [PFFile]()
    var imagesOfActivity = [PFFile]()
    var descriptionsOfActivity = [String]()
    var whenCreated = [Date?]()
    var uuid = [String]()
    var amount = [Int]()
    var page = 8
    
    var refresher = UIRefreshControl()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        changeFontOfNavBar()
        
        refresher.addTarget(self, action: #selector(self.loadPosts), for: UIControlEvents.valueChanged)
        tableViewFeed.addSubview(refresher)
        tableViewFeed.separatorStyle = .none
        
        loadPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if self.imagesOfActivity.count == 0
            {
                self.showAlertMessge(title: "Немного подождите.", message: "Если посты так и не появились, возможно у вас ошибка соединения", answer: "ОК")
            }
        }
    }
    
    @objc func loadPosts()
    {
        let query = PFQuery(className: "Posts")
        query.limit = self.page
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground(block: { (objects, error) -> Void in
            if error == nil
            {
                self.usernames.removeAll(keepingCapacity: false)
                self.ava.removeAll(keepingCapacity: false)
                self.imagesOfActivity.removeAll(keepingCapacity: false)
                self.descriptionsOfActivity.removeAll(keepingCapacity: false)
                self.whenCreated.removeAll(keepingCapacity: false)
                self.uuid.removeAll(keepingCapacity: false)
                self.amount.removeAll(keepingCapacity: false)
                
                for object in objects!
                {
                    self.usernames.append(object.object(forKey: "username") as! String)
                    self.ava.append(object.object(forKey: "ava") as! PFFile)
                    self.imagesOfActivity.append(object.object(forKey: "picture") as! PFFile)
                    self.whenCreated.append(object.createdAt)
                    self.descriptionsOfActivity.append(object.object(forKey: "title") as! String)
                    self.uuid.append(object.object(forKey: "uuid") as! String)
                    self.amount.append(object.object(forKey: "amount") as! Int)
                }
                self.tableViewFeed.reloadData()
                self.refresher.endRefreshing()
                self.tableViewFeed.separatorStyle = .singleLine
            }
            else
            {
                self.showAlertMessge(title: "Ошибка загрузки", message: "\(error!.localizedDescription)", answer: "OK")
            }
        })
    }
    
    @IBOutlet weak var collectionViewActivity: UICollectionView!
    
    
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

extension ActivitiesViewController
{
    
    @objc func openCommentsActivityPage(sender: UIButton)
    {
        let i = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableViewFeed.cellForRow(at: i) as! ActivitiesAllTableViewCell
        commentuuid.append(cell.uuidLabel.text!)
        postuuid.append(cell.uuidLabel.text!)
        commentowner.append(cell.usernameOfTheUser!.titleLabel!.text!)
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ActivitiesCommentsViewController") as! ActivitiesCommentsViewController
        present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    }
}

extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource
{
    @objc func openGuestPage(sender: UIButton)
    {
        let i = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableViewFeed.cellForRow(at: i) as! ActivitiesAllTableViewCell
        if cell.usernameOfTheUser.titleLabel?.text == PFUser.current()?.username {
            let home = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestName.append(cell.usernameOfTheUser.titleLabel!.text!)
            let guest = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    @objc func openDetailedActivityPage(sender: UIButton)
    {
        let i = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableViewFeed.cellForRow(at: i) as! ActivitiesAllTableViewCell
        postuuid.append(cell.uuidLabel.text!)
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ActivitiesDetailedViewController") as! ActivitiesDetailedViewController
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return uuid.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMorePosts()
        }
    }
    
    func loadMorePosts()
    {
        if page <= uuid.count
        {
            page += 10
            loadPosts()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellActivity", for: indexPath) as! ActivitiesAllTableViewCell
        cell.avaOfTheUser.layer.cornerRadius = cell.avaOfTheUser.frame.size.width / 2
        cell.avaOfTheUser.layer.masksToBounds = true
        
        cell.usernameOfTheUser.setTitle(usernames[indexPath.row], for: .normal)
        cell.descriptionLabel.text = descriptionsOfActivity[indexPath.row]
        imagesOfActivity[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.imageOfPost.image = UIImage(data: data!)
        }
        ava[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.avaOfTheUser.image = UIImage(data: data!)
        }
        cell.uuidLabel.text = uuid[indexPath.row]
        
        cell.addActivityButton.layer.setValue(indexPath, forKey: "index")
        cell.commentaryButton.layer.setValue(indexPath, forKey: "index")
        cell.usernameOfTheUser.layer.setValue(indexPath, forKey: "index")
        
        let from = whenCreated[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
        if difference.second! <= 0 {
            cell.whenCreatedLabel.text = "сейчас"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.whenCreatedLabel.text = "\(difference.second!)с. назад."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.whenCreatedLabel.text = "\(difference.minute!)м. назад."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.whenCreatedLabel.text = "\(difference.hour!)ч. назад."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.whenCreatedLabel.text = "\(difference.day!)д. назад."
        }
        if difference.weekOfMonth! > 0 {
            cell.whenCreatedLabel.text = "\(difference.weekOfMonth!)н. назад."
        }
        
        if amount[indexPath.row] != 0
        {
            cell.amountMembers.text = String(amount[indexPath.row])
        }
        else
        {
            cell.amountMembers.text = "XX"
        }
        cell.addActivityButton.addTarget(self, action: #selector(ActivitiesViewController.openDetailedActivityPage) , for: .touchUpInside)
        cell.commentaryButton.addTarget(self, action: #selector(ActivitiesViewController.openCommentsActivityPage) , for: .touchUpInside)
        cell.usernameOfTheUser.addTarget(self, action: #selector(ActivitiesViewController.openGuestPage) , for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
