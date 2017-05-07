//
//  SemesterTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Sebastian Fuhrmann on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class SemesterTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
        header.textLabel?.textColor = UIColor.hawBlue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = SemesterController().toggleSemester(at: indexPath)
        tableView.reloadData()
    }
}
