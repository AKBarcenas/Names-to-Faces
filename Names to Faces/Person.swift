//
//  Person.swift
//  Names to Faces
//
//  Created by Alex on 1/1/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    // The person's name.
    var name: String
    // The person's picture.
    var image: String
    
    /*
     * Function Name: init
     * Parameters: name - the name we are giving the person.
     *   image - the picture we are giving the person.
     * Purpose: This method creates a person with the given name and image.
     * Return Value: None
     */
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    /*
    * Function Name: init
    * Parameters: aDecoder - a decoder used for the data.
    * Purpose: This method decodes the name and image for loading.
    * Return Value: None
    */
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
    }
    
    /*
    * Function Name: encodeWithCoder
    * Parameters: aCoder - a encoder used for the data.
    * Purpose: This method encodes the name and image for saving.
    * Return Value: None
    */
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
    }
        
}
