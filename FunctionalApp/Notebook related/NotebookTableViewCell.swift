//
//  NotebookTableViewCell.swift
//  FunctionalApp
//
//  Created by Pyae Phyo Myint Soe on 14/3/16.
//  Copyright © 2016 PYAE PHYO MYINT SOE. All rights reserved.
//

import UIKit

class NotebookTableViewCell: UITableViewCell {
    var notebook : Notebook?{
        didSet{
            self.textLabel?.text = notebook?.name
//            detailTextLabel?.text = "\(notebook?.notes == nil ? 0 : notebook!.notes!.count)"
            //instead of counting every time, u easily can do this in case calling notes! will load the records that may not be needed
            detailTextLabel?.text = "\(notebook?.numberOfNotes == nil ? 0 : notebook!.numberOfNotes!.intValue)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
