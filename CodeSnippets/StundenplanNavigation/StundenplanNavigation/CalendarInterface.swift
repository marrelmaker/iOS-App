//
//  CalendarInterface.swift
//  StundenplanNavigation
//
//  Created by Daniel on 13.12.16.
//  Copyright © 2016 Jonas Beetz. All rights reserved.
//

import UIKit
import EventKit

class CalendarInterface: NSObject {
    
    static var sharedInstance = CalendarInterface()
    
    var calendar : EKCalendar? = nil
    var eventStore : EKEventStore!
    var pending : DispatchSemaphore!
    
    private override init() {
        super.init()
        pending = DispatchSemaphore(value: 1)
        eventStore = EKEventStore()
        if (checkCalendarAuthorizationStatus()) {
            createCalenderIfNeeded()
        }
    }
    
    // Löschen eines Kalenders
    func removeCalendar() -> Bool {
        do {
            try self.eventStore.removeCalendar(self.calendar!, commit: true)
        } catch {
            return false
        }
        return true
    }
    
    // Check ob App-Calender schon vorhanden ist
    private func isAppCalenderAvailable() -> Bool
    {
        var calendars = [EKCalendar]()
        calendars = self.eventStore.calendars(for: .event)
        for calendar in calendars {
            if(calendar.title == Constants.calendarTitle){
                self.calendar = calendar
                return true
            }
        }
        return false
    }
    
    private func createCalenderIfNeeded()
    {
        if (!isAppCalenderAvailable()) {
            createCalender()
        }
        
    }
    
    public func createNewCalender() {
        createCalenderIfNeeded()
    }
    
    // Erstellen eines Kalenders
    private func createCalender(){
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        
        newCalendar.title = Constants.calendarTitle
        
        newCalendar.source = eventStore.defaultCalendarForNewEvents.source
        do {
            try self.eventStore.saveCalendar(newCalendar, commit: true)
            self.calendar = newCalendar
        } catch {
        }
        createAllEvents(lectures: Settings.sharedInstance.savedSchedule.selLectures)
    }
    
    // Berechtigungen für den Kalenderzugriff anfragen
    private func requestAccessToCalendar (){
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            self.eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.pending.signal()
            })
        }
    }
    
    // Abfrage der Kalenderberechtigungen
    public func checkCalendarAuthorizationStatus() -> Bool{
        var result = false
        var status :  EKAuthorizationStatus
        repeat {
            status = EKEventStore.authorizationStatus(for: EKEntityType.event)
            switch (status) {
            case EKAuthorizationStatus.notDetermined:
                pending.wait()
                requestAccessToCalendar()
            case EKAuthorizationStatus.authorized:
                result = true
            case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
                result = false
            }} while (status == EKAuthorizationStatus.notDetermined)
        return result
        
    }
    
    // Erzeugt für alle übergebenen Lectures EkEvents und schreibt diese in den Kalender
    public func createAllEvents(lectures : [Lecture]){
        if (checkCalendarAuthorizationStatus()) {
            createCalenderIfNeeded()
            for lecture in lectures{
                CalendarController().createEventsForLecture(lecture: lecture, calendar: calendar! , eventStore: eventStore)
            }
        }
    }
                
    // Aktualisiert Werte des übergebenem Events
    func updateEvent(change : ChangedLecture) {
        let lecture = CalendarController().findLecture(change: change)
        
        let eventID = CalendarController().findEventId(lecture: lecture, change: change, eventStore: eventStore)
        
        let event = self.eventStore.event(withIdentifier: eventID)
        
        if((event) != nil) {
            if (change.newDay != "") {
                if (event?.startDate != change.newDate) {
                    let newEvent = EKEvent(eventStore: self.eventStore)
                    
                    newEvent.title     = "[NEU] " + change.name
                    newEvent.notes     = event?.notes
                    newEvent.startDate = change.newDate!
                    newEvent.endDate   = (newEvent.startDate + 60 * 90)
                    
                    newEvent.location = CalendarController().getLocationInfo(room: lecture.room) + " ," + lecture.room.appending(", \(change.newRoom)")
                   
                    newEvent.calendar  = self.calendar!
                    newEvent.notes = lecture.comment + "  " + lecture.group
                    
                    CalendarController().createEvent(p_event: newEvent , lecture: lecture, eventStore: eventStore, calendar: calendar!)
                    
                    event?.title    = Constants.changesChanged + change.name
                    event?.location = nil
                    event?.alarms   = []
                } else {
                    event?.title     = Constants.changesRoomChanged + change.name
                    
                    event?.location = CalendarController().getLocationInfo(room: lecture.room).appending(", \(change.newRoom)")
                    
                }
            } else {
                event?.title     = Constants.changesFailed + change.name
                event?.location = nil
                event?.alarms   = []
            }
            
            event?.calendar  = self.calendar!;
        }
        if((event) != nil) {
            do {
                try self.eventStore.save(event!, span: .thisEvent)
            } catch {
                print("Fehler beim Updaten eines Events")
            }
        }
    }
    
    //Entfernt übergebenes Event
    func removeEvent(p_eventId: String, p_withNotes: Bool?=false)-> Bool{
        let eventToRemove = self.eventStore.event(withIdentifier: p_eventId)
        if (eventToRemove != nil) {
            if (p_withNotes == false && eventToRemove?.notes != nil){ return false }
            do {
                try self.eventStore.remove(eventToRemove!, span: .thisEvent)
                return true
            } catch {
                print("Events konnte nicht gelöscht werden")
            }
        }
        return false
    }
}



