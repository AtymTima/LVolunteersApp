//
//  FAQTableViewCell.swift
//  The League of Volunteers
//
//  Created by  Тима on 30.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

protocol changeToogleValue
{
    func didChangeValueToogle(toogle: Bool)
}

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var answerbutton: UIButton!
    @IBOutlet weak var answerText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var delegate: changeToogleValue?
    
    @IBAction func onClickDropAnswerText(_ sender: UIButton)
    {
        if answerText.isHidden
        {
            animate(toogle: true)
            
        }
        else
        {
            animate(toogle: false)
            delegate?.didChangeValueToogle(toogle: false)
            
        }
    }
    
    func animate(toogle: Bool)
    {
        if toogle
        {
            UIView.animate(withDuration: 1.5)
            {
                self.answerText.isHidden = false
            }
        }
        else
        {
            UIView.animate(withDuration: 1.5)
            {
                self.answerText.isHidden = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
