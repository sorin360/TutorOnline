//
//  Message.swift
//  TestApp
//
//  Created by Lica Sorin on 30/12/2020.
//  Copyright © 2020 Lica Sorin. All rights reserved.
//

import Foundation

struct Message {
    
    var id = UUID()
    var text: String
    var timeStamp: TimeInterval
    var local: Bool
    
//    init(text: String, timeStamp: TimeInterval, local: Bool = false) {
//        self.text = text
//        self.timeStamp = timeStamp
//        self.local = local
//    }
    
    init(dictionary: [String:Any], local: Bool = false) {
        self.text = dictionary["text"] as! String
        self.timeStamp = dictionary["timeStamp"] as! TimeInterval
        self.local = local
    }
}
