//
//  AllLectures.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 03.06.17.
//  Copyright © 2017 Jonas Beetz. All rights reserved.
//

import UIKit

class AllLectures: NSObject {

    fileprivate var serverData = ServerData.sharedInstance
    
    func numberOfEntries(for section : Int) -> Int
    {
        return serverData.schedule.daySize(at: section)
    }
    
    func getElement(at indexPath : IndexPath) -> Lecture
    {
        return serverData.schedule.lecture(at: indexPath)
    }
    
    func getLectures() -> [[Lecture]] {
        return serverData.schedule.lectures
    }
    
    func append(lectures : [Lecture]) {
        for lec in lectures{
            let dayIndex = Constants.weekDays.index(of: lec.day)!
            serverData.schedule.add(lecture: lec, at: dayIndex)
        }
    }
    
    func clear() {
        serverData.schedule.clear()
    }
}