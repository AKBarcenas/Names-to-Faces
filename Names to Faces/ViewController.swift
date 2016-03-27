//
//  ViewController.swift
//  Names to Faces
//
//  Created by Alex on 1/1/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // The collection view that will be used to displayed all of the people.
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Keeps track of all the people that have been added.
    var people = [Person]()

    /*
     * Function Name: viewDidLoad
     * Parameters: None
     * Purpose: This method creates a button that allows the user to add a person to the collection view.
     *   This method also loads in people that were saved in NSUserDefaults.
     * Return Value: None
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewPerson")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let savedPeople = defaults.objectForKey("people") as? NSData {
            people = NSKeyedUnarchiver.unarchiveObjectWithData(savedPeople) as! [Person]
        }
    }
    
    /*
     * Function Name: collectionView
     * Parameters: collectionView - the collection view that we are modifying.
     *   section - the number of things in the section that we are dealing with.
     * Purpose: This method creates items in the collection view according to how many people there are.
     * Return Value: None
     */
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    /*
     * Function Name: collectionView
     * Parameters: collectionView - the collection view that we are modifying.
     *   indexPath - specifies the location of the item in the colletion view.
     * Purpose: This method reuses a cell in the collection view and load another person. This method also formats
     *   the cell with specific features.
     * Return Value: PersonCell
     */
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! PersonCell
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().stringByAppendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path)
        
        cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    /*
     * Function Name: collectionView
     * Parameters: collectionView - the collection view that called this method.
     *   indexPath - the path to the cell in the collection view that called this method.
     * Purpose: This method creates an action view controller that allows the user to add a
     *   name to the collection view cell that they pressed.
     * Return Value: None
     */
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        ac.addAction(UIAlertAction(title: "OK", style: .Default) { [unowned self, ac] _ in
            let newName = ac.textFields![0]
            person.name = newName.text!
            
            self.collectionView.reloadData()
            self.save()
            })
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    /*
     * Function Name: addNewPerson
     * Parameters: None
     * Purpose: This method presents a view controller that allows the user to choose an image for a person.
     * Return Value: None
     */
    
    func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    /*
     * Function Name: imagePickerControllerDidCancel
     * Parameters: picker - the picker where cancel was pressed.
     * Purpose: This method dismisses the image picker when cancel was pressed inside of it.
     * Return Value: None
     */
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
     * Function Name: imagePickerController
     * Parameters: picker - the picker that we are modifying.
     *   info - a dictionary containing the edited image and original image.
     * Purpose: This method takes the image that was selected and turns it into a jpeg. This jpeg is written to disk
     *   and afterwards this image is used to create an unkown person in the collection view that can be renamed.
     * Return Value: None
     */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        let imageName = NSUUID().UUIDString
        let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
            jpegData.writeToFile(imagePath, atomically: true)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
        save()
    }
    
    /*
     * Function Name: getDocumentsDirectory
     * Parameters: None
     * Purpose: This method retrieves the parth to the documents directory where information for this app is stored.
     * Return Value: None
     */
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    /*
     * Function Name: save
     * Parameters: None
     * Purpose: This method converts the people into NSData and saves the data of people into user defaults.
     * Return Value: None
     */
    
    func save() {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(people)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "people")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

