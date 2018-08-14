//
//  ActivitiesAllTableViewCell.swift
//  The League of Volunteers
//
//  Created by  Тима on 01.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class ActivitiesAllTableViewCell: UITableViewCell
{
    @IBOutlet weak var avaOfTheUser: UIImageView!
    @IBOutlet weak var usernameOfTheUser: UIButton!
    @IBOutlet weak var imageOfPost: UIImageView!
    @IBOutlet weak var numberOfNeededMembers: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var whenCreatedLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel! 
    @IBOutlet weak var amountMembers: UILabel!
    
    @IBOutlet weak var commentaryButton: UIButton!
    @IBOutlet weak var addActivityButton: UIButton!
    
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSecond: UIView!
    @IBOutlet weak var viewThird: UIView!

    @IBAction func addActivityButtonPressed(_ sender: AnyObject)
    {
    }
    override func awakeFromNib() {
        super.awakeFromNib()}

    override func setSelected(_ selected: Bool, animated: Bool) {super.setSelected(selected, animated: animated)}}
