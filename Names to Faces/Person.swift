//
//  Person.swift
//  Names to Faces
//
//  Created by Alex on 1/1/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
