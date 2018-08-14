//
//  ActivitiesDetailedTableViewCell.swift
//  The League of Volunteers
//
//  Created by  Тима on 06.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class ActivitiesDetailedTableViewCell: UITableViewCell {

    @IBOutlet weak var viewWithNumberOfMembers: UIView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var reward: UILabel!
    @IBOutlet weak var nameOfActivity: UILabel!
    @IBOutlet weak var whenWasCreatedOutlet: UILabel!
    @IBOutlet weak var imageOfActivity: UIImageView!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var usernameIDLabel: UILabel!
    @IBOutlet weak var descriptionOfActivity: UILabel!
    @IBOutlet weak var joinToActivityButton: UIButton!
    @IBOutlet weak var amountOfMembers: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func finishActivityButtonPressed(_ sender: UIButton)
    {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) }}

extension ActivitiesDetailedViewController: UITableViewDelegate, UITableViewDataSource
{
    @objc func finishActivity()
    {
        let postQuery = PFQuery(className: "Posts")
        postQuery.whereKey("uuid", equalTo: uuidArray[0])
        postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    object["isFinished"] = "true"
                    object.saveEventually()
                }
            }
        })
        
        let userQuery = PFQuery(className: "Members")
        userQuery.whereKey("uuid", equalTo: uuidArray[0])
        userQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                self.from.removeAll(keepingCapacity: false)
//                var counts = 0
                for object in objects!
                {
                    self.from.append(object.object(forKey: "from") as! String)
                    self.findMatchUser()
                }
                
            }
        })
    }
    
    func findMatchUser()
    {
            let us = PFQuery(className: "Foreign")
        
            us.whereKey("username", equalTo: from[counts])
            counts += 1
            us.findObjectsInBackground (block: { (objects, error) -> Void in
                if error == nil
                {
                    for obj in objects!
                    {
                        let foreign = obj["foreign"] as! String
                        let fr = Int(foreign)! + 1
                        obj["foreign"] = "\(fr)"

                            obj["foreign"] = "\(fr)"
                        
                        obj.saveEventually()
                    }
                }
            })
        
        self.showAlertMessge(title: "Дело завершено", message: "Все участники вознаграждены", answer: "ОК")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.tableViewDetailed.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesOfActivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetailedActivity", for: indexPath) as! ActivitiesDetailedTableViewCell
        cell.uuidLabel.text = uuidArray[indexPath.row]
        cell.usernameIDLabel.text = usernameArray[indexPath.row]
        cell.nameOfActivity.text = namesOfActivity[indexPath.row]
        cell.descriptionOfActivity.text = descriptionsOfActivity[indexPath.row]
        cell.date.text = dateAndTimeOfActivity[indexPath.row]
        cell.location.text = locationOfActivity[indexPath.row]
        cell.reward.text = rewardOfActivity[indexPath.row]
        cell.whenWasCreatedOutlet.text = "\(whenCreated[indexPath.row]!)"
        imagesOfActivity[indexPath.row].getDataInBackground { (data, error) -> Void in
            cell.imageOfActivity.image = UIImage(data: data!)
        }
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                for object in objects!
                {
                    if object.value(forKey: "role") as! String == "admin"
                    {
                        self.enableFinishButton(button: cell.finishButton)
                    }
                }
            }
        })
        
        if isButtonEnabled == true && joined == false
        {
            cell.joinToActivityButton.isEnabled = true
        }
        else if isButtonEnabled == false && self.ownPost == true
        {
            cell.joinToActivityButton.isEnabled = false
            cell.joinToActivityButton.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            cell.joinToActivityButton.setTitle("Нынешний проект", for: .normal)
        }
        else if isButtonEnabled == false && self.ownPost == false
        {
            cell.joinToActivityButton.isEnabled = false
            cell.joinToActivityButton.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            cell.joinToActivityButton.setTitle("Проект завершен", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                self.disableFinishButton(button: cell.finishButton)
            }
        }
        else if isButtonEnabled == true && joined == true
        {
            cell.joinToActivityButton.isEnabled = false
            cell.joinToActivityButton.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            cell.joinToActivityButton.setTitle("Вы уже присоединились", for: .normal)
        }
        
        
//        cell.scrollView.contentSize.height = 1000
        cell.viewWithNumberOfMembers.layer.cornerRadius = cell.viewWithNumberOfMembers.frame.height / 2
        cell.viewWithNumberOfMembers.clipsToBounds = true
        
        if amount[indexPath.row] != 0 && amount[indexPath.row] != 10000
        {
            cell.amountOfMembers.text = String(amount[indexPath.row])
        }
        else if amount[indexPath.row] == 0 || amount[indexPath.row] == 10000
        {
            cell.amountOfMembers.text = "XX"
        }
        
        
        let from = whenCreated[indexPath.row]
        let now = Date()
        let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: from!, to: now, options: [])
        
        if difference.second! <= 0 {
            cell.whenWasCreatedOutlet.text = "сейчас"
        }
        if difference.second! > 0 && difference.minute! == 0 {
            cell.whenWasCreatedOutlet.text = "\(difference.second!)с. назад."
        }
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.whenWasCreatedOutlet.text = "\(difference.minute!)м. назад."
        }
        if difference.hour! > 0 && difference.day! == 0 {
            cell.whenWasCreatedOutlet.text = "\(difference.hour!)ч. назад."
        }
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.whenWasCreatedOutlet.text = "\(difference.day!)д. назад."
        }
        if difference.weekOfMonth! > 0 {
            cell.whenWasCreatedOutlet.text = "\(difference.weekOfMonth!)н. назад."
        }
        cell.finishButton.addTarget(self, action: #selector(ActivitiesDetailedViewController.finishActivity) , for: .touchUpInside)
        return cell
    }
    
    func enableFinishButton(button: UIButton)
    {
        button.isEnabled = true
        button.isHidden = false
    }
    
    func disableFinishButton(button: UIButton)
    {
        button.isEnabled = false
        button.isHidden = true
    }
    
}
