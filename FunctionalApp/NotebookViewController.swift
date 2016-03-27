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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(NotebookViewController.addNewNotebook(_:)))
        self.title = NSLocalizedString("notebooks", comment: "")
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NotebookViewController.refreshNotebooks(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadNotebooks()
    }
    
    func loadNotebooks(){
        let request = NSFetchRequest(entityName: "Notebook")
        allNotebooks = try! AppDelegate.sharedAppDelegate.managedObjectContext.executeFetchRequest(request) as? [Notebook]
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
        return [UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: NSLocalizedString("delete", comment: ""), handler: { (action, indexPath) -> Void in
            CommonHelper.showAlertWithTitle(NSLocalizedString("warning", comment: ""), andDescription: NSLocalizedString("delete_notebook_message", comment: ""), okHandler: { () -> Void in
                    let context = AppDelegate.sharedAppDelegate.managedObjectContext
                    context.deleteObject(self.allNotebooks![indexPath.row])
                    if let _ = try? context.save(){
                        self.allNotebooks?.removeAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                }, cancelHandler: nil)
        })]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoNotes"{
            if let selRow = self.tableView.indexPathForSelectedRow{
                let notesTableVC = segue.destinationViewController as! NotesTableViewController
                notesTableVC.notebook = self.allNotebooks![selRow.row]
            }
        }
    }
    
    @IBAction func addNewNotebook(sender : AnyObject?){
        let alertCtrl = UIAlertController(title: NSLocalizedString("new_notebook", comment: ""), message: NSLocalizedString("enter_name_for_notebook", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alertCtrl.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("notebook_name", comment: "")
        }
        let saveAction = UIAlertAction(title: NSLocalizedString("save", comment: ""), style: UIAlertActionStyle.Default) { (ation) -> Void in
            if let nameEntered = (alertCtrl.textFields![0] as UITextField).text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) where nameEntered.characters.count > 0{
                let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext
               let request = managedObjectContext.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplateWithName("hasNotebookWithName", substitutionVariables: ["newName":nameEntered])
                if let result = try? managedObjectContext.executeFetchRequest(request!) where result.count > 0{
                    CommonHelper.showAlertWithTitle(NSLocalizedString("error", comment: ""), andDescription: NSLocalizedString("notebook_already_exists", comment: ""), okHandler: {
                        self.addNewNotebook(nil)
                    })
                }else{
                    let entity = NSEntityDescription.entityForName("Notebook", inManagedObjectContext: managedObjectContext)
                    let notebook = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
                    notebook.setValue(nameEntered, forKey: "name")
                    if let _ = try? managedObjectContext.save(){
                        self.loadNotebooks()
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        alertCtrl.addAction(saveAction)
        alertCtrl.addAction(cancelAction)
        //http://stackoverflow.com/questions/33241052/xcode-iphone-6-plus-and-6s-plus-shows-warning-when-display-uialertviewcontroller
        alertCtrl.view.setNeedsLayout()//need to add this line, otherwise u will get "the behavior of the UICollectionViewFlowLayout is not defined" autolayout error
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    

    @IBAction func refreshNotebooks(refreshControl : UIRefreshControl?){
        self.loadNotebooks()
        refreshControl?.endRefreshing()
    }
}

