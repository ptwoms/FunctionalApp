//
//  NoteTableViewCell.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 15/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteUpdatedTime: UILabel!
    @IBOutlet weak var noteDescription: UILabel!
    @IBOutlet weak var notePreviewImage: UIImageView!
    @IBOutlet weak var imageWidth : NSLayoutConstraint!
    
    var note : Note?{
        didSet{
            noteTitle.text = note?.title
            noteUpdatedTime.text = note?.updated_at != nil ? note!.updated_at!.getPastDateString() : ""
            noteDescription.text = ""
            if let thumbnailImageName = note?.thumbnail_url, imageToShow = CommonHelper.getThumbnailPhotoWithName(thumbnailImageName){
                imageWidth.constant = GlobalConstants.noteThumbnailSize
                notePreviewImage.image = imageToShow
            }else{
                imageWidth.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notePreviewImage.contentMode = .Center
        notePreviewImage.clipsToBounds = true
        notePreviewImage.roundCorner(5)
        editingAccessoryType = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
