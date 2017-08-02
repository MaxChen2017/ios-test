//
//  DataModel.swift
//  CatchJob
//
//  Created by 陈秀鹏 on 2017/8/2.
//  Copyright © 2017年 com.linglustudio. All rights reserved.
//

import Foundation


// model
struct DataModel {
    // id
    var id: Int
    
    // title
    var title: String
    
    // subtitle
    var subtitle: String
    
    // content
    var content: String
    
    init(_ dic: NSDictionary) {
        self.id = dic.object(forKey: "id") as! Int
        self.title = dic.object(forKey: "title") as! String
        self.subtitle = dic.object(forKey: "subtitle") as! String
        self.content = dic.object(forKey: "content") as! String
    }
}
