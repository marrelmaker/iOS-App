//
//  ScheduleChangesTableViewDelegate.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 08.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class ScheduleChangesTableViewDelegate: NSObject, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
////        header.contentView.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
////        header.textLabel?.textColor = UIColor.hawYellow
////        header.contentView.backgroundColor = UIColor.hawYellow
////        header.textLabel?.textColor = UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 0.9)
////        header.textLabel?.textColor = UIColor
//        header.textLabel?.textAlignment = .center
//
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = appColor.headerText
            headerTitle.contentView.backgroundColor = appColor.headerBackground
            headerTitle.textLabel?.textAlignment = .center
        }
    }
}
