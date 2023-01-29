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
            listener?(value)
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

struct User: Codable {
    let name: String
}
// ViewModel

struct UserListViewModel {
    var users: Observable<[UserTableViewCellViewModel]> = Observable([])
}

struct UserTableViewCellViewModel {
    let name: String
}
// Controller

class ViewController: UIViewController, UITableViewDataSource {
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var viewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
//        tableView.delegate = self
        
        viewModel.users.bind { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        fetchData()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let userModels = try JSONDecoder().decode([User].self, from: data)
                
                self.viewModel.users.value = userModels.compactMap({
                    UserTableViewCellViewModel(name: $0.name)
                })
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.users.value?[indexPath.row].name
        return cell
    }

}

