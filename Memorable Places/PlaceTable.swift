//
//  TableObj.swift
//  ToDoList
//
//  Created by YCS on 28/3/15.
//  Copyright (c) 2015 ycswaves. All rights reserved.
//

import UIKit

class PlaceTable {
    private var userPlaces = [Dictionary<String, String>()]
    private let storeKey = "toDoList"
    
    init() {
        if NSUserDefaults.standardUserDefaults().objectForKey(storeKey) != nil {
            userPlaces = NSUserDefaults.standardUserDefaults().objectForKey(storeKey) as [Dictionary<String, String>]
        }
    }
    
    func getTotal() -> Int {
        return userPlaces.count
    }
    
    func getItem(index: Int) -> Dictionary<String, String> {
        return userPlaces[index]
    }
    
    func addItem(item: Dictionary<String, String>) {
        userPlaces.append(item)
        updatePermStorage();
    }
    
    func removeItem(index: Int) {
        userPlaces.removeAtIndex(index)
        updatePermStorage();
    }
    
    private func updatePermStorage() {
        NSUserDefaults.standardUserDefaults().setObject(userPlaces, forKey: storeKey) //update permanent storage
    }
}
