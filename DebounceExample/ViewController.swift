//
//  ViewController.swift
//  DebounceExample
//
//  Created by Fernando Mota e Silva on 23/04/18.
//  Copyright © 2018 Fernando Mota e Silva. All rights reserved.
//

import UIKit
//MARK: 1
import RxCocoa
import RxSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var loadingHolder: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    
    //MARK: 2
    private let repository = NameRepository()
    
    private let names = Variable<[String]>([])
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViews()
        
    }
    
    func bindViews() {
        //MARK: 3
        search.rx.text
            .orEmpty
            .filter { value in
                return !value.isEmpty
            }
            .debounce(1.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .do(onNext: { (value) in
                self.turnLoadingOn()
            })
            .subscribe(onNext: { [weak self] query in
                self?.updateData(nameRestriction: query)
            })
            .disposed(by: bag)

        names.asObservable().bind(to: table.rx.items(cellIdentifier: "celula")) { (row, name, cell) in
            cell.textLabel?.text = name
        }.disposed(by: bag)
        
        repository.observableData
            .subscribe(onNext: { [weak self] value in
                self?.names.value = value
                self?.turnLoadingOff()
            }).disposed(by: bag)
    }
    
    func updateData(nameRestriction: String) {
        repository.findByName(name: nameRestriction)
    }
}

extension ViewController {
    
    func turnLoadingOn() {
        UIView.animate(withDuration: 0.5) {
            self.loadingHolder.alpha = 1.0
            self.loadingIndicator.alpha = 1.0
            self.loadingIndicator.startAnimating()
        }
    }
    
    func turnLoadingOff() {
        UIView.animate(withDuration: 0.5) {
            self.loadingHolder.alpha = 0
            self.loadingIndicator.alpha = 1.0
            self.loadingIndicator.stopAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        repository.closeConnection()
    }
}


