//
//  officialNewsApi.swift
//  The League of Volunteers
//
//  Created by  Тима on 31.07.2018.
//  Copyright © 2018 The League of Volunteers. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class newsFeedApi
{
    var avaOfTheLOV: String = ""
    var imagesOfThePostLOV: [String] = []
    var descriptionsOfThePostLOV:[String] = []
}

extension NewsTapeViewController
{
    func parseJson(){
        if newsFeedInstance.imagesOfThePostLOV.count == 0
        {
            Alamofire.request("https://apinsta.herokuapp.com/u/league_volunteers", method: .get).validate().responseJSON { response in
                if let json = response.data {
                    do{
                        let list = try JSON(data: json)
                        let array = list["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
                        self.newsFeedInstance.avaOfTheLOV.append(list["graphql"]["user"]["profile_pic_url_hd"].string!)
                        for i in array {
                            self.newsFeedInstance.imagesOfThePostLOV.append(i.1["node"]["display_url"].string!)
                            let pathToDescription = i.1["node"]["edge_media_to_caption"]["edges"]
                            for j in pathToDescription
                            {
                                self.newsFeedInstance.descriptionsOfThePostLOV.append(j.1["node"]["text"].string!)
                            }
                        }
                        print("WE DID IT")
                        self.tableViewNewsFeed.reloadData()
                        self.cancelRequest()
                    } catch {
                        print("error")
                    }
                }
            }
        }
        
        
    }
    

    
    func cancelRequest()
    {
        let request = Alamofire.request("https://apinsta.herokuapp.com/u/league_volunteers")
        request.cancel()
    }
}
