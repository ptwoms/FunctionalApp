//
//  NotesTableViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 15/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    var allNotes : [Note]?
    var notebook : Notebook!{
        didSet{
            allNotes = notebook.notes?.allObjects as? [Note]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: #selector(NotesTableViewController.addNewNote(_:)))
        self.title = notebook?.name

    }
    
    @IBAction func addNewNote(sender : AnyObject?){
        let noteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("noteViewController") as! NoteViewController
        noteVC.title = NSLocalizedString("new_note", comment: "")
        noteVC.notebook = notebook!
        self.navigationController?.pushViewController(noteVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes == nil ? 0 : allNotes!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteTableViewCell", forIndexPath: indexPath) as! NoteTableViewCell
        cell.note = allNotes![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let noteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("noteViewController") as! NoteViewController
        noteVC.title = NSLocalizedString("new_note", comment: "")
        noteVC.notebook = notebook!
        noteVC.note = allNotes![indexPath.row]
        self.navigationController?.pushViewController(noteVC, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
