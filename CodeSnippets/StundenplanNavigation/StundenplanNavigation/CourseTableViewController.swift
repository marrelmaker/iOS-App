//
//  CourseTableViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 18.10.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {

    @IBOutlet var courseTableView: UITableView!
    var datasource : CourseTableViewDataSource!
    var delegate: CourseTableViewDelegate!
    var courseController: CourseController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        datasource = CourseTableViewDataSource()
        delegate = CourseTableViewDelegate()
        
        tableView.dataSource = datasource
        tableView.delegate = delegate
        
        courseController = CourseController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadEnded), name: Notification.Name("DownloadEnded"), object: nil )
    }
    
    func downloadEnded(){
        self.courseTableView.reloadData()
    }
    
    func showNoInternetAlert(){
    
        let alertController = UIAlertController(title: "Internetverbindung fehlgeschlagen", message:
            "Bitte verbinden Sie sich mit dem Internet", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            //Daten erneut laden
        } ))
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.tintColor = UIColor.hawRed
        courseController.loadAllCourses()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(Notification.Name("DownloadEnded"))
        courseController.cancelLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
