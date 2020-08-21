//
//  Record.swift
//  respawn
//
//  Created by Ixchel on 19/08/20.
//  Copyright © 2020 flakeystories. All rights reserved.
//

import Foundation
import SQLite3

struct Record {
    var id: Int32
    var date: String
    var duration: Int64
}

class RecordManager {
    var database: OpaquePointer?
    
    static let shared = RecordManager()
    
    private init() {}
    
    func connect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("records.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS records (
                datetime TEXT, duration INT

            )
            """,
            nil,
            nil,
            nil
            ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    func create(record:Record) -> () {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO records (datetime, duration) VALUES (?,?)",
            -1,
            &statement,
            nil
            ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: record.date).utf8String,-1,nil)
            sqlite3_bind_int64(statement, 2, record.duration)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error creating record")
            }
        }
        else {
            print("Error creating record insert statement")
        }
        
        sqlite3_finalize(statement)
    }
    func getTodays(today:String) -> Int32 {
        connect()
        // today calculation
        var result : Int32 = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT SUM(duration) FROM records WHERE datetime = ?", -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, today,-1,nil)
            while sqlite3_step(statement) == SQLITE_ROW {
                result = sqlite3_column_int(statement, 0)
            }
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func getThisMonth(thismonth:String) -> Int32 {
        connect()
    
        // this month calculation
        var result : Int32 = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT SUM(duration) FROM records WHERE datetime LIKE ?", -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, "\(thismonth)%",-1,nil)
            while sqlite3_step(statement) == SQLITE_ROW {
                result = sqlite3_column_int(statement, 0)
            }
        }
        sqlite3_finalize(statement)
        return result
    }
    
    func getTotal() -> Int32 {
        connect()
        // total records calculation
        var result : Int32 = 0
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT SUM(duration) FROM records", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result = sqlite3_column_int(statement, 0)
            }
        }
        sqlite3_finalize(statement)
        return result
    }
}
