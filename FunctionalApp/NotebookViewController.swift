//
//  ViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 8/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit
import CoreData

class NotebookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView : UITableView!
    var allNotebooks : [Notebook]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_add_36pt"), style: .Plain, target: self, action: #selector(addNewNotebook(_:)))
        self.title = NSLocalizedString("notebooks", comment: "")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NotebookViewController.refreshNotebooks(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNotebooks()
    }
    
    func loadNotebooks(){
        allNotebooks = DataHelper.getAllNotebooks()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return [
                UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: NSLocalizedString("delete", comment: ""), handler: { (action, indexPath) -> Void in
                    tableView.setEditing(false, animated: true)
            let context = AppDelegate.sharedAppDelegate.managedObjectContext
            context.deleteObject(self.allNotebooks![indexPath.row])
            if let _ = try? context.save(){
                dispatch_async(dispatch_get_main_queue(), {
                    self.allNotebooks?.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                })
            }
        }),
                UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: NSLocalizedString("rename", comment: ""), handler: { (action, indexPath) -> Void in
                    tableView.setEditing(false, animated: true)
                    self.renameNotebook(nil, notebookToRename: self.allNotebooks![indexPath.row])
                })
        ]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoNotes"{
            if let selRow = self.tableView.indexPathForSelectedRow{
                let notesTableVC = segue.destinationViewController as! NotesTableViewController
                notesTableVC.notebook = self.allNotebooks![selRow.row]
            }
        }
    }
    
    func saveNotebookWithName(notebookName : String) {
        if DataHelper.hasNotebookWithName(notebookName){
            CommonHelper.showAlertWithTitle(NSLocalizedString("error", comment: ""), andDescription: NSLocalizedString("notebook_already_exists", comment: ""), okHandler: {
                self.addNewNotebook(nil)
            })
        }else{
            if let notebook =  DataHelper.saveNotebookWithName(notebookName){
                self.allNotebooks?.append(notebook)
                self.allNotebooks?.sortInPlace({ (firstNotebook, secondNotebook) -> Bool in
                    firstNotebook.name < secondNotebook.name
                })
                if let curIndex = self.allNotebooks?.indexOf(notebook){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: curIndex, inSection: 0)], withRowAnimation: .Top)
                    })
                }
            }
        }
    }
    
    func renameNotebookWithName(notebookName : String, notebookToRename : Notebook){
        if DataHelper.hasNotebookWithName(notebookName){
            CommonHelper.showAlertWithTitle(NSLocalizedString("error", comment: ""), andDescription: NSLocalizedString("notebook_already_exists", comment: ""), okHandler: {})
        }else{
            notebookToRename.name = notebookName
            let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext
            if let _ = try? managedObjectContext.save(){
                loadNotebooks()
            }
        }
    }
    
    @IBAction func renameNotebook(sender : AnyObject?, notebookToRename : Notebook){
        let alertCtrl = UIAlertController(title: NSLocalizedString("rename_notebook", comment: ""), message: NSLocalizedString("enter_new_name_for_notebook", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("notebook_name", comment: "")
            textField.text = notebookToRename.name
            textField.clearButtonMode = .UnlessEditing
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                textField.selectAll(nil)
            })
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("save", comment: ""), style: UIAlertActionStyle.Default) { (ation) -> Void in
            if let nameEntered = (alertCtrl.textFields![0] as UITextField).text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) where nameEntered.characters.count > 0{
                self.renameNotebookWithName(nameEntered, notebookToRename: notebookToRename)
            }
        }
        alertCtrl.addAction(saveAction)
        alertCtrl.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        //http://stackoverflow.com/questions/33241052/xcode-iphone-6-plus-and-6s-plus-shows-warning-when-display-uialertviewcontroller
        alertCtrl.view.setNeedsLayout()//need to add this line, otherwise u will get "the behavior of the UICollectionViewFlowLayout is not defined" autolayout error
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    @IBAction func addNewNotebook(sender : AnyObject?){
        let alertCtrl = UIAlertController(title: NSLocalizedString("new_notebook", comment: ""), message: NSLocalizedString("enter_name_for_notebook", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("notebook_name", comment: "")
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("save", comment: ""), style: UIAlertActionStyle.Default) { (ation) -> Void in
            if let nameEntered = (alertCtrl.textFields![0] as UITextField).text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) where nameEntered.characters.count > 0{
                self.saveNotebookWithName(nameEntered)
            }
        }
        alertCtrl.addAction(saveAction)
        alertCtrl.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil))
        alertCtrl.view.setNeedsLayout()
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    

    @IBAction func refreshNotebooks(refreshControl : UIRefreshControl?){
        self.loadNotebooks()
        refreshControl?.endRefreshing()
    }
}

