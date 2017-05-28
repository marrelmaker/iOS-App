//
//  PopUpMenueViewController.swift
//  StundenplanNavigation
//
//  Created by Jonas Beetz on 17.01.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class PopUpMenueViewController: UIViewController {
    
    
    var lecturesTableViewController : LecturesTableViewController!
    var lecturesDelegate: LecturesTableViewDelegate!
    


    func setMainViewController(lecturesTableViewController : LecturesTableViewController)
    {
    self.lecturesTableViewController = lecturesTableViewController
    }

    
    

    
    @IBOutlet var stroke: UIView!
    
    @IBAction func selectAllButton(_ sender: Any) {
        
       
        
        let list = ServerData.sharedInstance.schedule.allLectures

        for i in list {
            for j in i {
                //UserData.sharedInstance.selectedLectures.append(j)
                SelectedLectures().add(lecture: j)
            }
        }
            self.lecturesTableViewController.lectureTableView.reloadData()
        self.dismiss(animated: true) { 
            
        }
        
    }
    


    
    @IBAction func deSelectAll(_ sender: Any) {
                
       
                SelectedLectures().clear()
                
       
        self.lecturesTableViewController.lectureTableView.reloadData()
        self.dismiss(animated: true) {
            
        }

        
    }
    
    func setBorder(){
        self.view.layer.borderWidth = 1.0
        self.view.layer.borderColor = UIColor.hawBlue.cgColor
        self.view.layer.cornerRadius = 13.0;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stroke.backgroundColor = UIColor.hawBlue
               // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
