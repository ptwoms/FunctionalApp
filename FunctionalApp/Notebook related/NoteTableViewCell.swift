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
    
    var note : Note?{
        didSet{
            noteTitle.text = note?.title
            noteUpdatedTime.text = "\(note?.updated_at)"
            noteDescription.text = ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
