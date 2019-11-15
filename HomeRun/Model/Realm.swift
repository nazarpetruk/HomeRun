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
    
    dynamic public private(set) var id = ""
    dynamic public private(set) var pace = 0
    dynamic public private(set) var distance = 0.0
    dynamic public private(set) var duration = 0
    dynamic public private(set) var date = NSDate()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace : Int, distance : Double, duration : Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
    }
    
    static func addFinishedRun(pace : Int, distance : Double, duration : Int) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distance, duration: duration)
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
