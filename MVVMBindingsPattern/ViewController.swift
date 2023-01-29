//
//  ViewController.swift
//  MVVMBindingsPattern
//
//  Created by Владислав Белый on 26.01.2023.
//

import UIKit
  
// Observable

class Observable<T> {
    var value: T? {
        didSet {
            
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> ())?
    
    func bind(_ listener: @escaping (T?) -> ()) {
        listener(value)
        self.listener = listener
    }
}

// Model
// ViewModel
// Controller

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        }
}

