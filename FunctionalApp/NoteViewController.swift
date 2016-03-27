//
//  NoteViewController.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 15/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit
import CoreData

protocol NoteViewControllerDelegate : class {
    func noteCreated()
    func noteDeleted()
}

class NoteViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    var saveButtonItem : UIBarButtonItem!
    
    @IBOutlet weak var buttonPaneView: AutoAlignPaneView!
    
    @IBOutlet weak var buttonPaneViewBottomPadding: NSLayoutConstraint!
    
    @IBOutlet weak var showAdditionalButtons: UIButton!
    @IBOutlet weak var showAdditionalButtonsBottomPadding: NSLayoutConstraint!
    
    weak var delegate : NoteViewControllerDelegate?
    
    var notebook : Notebook!
    var note: Note?
    
    weak var newNoteIcon, newPhotoIcon, newBrushIcon, deleteNoteIcon : UIButton!;
    
    override func viewDidLoad() {
        self.textView.delegate = self
        saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(NoteViewController.saveNote(_:)))
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, 47, 0)
        self.buttonPaneView.backgroundColor = UIColor(white: 0.95, alpha: 0.92)
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NoteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NoteViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        newNoteIcon = self.buttonPaneView.subViewArray[0] as! UIButton
        newPhotoIcon = self.buttonPaneView.subViewArray[1] as! UIButton
        newBrushIcon = self.buttonPaneView.subViewArray[2] as! UIButton
        deleteNoteIcon = self.buttonPaneView.subViewArray[3] as! UIButton
        showAdditionalButtons.hidden = true
        
        if let existingNote = note{
            self.textView.attributedText = existingNote.content
        }else{
            addDummyText()
        }
    }
    
    func addDummyText(){
        let textToShow = "Chances are, there is some line with maybe one single comma in there, or none, or an empty line, whatever. Probably just put a try-except statement around the statement and catch the index error, probably printing out the line in question, and you should be done. Besides that, there are some things in your code, that might be worth to improve."
        let attribText = NSMutableAttributedString(string: textToShow)
        attribText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(15), range: NSMakeRange(0, 20))
        textView.attributedText = attribText
        addImageToTextView(UIImage(named: "wwdc"), atRange: NSMakeRange(50,0))
    }
    
    func addImageToTextView(image : UIImage?, atRange range : NSRange){
        guard let imageToAdd = image else{
            return
        }
        if let savedImageName = CommonHelper.savePhotoToLocalDirectory(imageToAdd){
            let imageAttachment = NoteTextAttachment()
            imageAttachment.imageName = savedImageName
            imageAttachment.image = imageToAdd
            let attribStr = NSMutableAttributedString(string: "\n\n")
            attribStr.insertAttributedString(NSAttributedString(attachment: imageAttachment), atIndex: 1)
            let textViewText = self.textView.attributedText.mutableCopy() as? NSMutableAttributedString
            if let textViewAttribText = textViewText{
                textViewAttribText.replaceCharactersInRange(range, withAttributedString: attribStr)
                self.textView.attributedText = textViewAttribText
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote(nil)
    }
    
    private func extractTitle() -> String{
        return self.textView.text.substringToIndex(self.textView.text.startIndex.advancedBy(min(15,self.textView.text.characters.count)))
    }
    
    @IBAction func saveNote(sender : AnyObject?){
        textView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext
        let curDate = NSDate()
        if let curNote = note{
            curNote.content = self.textView.attributedText
            curNote.title = extractTitle()
            curNote.updated_at = curDate
            if let _ = try? managedObjectContext.save(){
            }
        }else{
            let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedObjectContext)
            let newNote = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Note
            newNote.content = self.textView.attributedText
            newNote.title = extractTitle()
            newNote.created_at = curDate
            newNote.updated_at = curDate
            newNote.in_notebook = notebook
            notebook.numberOfNotes = NSNumber(int: notebook.numberOfNotes!.intValue+1)
            notebook.mutableSetValueForKey("notes").addObject(newNote)
            if let _ = try? managedObjectContext.save(){
            }
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func keyboardWillShow(notification : NSNotification){
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject>, keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(){
            textViewBottomConstraint.constant = keyboardRect.size.height
            self.buttonPaneViewBottomPadding.constant = keyboardRect.size.height
            self.showAdditionalButtonsBottomPadding.constant = keyboardRect.size.height + 5
            self.buttonPaneView.paddingRight = 50
            self.showAdditionalButtons.hidden = false
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.deleteNoteIcon.hidden = true
            self.newNoteIcon.hidden = true
            self.buttonPaneView.updateView()
        }
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    @IBAction func keyboardWillHide(notification : NSNotification){
        textViewBottomConstraint.constant = 0
        self.buttonPaneViewBottomPadding.constant = 0
        self.showAdditionalButtons.hidden = true
        self.deleteNoteIcon.hidden = false
        self.newNoteIcon.hidden = false
        self.buttonPaneView.updateView()
    }
    
    func showMediaWithType(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func showPhotoActionSheet(sender: UIButton?){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("photo_library", comment: ""), style: .Default) { (action) -> Void in
            self.showMediaWithType(.PhotoLibrary)
        }
        let takePhotoAction = UIAlertAction(title: NSLocalizedString("take_photo", comment: ""), style: .Default) { (action) -> Void in
            self.showMediaWithType(.Camera)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .Cancel) { (action) -> Void in
            
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addDrawing(sender: AnyObject) {
        let drawingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DrawingViewController") as! DrawingViewController
        presentViewController(drawingVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NoteViewController: UIImagePickerControllerDelegate{
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let resizedImage = selectedImage?.imageWithMaxWidth(self.textView.bounds.size.width)
        print(resizedImage)
        addImageToTextView(resizedImage, atRange: self.textView.selectedRange)
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension NoteViewController :  UITextViewDelegate{
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        print(textAttachment)
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if let allAttachments = textView.attributedText.getAllAttachmentsInRange(range){
            for curAttachment in allAttachments{
                CommonHelper.deletePhotoWithName(curAttachment.imageName)
            }
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        print("textViewDidChange")
        
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        print("textViewDidChangeSelection with selected range \(textView.selectedRange)")
        if let textAttachment = getAttachmentForSelectedRange(textView.selectedRange) where textAttachment.imageName != nil{
            textView.resignFirstResponder()
            let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
            photoVC.imageName = textAttachment.imageName
            presentViewController(photoVC, animated: true, completion: nil)
            //open photoviewer
        }
    }
    
    func getAttachmentForSelectedRange(curSelRange : NSRange) -> NoteTextAttachment?{
        var longestRange = NSRange()
        if curSelRange.location + curSelRange.length < self.textView.attributedText.length{
            let attribDict = self.textView.attributedText.attributesAtIndex(max(curSelRange.location-1,0), longestEffectiveRange:&longestRange, inRange: NSMakeRange(0,self.textView.attributedText.length))
            return attribDict[NSAttachmentAttributeName] as? NoteTextAttachment
        }
        return nil
    }
    
    
}

