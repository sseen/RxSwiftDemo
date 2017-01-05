//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by sseen on 2017/1/3.
//  Copyright © 2017年 sseen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var disposeBag = DisposeBag()
    
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar
            .rx.text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter{ ($0?.characters.count)! > 0 }
            .distinctUntilChanged{ $0 == $1 }
            .subscribe(onNext:{
                [unowned self] (query) in // Here we will be notified of every new value
                self.shownCities = self.allCities.filter { $0.hasPrefix(query!) } // We now do our "API Request" to find cities.
                self.tableView.reloadData() // And reload table view data.
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath as IndexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
}

