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
        //Only read from memory if it is not empty
        if userInput.isEmpty{
            ReadFromMemory()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var textFieldInput: UITextField!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var inputButton: UIButton!
    
    
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
    }
    
    
    // Validating user input.
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

    //Figuring out the number of rows.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInput.count
    }
    
    // Raises the textfield height when keyboard appears so it would stay visible.
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    // Lowers the textfield height when keyboard is hidden.
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }

    // Creates cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
        
        cell.myTextView.text = userInput[indexPath.row]
        
        //Disables scrolling, so that textview would expand if there is a lot of input instead of allowing scrolling.
        cell.myTextView.scrollEnabled = false
        
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
        
        let path: String = directory + "todo.txt"
            
        userInputString = userInput.joinWithSeparator("-")
        
        // Writing.
        do {
            try userInputString.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("Error")// Error handling here.
        }
        }
    }
    
    // Reads a string from memory and converts it to an array, which is split based on user input.
    func ReadFromMemory() {
        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            
            let path: String = directory + "todo.txt"
        // Reading.
        do {
            savedInputString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            userInput = savedInputString.characters.split{$0 == "-" || $0 == "\r\n"}.map(String.init)
            
        } catch {
            print("Error")// Error handling here.
            }
        } else {
        print("Error")// Error handling here.
        }
    }
}

