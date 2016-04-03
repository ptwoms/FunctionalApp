//
//  NotebookSelectionViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 2/4/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

protocol NotebookSelectionViewControllerDelegate : class {
    func notebookSelectionViewControllerClose(notebookSVC : NotebookSelectionViewController)
}

class NotebookSelectionViewController: UIViewController {
    @IBOutlet var tableView : UITableView!
    var allNotebooks : [Notebook]?
    var selectedNotes : [Note]!
    weak var delegate : NotebookSelectionViewControllerDelegate?

    @IBOutlet weak var noteBriefLabel: UILabel!
    @IBOutlet weak var noOfNotesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var noteLocKey = "x_notes"
        if selectedNotes.count > 2{
            let firstStrToDisplay = "\(selectedNotes[0].title), \(selectedNotes[1].title)"
            noteBriefLabel.text = String(format: NSLocalizedString("x_and_more", comment: ""), firstStrToDisplay, selectedNotes.count-2)
        }else if selectedNotes.count == 2{
            noteBriefLabel.text = "\(selectedNotes[0].getTitle()), \(selectedNotes[1].getTitle())"
        }else if selectedNotes.count == 1{
            noteBriefLabel.text = selectedNotes[0].getTitle()
            noteLocKey = "one_note"
        }else{
            noteLocKey = "one_note"
            noteBriefLabel.text = ""
        }
        noOfNotesLabel.text = String(format: NSLocalizedString(noteLocKey, comment: ""), self.selectedNotes.count)
        loadNotebooks()
    }

    func loadNotebooks(){
        allNotebooks = DataHelper.getAllNotebooks()
        if let curNotebook = selectedNotes[0].in_notebook, curNotebookIndex = allNotebooks?.indexOf(curNotebook){
            allNotebooks?.removeAtIndex(curNotebookIndex)
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension NotebookSelectionViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotebooks == nil ? 2 : allNotebooks!.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("notebookCell", forIndexPath: indexPath) as! NotebookTableViewCell
        tableViewCell.notebook = allNotebooks![indexPath.row]
        return tableViewCell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let myNotebooks = allNotebooks{
            let selectedNotebook = myNotebooks[indexPath.row]
            for curNote in selectedNotes{
                curNote.in_notebook?.moveNote(curNote, toNotebook: selectedNotebook)
            }
            if let _ = try? AppDelegate.sharedAppDelegate.managedObjectContext.save(){
                delegate?.notebookSelectionViewControllerClose(self)
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

}