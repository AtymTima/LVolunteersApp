//
//  ActivitiesCollectionViewCell.swift
//  The League of Volunteers
//
//  Created by  Тима on 30.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell
{
    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var usernameOfTheUser: UILabel!
    @IBOutlet weak var imageOfPost: UIImageView!
    @IBOutlet weak var numberOfNeededMembers: UIView!
    @IBOutlet weak var descriptionOfActivity: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func addActivityButtonPressed(_ sender: UIButton)
    {
        
    }
    @IBAction func commentaryButtonPressed(_ sender: UIButton)
    {
    }
    @IBOutlet weak var commentaryButton: UIButton!
    @IBOutlet weak var addActivityButton: UIButton!
    
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewThird: UIView!
    
    
}
