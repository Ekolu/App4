//
//  ViewController.swift
//  App4
//
//  Created by Kipras on 2/23/16.
//  Copyright © 2016 Kipras. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputButton.enabled = false
        self.tableView.estimatedRowHeight = 43
        self.tableView.rowHeight = UITableViewAutomaticDimension
        ReadFromMemory()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardShown:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardHidden:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var textFieldInput: UITextField!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var inputButton: UIButton!
    
    @IBOutlet weak var textFieldConstraint: NSLayoutConstraint!

    
    // Declaring variables.
    var userInput = [String]()
    var userInputString: String!
    var savedInputString: String!
    
    
    
    // On button click puts user input into an array and saves it to memory.
    @IBAction func AddInput(sender: AnyObject) {
        userInput.append(textFieldInput.text!)
        
        textFieldInput.text="";
        inputButton.enabled = false
        self.tableView.reloadData()
        WriteToMemory()
        self.view.endEditing(true)
    }
    
    
    // Validates user input.
    @IBAction func Validation(sender: UITextField) {
        if (textFieldInput.text!.isEmpty)
        {
            inputButton.enabled = false
        }
        else
        {
            inputButton.enabled = true
        }

    }

    // Figures out the number of rows.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInput.count
    }
    
    // Raises the height of the textfield when keyboard appears.
    func keyboardShown(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    
    // Lowers the height of the textfield when keyboard is hidden.
    func keyboardHidden(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    // Adjusts the height of textfield when keyboard is on/off.
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let changeInHeight = (CGRectGetHeight(keyboardFrame) + 8) * (show ? 1 : -1)
        UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
            self.textFieldConstraint.constant += changeInHeight
        })
    }
    
    // Close keyboard when an empty area on screen is touched.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Creates cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        cell.myTextView.text = userInput[indexPath.row]
        
        // Disables scrolling, so that textview would expand if there is a lot of input instead of allowing scrolling.
        cell.myTextView.scrollEnabled = false
        // Disables textView editing.
        cell.myTextView.editable = false;
        
        return cell
    }
    
    // Deletes the specified row and an element from an array.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            userInput.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            WriteToMemory()
        }
    }
    
    // Writes 1 string to device's memory.
    func WriteToMemory() {
        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        
        let path: String = directory + "/App4.txt"
            
        userInputString = userInput.joinWithSeparator("-")
        
        // Writing.
        do {
            try userInputString.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            print(path)
            print("Error1")// Error handling here.
        }
        }
    }
    
    // Reads a string from memory and converts it to an array, which is split based on user input.
    func ReadFromMemory() {
        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path: String = directory + "/App4.txt"
        // Reading.
        do {
            savedInputString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            userInput = savedInputString.characters.split{$0 == "-" || $0 == "\r\n"}.map(String.init)
            
        } catch {
            print(path)
            print("Error2")// Error handling here.
            }
        } else {
        print("Error3")// Error handling here.
        }
    }
}

