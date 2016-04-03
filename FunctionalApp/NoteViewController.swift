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
    func noteCreated(newNote : Note)
    func noteUpdated(updatedNote : Note)
    func noteDeleted(noteDeleted : Note)
}

class NoteViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    var saveButtonItem : UIBarButtonItem!
    var isEdited : Bool = false
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var buttonPaneView: AutoAlignPaneView!
    
    @IBOutlet weak var buttonPaneViewBottomPadding: NSLayoutConstraint!
    
    @IBOutlet weak var showAdditionalButtons: UIButton!
    @IBOutlet weak var showAdditionalButtonsBottomPadding: NSLayoutConstraint!
    var kbHeight : CGFloat = 0
    
    weak var delegate : NoteViewControllerDelegate?
    
    var notebook : Notebook!
    var note: Note?
    private var thumbnailImageURL : String?
    
    @IBOutlet weak var newNoteIcon : UIButton!
    @IBOutlet weak var newPhotoIcon : UIButton!
    @IBOutlet weak var newDrawingIcon : UIButton!
    @IBOutlet weak var deleteNoteIcon : UIButton!
    
    override func viewDidLoad() {
        self.textView.delegate = self
        if note == nil{
            title = NSLocalizedString("new_note", comment: "")
        }else{
            title = ""
        }
        saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(NoteViewController.doneClicked(_:)))
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, 47, 0)
        self.buttonPaneView.backgroundColor = UIColor(white: 0.95, alpha: 0.92)
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NoteViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NoteViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        deleteNoteIcon = self.buttonPaneView.subViewArray[0] as! UIButton        
        newPhotoIcon = self.buttonPaneView.subViewArray[1] as! UIButton
        newDrawingIcon = self.buttonPaneView.subViewArray[2] as! UIButton
        newNoteIcon = self.buttonPaneView.subViewArray[3] as! UIButton
        textView.addGestureRecognizer(tapGestureRecognizer)
        showAdditionalButtons.hidden = true
        if let existingNote = note{
            self.textView.attributedText = existingNote.content
        }else{
            self.textView.becomeFirstResponder()
            newNoteIcon.enabled = false
        }
    }
    
    func addImageToTextView(image : UIImage?, atRange range : NSRange){
        addImageToTextView(image, atRange: range, attachmentClass: NoteTextAttachment.self)
    }
    
    func addImageToTextView(image : UIImage?, atRange range : NSRange, attachmentClass : NoteTextAttachment.Type) -> NoteTextAttachment?{
        guard let imageToAdd = image else{
            return nil
        }
        if let savedImageName = CommonHelper.savePhotoToLocalDirectory(imageToAdd){
            isEdited = true
            let imageAttachment = attachmentClass.init()
            imageAttachment.imageName = savedImageName
            imageAttachment.image = imageToAdd
            let attribStr = NSMutableAttributedString(string: "\n\n")
            attribStr.insertAttributedString(NSAttributedString(attachment: imageAttachment), atIndex: 1)
            let textViewText = self.textView.attributedText.mutableCopy() as? NSMutableAttributedString
            if let textViewAttribText = textViewText{
                textViewAttribText.replaceCharactersInRange(range, withAttributedString: attribStr)
                self.textView.attributedText = textViewAttribText
            }
            return imageAttachment
        }
        return nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote(nil)
    }
    
    private func extractTitle() -> String{
        if self.textView.attributedText.length > 0{
            let first50Text = textView.attributedText.getFirstStrippedCharacters(50)
            if first50Text.characters.count > 0{
                return first50Text
            }
            return NSLocalizedString("new_note", comment: "")
        }
        return ""
    }
    
    
    @IBAction func doneClicked(sender : AnyObject?){
        self.navigationItem.rightBarButtonItem = nil
        if !isEdited && note == nil{
            navigationController?.popViewControllerAnimated(true)
        }else{
            textView.resignFirstResponder()
        }
    }
    
    @IBAction func saveNote(sender : AnyObject?){
        if !isEdited{
            return
        }
        let managedObjectContext = AppDelegate.sharedAppDelegate.managedObjectContext
        let curDate = NSDate()
        if let curNote = note{
            if textView.attributedText.length > 0 {
                curNote.content = textView.attributedText
                curNote.title = extractTitle()
                curNote.updated_at = curDate
                curNote.thumbnail_url = textView.attributedText.getFirstAttachment()?.imageName
            }else{
                notebook.deleteNote(curNote)
                note = nil
            }
            if let _ = try? managedObjectContext.save(){
                if note == nil{
                    delegate?.noteDeleted(curNote)
                }else{
                    delegate?.noteUpdated(curNote)
                }
            }
        }else if textView.attributedText.length > 0{
            let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedObjectContext)
            let newNote = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext) as! Note
            newNote.content = self.textView.attributedText
            newNote.title = extractTitle()
            newNote.created_at = curDate
            newNote.updated_at = curDate
            newNote.in_notebook = notebook
            newNote.thumbnail_url = textView.attributedText.getFirstAttachment()?.imageName
            notebook.addNote(newNote)
            if let _ = try? managedObjectContext.save(){
                note = newNote
                delegate?.noteCreated(newNote)
            }
        }
    }
    
    @IBAction func deleteNote(sender : AnyObject){
        if let curNote = note{
            let context = AppDelegate.sharedAppDelegate.managedObjectContext
            notebook.deleteNote(curNote)
            if let _ = try? context.save(){
                delegate?.noteDeleted(curNote)
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    @IBAction func createNewNote(sender: AnyObject) {
        note = nil
        textView.text = ""
        isEdited = true //in this case, we dun wanna go back to previous page
        textView.becomeFirstResponder()
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func keyboardWillShow(notification : NSNotification){
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject>, keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(){
            kbHeight = keyboardRect.size.height
            textViewBottomConstraint.constant = keyboardRect.size.height
            UIView.animateWithDuration(0.25, animations: { 
                self.showAdditionalButtonsBottomPadding.constant = keyboardRect.size.height + 5
                self.showAdditionalButtons.hidden = false
                self.view.layoutIfNeeded()
            })
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            self.deleteNoteIcon.hidden = true
            self.newNoteIcon.hidden = true
            self.buttonPaneView.paddingRight = 50
            if !CGAffineTransformIsIdentity(self.showAdditionalButtons.transform){//actions shown on top of keyboard and update only if it is already show demand
                showActionPaneOnKeyboard(true)
            }
        }
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    @IBAction func keyboardWillHide(notification : NSNotification){
        textViewBottomConstraint.constant = 0
        kbHeight = 0
        self.buttonPaneViewBottomPadding.constant = 0
        self.showAdditionalButtons.hidden = true
        self.buttonPaneView.paddingRight = 0
        self.deleteNoteIcon.hidden = false
        self.newNoteIcon.hidden = false
        self.buttonPaneView.paddingRight = 0
        self.showAdditionalButtons.transform = CGAffineTransformIdentity
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
        drawingVC.delegate = self
        presentViewController(drawingVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActionPaneOnKeyboard(show : Bool) {
        if show{
            self.buttonPaneViewBottomPadding.constant = self.kbHeight-self.buttonPaneView.bounds.size.height
            UIView.animateWithDuration(0.25, animations: {
                self.showAdditionalButtons.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(-45.0/180*M_PI))
                self.buttonPaneViewBottomPadding.constant = self.kbHeight
                self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    self.buttonPaneView.updateView()
            })
        }else{
            UIView.animateWithDuration(0.25, animations: {
                self.showAdditionalButtons.transform = CGAffineTransformIdentity
                self.buttonPaneViewBottomPadding.constant = self.kbHeight-self.buttonPaneView.bounds.size.height
                self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    self.buttonPaneViewBottomPadding.constant = 0
                    self.buttonPaneView.updateView()
            })
        }
    }
    
    @IBAction func showAdditionButtonClicked(sender: UIButton) {
        showActionPaneOnKeyboard(CGAffineTransformIsIdentity(sender.transform))
    }
}

extension NoteViewController: DrawingViewControllerDelegate{
    func drawingViewControllerWillClose(drawingViewController: DrawingViewController) {
        if drawingViewController.drawingPane.isDirty{
            var selectedRange = self.textView.selectedRange
            if drawingViewController.attachmentRange != nil{
                selectedRange = drawingViewController.attachmentRange!
                if let prevAttachment = drawingViewController.drawingImageName{
                    CommonHelper.deletePhotoWithName(prevAttachment)
                }
            }
            if let drawingAttachment = addImageToTextView(drawingViewController.drawingImage, atRange: selectedRange, attachmentClass: NoteDrawingAttachment.self) as? NoteDrawingAttachment{
                drawingAttachment.drawingBounds = drawingViewController.drawingBounds
                drawingAttachment.canvasSize = drawingViewController.drawingPane.getCanvasSize()
            }
        }
    }
}

extension NoteViewController: UIImagePickerControllerDelegate{
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)?.normalizeOrientation()
//        let resizedImage = selectedImage?.imageWithMaxWidth(self.textView.bounds.size.width)
        addImageToTextView(selectedImage, atRange: self.textView.selectedRange)
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension NoteViewController :  UITextViewDelegate{
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        isEdited = true
        if let allAttachments = textView.attributedText.getAllAttachmentsInRange(range){
            for curAttachment in allAttachments{
                CommonHelper.deletePhotoWithName(curAttachment.imageName)
            }
        }
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        print("SelectedRange \(textView.selectedRange)")
    }
    
    func getAttachmentForSelectedPosition(selPosition : Int) -> (NoteTextAttachment, NSRange)?{
        var longestRange = NSRange()
        let posOfInterest = max(min(selPosition, textView.attributedText.length-1),0)
        let attribDict = self.textView.attributedText.attributesAtIndex(posOfInterest, longestEffectiveRange:&longestRange, inRange: NSMakeRange(0,self.textView.attributedText.length))
        if let attachment = attribDict[NSAttachmentAttributeName] as? NoteTextAttachment{
            if longestRange.location > 0{
                longestRange.location -= 1
                longestRange.length += 2
            }else{
                longestRange.length += 1
            }
            return (attachment,longestRange)
        }
        return nil
    }
    
    func searchAttachmentNearPosition(selPosition : Int) -> (NoteTextAttachment, NSRange)?{
        if let attachment = getAttachmentForSelectedPosition(selPosition){
            return attachment
        }
        return getAttachmentForSelectedPosition(selPosition-1)
    }
}

extension NoteViewController : UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapGestureRecognizer || otherGestureRecognizer == tapGestureRecognizer{
            return true
        }
        return false
    }
    
    @IBAction func textViewTouched(sender: UITapGestureRecognizer) {
        let posInTextView = sender.locationInView(textView)
        if let textPos = textView.closestPositionToPoint(posInTextView){
            let startIndex = textView.offsetFromPosition(textView.beginningOfDocument, toPosition: textPos)
            print("startIndex \(startIndex)")
            if let (textAttachment,attachmentRange) = searchAttachmentNearPosition(startIndex) where textAttachment.imageName != nil{
                textView.resignFirstResponder()
                if let photoDocumentPath = CommonHelper.getPhotoFolder(){
                    if let imageData = NSData(contentsOfFile: photoDocumentPath + "/" + textAttachment.imageName!), curImage = UIImage(data: imageData){
                        if let drawingAttachment = textAttachment as? NoteDrawingAttachment{
                            let drawingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DrawingViewController") as! DrawingViewController
                            drawingVC.drawingImage = curImage
                            drawingVC.delegate = self
                            drawingVC.attachmentRange = attachmentRange
                            drawingVC.drawingImageName = textAttachment.imageName
                            drawingVC.drawingBounds = drawingAttachment.drawingBounds
                            drawingVC.prevCanvasSize = drawingAttachment.canvasSize
                            presentViewController(drawingVC, animated: true, completion: nil)
                        }else{
                            let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
                            photoVC.image = curImage
                            presentViewController(photoVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}

