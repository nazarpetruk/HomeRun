//
//  Realm.swift
//  HomeRun
//
//  Created by Nazar Petruk on 14/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import Foundation
import RealmSwift

class Run : Object{
    
    @objc dynamic var id = ""
    
    @objc dynamic var pace = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var duration = 0
    @objc dynamic var date = NSDate()
    var locations = List<Location>()

    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace : Int, distance : Double, duration : Int, locations: List<Location>) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    static func addFinishedRun(pace : Int, distance : Double, duration : Int, locations : List<Location>) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distance, duration: duration, locations : locations)
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(run)
                        try realm.commitWrite()
                    }
                }catch{
                    debugPrint("Error in run adding")
                }
            }
        }
    
    static func getRuns() -> Results<Run>? {
        do {
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }catch{
            return nil
        }
    }
}
