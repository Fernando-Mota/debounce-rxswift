//
//  File.swift
//  DebounceExample
//
//  Created by Fernando Mota e Silva on 23/04/18.
//  Copyright © 2018 Fernando Mota e Silva. All rights reserved.
//

import Foundation


class NameRepository {
    
    private let db = DB()
    
    func findByName(name: String) -> [String] {
        return db.nameData.filter { (value) -> Bool in
            name.contains(name)
        }
    }
}
