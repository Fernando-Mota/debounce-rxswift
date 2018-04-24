//
//  File.swift
//  DebounceExample
//
//  Created by Fernando Mota e Silva on 23/04/18.
//  Copyright © 2018 Fernando Mota e Silva. All rights reserved.
//

import UIKit
import RxSwift

class NameRepository {
    
    private let db = DB()
    
    private let dbSearchEngine = PublishSubject<[String]>()
    
    var observableData: Observable<[String]> {
        get {
            return dbSearchEngine.asObserver().delay(4, scheduler: MainScheduler.instance)
        }
    }
        
    func findByName(name: String) {
        dbSearchEngine.onNext(db.nameData.filter { (value) -> Bool in
            return value.contains(name)
        })
    }
    
    func closeConnection() {
        dbSearchEngine.onCompleted()
    }
}
