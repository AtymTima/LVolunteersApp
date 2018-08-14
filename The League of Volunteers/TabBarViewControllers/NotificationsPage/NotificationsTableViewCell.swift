//
//  NotificationsCollectionViewCell.swift
//  The League of Volunteers
//
//  Created by  Тима on 01.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class NotificationsTableViewCell: UITableViewCell
{
    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var whenCreatedLabel: UILabel!
    @IBOutlet weak var usernameOfTheUser: UIButton!
    @IBOutlet weak var typeNews: UILabel!

}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource
{
    @objc func openGuestPage(sender: UIButton)
    {
        let i = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableViewNotifications.cellForRow(at: i) as! NotificationsTableViewCell
        if cell.usernameOfTheUser.titleLabel?.text == PFUser.current()?.username {
            let home = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            present(home, animated: true, completion: nil)
        } else {
            guestName.append(cell.usernameOfTheUser.titleLabel!.text!)
            let guest = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
            present(guest, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return username.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNotifications", for: indexPath) as! NotificationsTableViewCell
        cell.avaOfTheUser.layer.cornerRadius = cell.avaOfTheUser.frame.size.width / 2
        cell.avaOfTheUser.layer.masksToBounds = true
        
        cell.usernameOfTheUser.setTitle(username[indexPath.row], for: UIControlState())
        ava[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                cell.avaOfTheUser.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
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
        
        if types[indexPath.row] == "comment" {
            cell.typeNews.text = "ответил(-а) вам"
        }
        if types[indexPath.row] == "joined" {
            cell.typeNews.text = "присоединился(-ась) к делу"
        }
        
        cell.usernameOfTheUser.layer.setValue(indexPath, forKey: "index")
        cell.usernameOfTheUser.addTarget(self, action: #selector(NotificationsViewController.openGuestPage) , for: .touchUpInside)
        
         cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationsTableViewCell

        // going to own comments
        if cell.typeNews.text == "ответил(-а) вам"
        {
            commentuuid.append(uuid[indexPath.row])
            postuuid.append(uuid[indexPath.row])
            commentowner.append(owner[indexPath.row])
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ActivitiesCommentsViewController") as! ActivitiesCommentsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // going to user followed current user
        if cell.typeNews.text == "присоединился(-ась) к делу"
        {
            self.tabBarController?.selectedIndex = 1
        }
    }
}
