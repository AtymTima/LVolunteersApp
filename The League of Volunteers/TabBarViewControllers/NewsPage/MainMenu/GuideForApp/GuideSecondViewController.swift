//
//  GuideSecondViewController.swift
//  The League of Volunteers
//
//  Created by  Тима on 15.08.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import UIKit

class GuideSecondViewController: UIViewController {

    @IBOutlet weak var gifSwipe: UIImageView!
    @IBOutlet weak var gifText: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        swipeBack()
        self.view.backgroundColor = UIColor(red: 185/255.0, green: 91/255.0, blue: 91/255.0, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now())
        {
            let gifURL : String = "https://thumbs.gfycat.com/PhonyWealthyEastrussiancoursinghounds-max-1mb.gif"
            let imageURL = UIImage.gifImageWithURL(gifURL)
            let imageView3 = UIImageView(image: imageURL)
            imageView3.frame = CGRect(x: 0.0, y: 0.0, width: self.gifSwipe.frame.size.width, height: self.gifSwipe.frame.size.height)
            self.gifSwipe.insertSubview(imageView3, at: 0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        gifSwipe.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}}
