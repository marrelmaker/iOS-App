//
//  Semesters.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 15.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

class Semesters : NSObject, NSCopying, NSCoding{

    var list : [Semester] = []
    let listKey = "SemestersList"
    
    override init() {}
    
    init(semesters: [Semester]) {
        for semester in semesters{
            self.list.append(semester.copy() as! Semester)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        list = aDecoder.decodeObject(forKey: listKey) as! [Semester]
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(list, forKey: listKey)
    }
    
    func toggleSemesterAt(index: Int){
        if(list[index].selected){
            list[index].selected = false
        }else{
            list[index].selected = true
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Semesters(semesters: self.list)
        return copy
    }
    
    func setSelektion(semesters : Semesters){
        
        
        for semester in semesters.list{
            if (semester.selected){
                for localsem in list{
                    if localsem.equal(compareTo: semester){
                        localsem.selected = semester.selected
                    }
                }
            }
        }
    }
    
    func isSelected(index: Int) -> Bool{
        return list[index].selected
    }
    
    //Liefert alle selektierten Semester
    func selectedSemesters() -> [Semester]{
        var selectedSemesters : [Semester] = []
        
        for sem in list{
            if (sem.selected){
                selectedSemesters.append(sem)
            }
        }
        
        return selectedSemesters
    }

}
