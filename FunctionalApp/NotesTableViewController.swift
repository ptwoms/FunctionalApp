//
//  NotesTableViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 15/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController {
    private var selectedNotes : [Note]?
    var allNotes : [Note]?
    @IBOutlet weak var tableView : UITableView!
    weak var bottomBar : UIView!
    var editBarButton, doneBarButton : UIBarButtonItem!
    weak var addNoteButton, moveNoteButton, deleteAllNoteButton : UIButton!
    var notebook : Notebook!{
        didSet{
            updateAllNotes()
        }
    }
    
    func updateAllNotes(){
        allNotes = notebook.allNotesSortByDate()
        tableView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        editBarButton = UIBarButtonItem(image: UIImage(named: "ic_edit_36pt")?.resizeImageToRatio(30.0/36.0), style: .Plain, target: self, action: #selector(editNotes(_:)))
        doneBarButton = UIBarButtonItem(image: UIImage(named: "ic_done_36pt"), style: .Plain, target: self, action: #selector(editNotes(_:)))
        navigationItem.rightBarButtonItem = editBarButton
        title = notebook?.name
        tableView.tableFooterView = UIView()
        addBottomBarProgramatically()
    }
    
    func addBottomBarProgramatically() {
        let bottomBarHeight : CGFloat = 50;
        var modifiedInsets = UIEdgeInsetsZero
        modifiedInsets.bottom += bottomBarHeight
        self.tableView.contentInset = modifiedInsets
        self.tableView.scrollIndicatorInsets = modifiedInsets
        let barView = UIView.autoLayoutView()
        barView.backgroundColor = UIColor.whiteColor()
        view.addSubview(barView)
        view.addLeftPadding(0, rightPadding: 0, withSubView: barView)
        view.addBottomPadding(0, withSubView: barView)
        view.addHeight(bottomBarHeight, toView: barView)
        bottomBar = barView
        let btnSize : CGFloat = 36
        let centerAdjustment : CGFloat = -3
        //new Note
        let newNoteBtn = createButtonWithImage("ic_note_add_36pt", actionToDo: #selector(addNewNote(_:)))
        barView.addSubview(newNoteBtn)
        barView.addWidth(btnSize, andHeight: btnSize, toView: newNoteBtn)
        barView.centerVerticalSubView(newNoteBtn, constant: centerAdjustment)
        barView.addRightPadding(20, withSubView: newNoteBtn)
        addNoteButton = newNoteBtn
        
        //move note
        let moveNoteBtn = createButtonWithImage("ic_arrow_forward_36pt", actionToDo: #selector(moveNotes(_:)))
        barView.addSubview(moveNoteBtn)
        moveNoteBtn.hidden = true
        barView.addWidth(btnSize, andHeight: btnSize, toView: moveNoteBtn)
        barView.centerVerticalSubView(moveNoteBtn, constant: centerAdjustment)
        barView.addLeftPadding(20, withSubView: moveNoteBtn)
        moveNoteButton = moveNoteBtn
        
        let deleteNoteBtn = createButtonWithImage("ic_delete_36pt", actionToDo: #selector(deleteSelectedNotes(_:)))
        barView.addSubview(deleteNoteBtn)
        deleteNoteBtn.hidden = true
        barView.addWidth(btnSize, andHeight: btnSize, toView: deleteNoteBtn)
        barView.centerVerticalSubView(deleteNoteBtn, constant: centerAdjustment)
        barView.addRightPadding(20, withSubView: deleteNoteBtn)
        deleteAllNoteButton = deleteNoteBtn
    }
    
    private func createButtonWithImage(imageName : String, actionToDo : Selector) -> UIButton{
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.addTarget(self, action: actionToDo, forControlEvents: .TouchUpInside)
        return button
    }
    
    @IBAction func addNewNote(sender : AnyObject?){
        let noteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("noteViewController") as! NoteViewController
        noteVC.notebook = notebook!
        noteVC.delegate = self
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
    
    @IBAction func editNotes(sender : AnyObject?){
        navigationItem.rightBarButtonItem = tableView.editing ? editBarButton : doneBarButton
        tableView.setEditing(!tableView.editing, animated: true)
        if tableView.editing{
            moveNoteButton.hidden = false
            deleteAllNoteButton.hidden = false
            addNoteButton.hidden = true
        }else{
            moveNoteButton.hidden = true
            deleteAllNoteButton.hidden = true
            addNoteButton.hidden = false
            //do additional test
        }
        deleteAllNoteButton.enabled = false
        moveNoteButton.enabled = false
    }
    
    private func getSelectedNotesForIndexes(selIndexPathes : [NSIndexPath]) -> [Note]{
        guard let myNotes = allNotes else{
            return []
        }
        var selNotes = [Note]()
        for curIndexPath in selIndexPathes {
            selNotes.append(myNotes[curIndexPath.row])
        }
        return selNotes
    }
    
    @IBAction func moveNotes(sender : AnyObject?){
        if let selectedIndexes = tableView.indexPathsForSelectedRows{
            let noteSelectionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NotebookSelectionViewController") as! NotebookSelectionViewController
            noteSelectionVC.selectedNotes = getSelectedNotesForIndexes(selectedIndexes)
            noteSelectionVC.delegate = self
            presentViewController(noteSelectionVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteSelectedNotes(sender : AnyObject?){
        if let selectedIndexes = tableView.indexPathsForSelectedRows{
            let selNotes = getSelectedNotesForIndexes(selectedIndexes)
            for curNote in selNotes{
                notebook.deleteNote(curNote)
            }
            if let _ = try? AppDelegate.sharedAppDelegate.managedObjectContext.save(){
                tableView.beginUpdates()
                allNotes = notebook.allNotesSortByDate()
                tableView.deleteRowsAtIndexPaths(selectedIndexes, withRowAnimation: .Bottom)
                tableView.endUpdates()
                editNotes(false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension NotesTableViewController : UITableViewDelegate, UITableViewDataSource{
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes == nil ? 0 : allNotes!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteTableViewCell", forIndexPath: indexPath) as! NoteTableViewCell
        cell.note = allNotes![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing{
            if tableView.indexPathsForSelectedRows?.count > 0{
                moveNoteButton.enabled = true
                deleteAllNoteButton.enabled = true
            }
        }else{
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let noteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("noteViewController") as! NoteViewController
            noteVC.title = NSLocalizedString("new_note", comment: "")
            noteVC.notebook = notebook!
            noteVC.note = allNotes![indexPath.row]
            noteVC.delegate = self
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.editing{
            if tableView.indexPathsForSelectedRows == nil{
                moveNoteButton.enabled = false
                deleteAllNoteButton.enabled = false
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: NSLocalizedString("delete", comment: ""), handler: { (action, indexPath) -> Void in
            let context = AppDelegate.sharedAppDelegate.managedObjectContext
            context.deleteObject(self.allNotes![indexPath.row])
            if let _ = try? context.save(){
                dispatch_async(dispatch_get_main_queue(), {
                    self.allNotes!.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                })
            }
        })]
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if tableView.editing{
            return .None
        }
        return .Delete
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

extension NotesTableViewController : NotebookSelectionViewControllerDelegate{
    func notebookSelectionViewControllerClose(notebookSVC: NotebookSelectionViewController) {
        editNotes(false)
    }
}

extension NotesTableViewController : NoteViewControllerDelegate{
    func noteCreated(newNote: Note) {
        updateAllNotes()
        //no effects are visible unless you set a delay
//        tableView.beginUpdates()
//        allNotes = notebook.allNotesSortByDate()
//        if allNotes?.count > 0{
//            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
//        }
//        tableView.endUpdates()
    }
    
    func noteDeleted(noteDeleted: Note) {
        updateAllNotes()
        //no effects are visible unless you you set a delay
//        if let indexOfDeletion = allNotes?.indexOf(noteDeleted){
//            tableView.beginUpdates()
//            allNotes?.removeAtIndex(indexOfDeletion)
//            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexOfDeletion, inSection: 0)], withRowAnimation: .Bottom)
//            tableView.endUpdates()
//        }else{
//            updateAllNotes()
//        }
    }
    
    func noteUpdated(updatedNote: Note) {
        updateAllNotes()
    }
}
