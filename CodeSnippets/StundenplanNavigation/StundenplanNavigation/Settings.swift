//
//  Settings.swift
//  StundenplanNavigation
//
//  Created by Daniel Zizer on 21.11.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit

enum Season : String {
    case summer = "SS"
    case winter = "WS"
}

class Settings: NSObject {

    static let sharedInstance = Settings()
    private override init(){}
    
    required init?(coder aDecoder: NSCoder) {
        savedSsws = aDecoder.decodeObject(forKey: "settings_SavedSsws") as! Season
        savedCourses = aDecoder.decodeObject(forKey: "settings_SavedCourses") as! Courses
        savedSchedule = aDecoder.decodeObject(forKey: "settings_SavedSchedule") as! Schedule
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encode(savedSsws, forKey:"settings_SavedSsws")
        aCoder.encode(savedCourses, forKey:"settings_SavedCourses")
        aCoder.encode(savedSchedule, forKey:"settings_SavedSchedule")
    }
    
    //Temporäre Daten
    private var _tmpSsws: Season = .summer
    var tmpCourses: Courses = Courses()
    var tmpSchedule: Schedule = Schedule()
    
    //Gespeicherte Daten
    private var savedSsws: Season = .summer
    var savedCourses: Courses = Courses()
    var savedSchedule: Schedule = Schedule()
    var savedChanges: Changes = Changes()
    
    var tmpSeason: Season {
        get {
            return _tmpSsws
        }
        set {
            if(newValue != _tmpSsws){
                _tmpSsws = newValue
                tmpCourses = Courses()
                tmpSchedule = Schedule()
            }
        }
    }
    
    //Vergleich der gewählten Vorlesungen mit Änderungen
    func compareScheduleAndChanges(){
        print("Compare Schedule and Changes")
        savedSchedule.extractSelectedLectures()
        let newSavedChanges = Changes()
        for changedLecture in savedChanges.changes{
            for lecture in savedSchedule.selLectures{
                if(changedLecture.name == lecture.name){
                    newSavedChanges.addChanges(cl: [changedLecture])
                    print(newSavedChanges.changes.description)
                }
            }
        }
        savedChanges.changes.removeAll()
        savedChanges.addChanges(cl: newSavedChanges.changes)
    }
    
    //Daten aus saved in tmp laden
    func copyData(){
        _tmpSsws = savedSsws
        tmpCourses = savedCourses.copy() as! Courses
        tmpSchedule = savedSchedule.copy() as! Schedule
    }
    
    //Daten von tmp in saved übernehmen
    func commitChanges() {
        savedSsws = _tmpSsws
        savedCourses = tmpCourses.copy() as! Courses
        savedSchedule = tmpSchedule.copy() as! Schedule
    }
    
//    func discardChanges(){
//        _tmpSsws = .summer
//        tmpCourses = Courses()
//        tmpSchedule = Schedule()
//    }
    
    func countChanges() -> Int{
        
//        dump(_savedSchedule.removedLectures(schedule: tmpSchedule))
        let deleted = savedSchedule.removedLectures(schedule: tmpSchedule).count
//        print("--------------------------")
//        dump(_savedSchedule.addedLectures(schedule: tmpSchedule))
        let added = savedSchedule.addedLectures(schedule: tmpSchedule).count
//        print ("\(deleted)\(added)")
        return deleted + added
    }
}

