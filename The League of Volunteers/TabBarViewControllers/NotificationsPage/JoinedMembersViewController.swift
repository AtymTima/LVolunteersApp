//
//  JoinedMembersViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 08.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit
import Parse

class JoinedMembersViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableViewMembers: UITableView!
    
    var names = [String]()
    var ava = [PFFile]()
    var members = [String]()
    var uuid = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        swipeBack()
        topView.backgroundColor = UIColor(red: 43/255.0, green: 49/255.0, blue: 83/255.0, alpha: 1)
        loadMembers()
        self.tableViewMembers.separatorStyle = .none
    }
    
    func loadMembers()
    {
        let followQuery = PFQuery(className: "Members")
        followQuery.whereKey("to", equalTo: PFUser.current()!.username!)
        followQuery.addDescendingOrder("createdAt")
        followQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            if error == nil
            {
                self.members.removeAll(keepingCapacity: false)
                self.uuid.removeAll(keepingCapacity: false)
                for object in objects!
                {
                    self.members.append(object.value(forKey: "from") as! String)
                    self.uuid.append(object.object(forKey: "uuid") as! String)
                }
                
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.members)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects, error) -> Void in
                    if error == nil
                    {
                        self.names.removeAll(keepingCapacity: false)
                        self.ava.removeAll(keepingCapacity: false)
                        
                        
                        for object in objects!
                        {
                            self.names.append(object.object(forKey: "username") as! String)
                            self.ava.append(object.object(forKey: "ava") as! PFFile)
                            self.tableViewMembers.reloadData()
                        }
                    }
                    else
                    {
                        self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
                    }
                })
            }
            else
            {
                self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
            }
        })
    }

    @IBAction func backButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}

extension JoinedMembersViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "joinedMembers", for: indexPath) as! JoinedMembersTableViewCell
        cell.usernameOfUser.setTitle(names[indexPath.row], for: .normal)
        
        cell.avaOfUser.layer.cornerRadius = cell.avaOfUser.frame.size.width / 2
        cell.avaOfUser.layer.masksToBounds = true
        ava[indexPath.row].getDataInBackground { (data, error) -> Void in
            if error == nil {
                cell.avaOfUser.image = UIImage(data: data!)
            } else {
                self.showAlertMessge(title: "Ошибка", message: "\(error!.localizedDescription)", answer: "OK")
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! JoinedMembersTableViewCell
        guestName.append(cell.usernameOfUser.titleLabel!.text!)
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
        present(vc, animated: true, completion: nil)
    }
    
}
