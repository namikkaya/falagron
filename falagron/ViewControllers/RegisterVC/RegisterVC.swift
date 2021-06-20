//
//  RegisterVC.swift
//  falagron
//
//  Created by namik kaya on 9.04.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:RegisterViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegisterViewModel(type: "hele")
        addClosureListener()
    }
    
    private func setupTableView() {
        let cells = [UITableViewCell.self]
        self.tableView.register(cellTypes: cells)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = .clear
        self.tableView.keyboardDismissMode = .onDrag
    }
}

extension RegisterVC {
    private func addClosureListener() {
        viewModel?.reloadViewClosure = { [weak self]  in
            DispatchQueue.main.async {
                
            }
        }
    }
}

extension RegisterVC {
    
}

extension RegisterVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
