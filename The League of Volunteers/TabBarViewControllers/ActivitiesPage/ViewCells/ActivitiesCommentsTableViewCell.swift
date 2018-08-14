//
//  ActivitiesCommentsTableViewCell.swift
//  The League of Volunteers
//
//  Created by  Тима on 01.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class ActivitiesCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var commentOfTheUser: UILabel!
    @IBOutlet weak var whenCreatedLabel: UILabel!
    @IBOutlet weak var usernameOfTheUser: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()}

    override func setSelected(_ selected: Bool, animated: Bool) {super.setSelected(selected, animated: animated)}}

extension ActivitiesCommentsViewController: UITableViewDelegate, UITableViewDataSource
{
    @objc func openGuestPage(sender: UIButton)
    {
        let i = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableViewWithComments.cellForRow(at: i) as! ActivitiesCommentsTableViewCell
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
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellComments", for: indexPath) as! ActivitiesCommentsTableViewCell
//        cell.avaOfTheUser.image = cell.avaOfAllUsers[indexPath.row]
        cell.avaOfTheUser.layer.cornerRadius = cell.avaOfTheUser.frame.size.width / 2
        cell.avaOfTheUser.layer.masksToBounds = true
        
        cell.usernameOfTheUser.setTitle(usernames[indexPath.row], for: .normal)
        cell.usernameOfTheUser.sizeToFit()
        cell.commentOfTheUser.text = comments[indexPath.row]
        ava[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.avaOfTheUser.image = UIImage(data: data!)
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
        cell.usernameOfTheUser.layer.setValue(indexPath, forKey: "index")
        cell.usernameOfTheUser.addTarget(self, action: #selector(ActivitiesCommentsViewController.openGuestPage) , for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let cell = tableView.cellForRow(at: indexPath) as! ActivitiesCommentsTableViewCell
        let delete = UITableViewRowAction(style: .destructive, title: "    ")
        { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            let commentQuery = PFQuery(className: "Comments")
            commentQuery.whereKey("to", equalTo: commentuuid.last!)
            commentQuery.whereKey("comment", equalTo: cell.commentOfTheUser.text!)
            commentQuery.findObjectsInBackground (block: { (objects, error) -> Void in
                if error == nil {
                    for object in objects!
                    {
                        object.deleteEventually()
                    }
                }
                else
                {
                    self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
                }
            })
            
            let newsQuery = PFQuery(className: "News")
            newsQuery.whereKey("by", equalTo: cell.usernameOfTheUser.titleLabel!.text!)
            newsQuery.whereKey("to", equalTo: commentowner.last!)
            newsQuery.whereKey("uuid", equalTo: commentuuid.last!)
            newsQuery.whereKey("type", containedIn: ["comment"])
            newsQuery.findObjectsInBackground(block: { (objects, error) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
            self.tableViewWithComments.setEditing(false, animated: true)
            self.comments.remove(at: indexPath.row)
            self.whenCreated.remove(at: indexPath.row)
            self.usernames.remove(at: indexPath.row)
            self.ava.remove(at: indexPath.row)
            
            self.tableViewWithComments.deleteRows(at: [indexPath], with: .fade)
        }
        
        
        if cell.usernameOfTheUser.titleLabel!.text! == PFUser.current()?.username
        {
            return [delete]
        }
            
            // post belongs to user
        else if commentowner.last == PFUser.current()?.username
        {
            return [delete]
        }
            
            // post belongs to another user
        else
        {
            return []
        }
    }

    
}
