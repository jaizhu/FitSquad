//
//  Member.swift
//  FitSquad
//
//  Created by Danielle Connolly on 3/7/17.
//  Copyright © 2017 dogdogdog. All rights reserved.
//

import UIKit

class Member {
    
    var name: String
    var photo: UIImage?
    var participated: Bool
    
    init?(name: String, photo: UIImage?, participated: Bool) {
        
        // Fail initialization if name is left blank
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.participated = participated

    }
}
