//
//  Task.swift
//  RealmSample
//
//  Created by 生井 智司 on 2015/08/25.
//  Copyright (c) 2015年 生井 智司. All rights reserved.
//

import Foundation
import RealmSwift

public class Task : Object {
    dynamic var id : Int = 0
    dynamic var title : String = ""
    dynamic var date : NSDate = NSDate()

    
    override static public func primaryKey () -> String {
        return "id"
    }

    public static func nextId () -> Int {
        let task = Realm().objects(Task)
        if task.count == 0 {
            return 1
        }
        return (task.max("id")! as Int) + 1
    }
}