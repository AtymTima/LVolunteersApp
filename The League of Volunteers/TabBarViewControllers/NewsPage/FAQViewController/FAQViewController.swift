//
//  FAQViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 25.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var tableVIewFAQ: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack()
    }
    
    var expandText = UITextView()
    var shouldCellBeExpanded = false
    var indexOfExpendedCell:NSInteger = -1
    var checkStateOfTexts = 0
    
    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning() }}
