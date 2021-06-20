//
//  ProfileViewController.swift
//  falagron
//
//  Created by namik kaya on 21.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    private var viewModel:ProfileViewModel?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    var menuButton:UIButton?
    
    @IBOutlet private weak var updateButton: KYSpinnerButton! {
        didSet {
            updateButton.addDropShadow(cornerRadius: 8,
                                       shadowRadius: 0,
                                       shadowOpacity: 0,
                                       shadowColor: .clear,
                                       shadowOffset: .zero)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel = ProfileViewModel(test1: "")
        addClosureListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        menuButton = addGetMenuButton()
        menuButton?.addTarget(self, action: #selector(menuButtonEvent(_:)), for: .touchUpInside)
        self.setNavigationBarTitle(titleText: "Fallarım")
        self.tableView.isUserInteractionEnabled = true
        reloadTableView()
        addKeyboardListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.loading()
        viewModel?.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardListener()
    }
    
    @objc private func menuButtonEvent(_ sender:UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    override func menuDisplayChange(status: MenuDisplayStatus) {
        super.menuDisplayChange(status: status)
        switch status {
        case .ON:
            self.tableView.isUserInteractionEnabled = false
            break
        case .OFF:
            self.tableView.isUserInteractionEnabled = true
            break
        }
    }
    
    private func setupTableView() {
        let cells = [UITableViewCell.self, UnchangeableCell.self, ChangeableCell.self, loadingCell.self]
        self.tableView.register(cellTypes: cells)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = .clear
        self.tableView.keyboardDismissMode = .onDrag
        reloadTableView()
    }
    
    
    @IBAction func updateButtonEvent(_ sender: Any) {
        self.view.endEditing(true)
        self.tableView.isUserInteractionEnabled = false
        updateButton.setStatus = .processing
        viewModel?.sendService()
    }
}

// MARK: - NavigationController Button
extension ProfileViewController {
    private func addGetMenuButton() -> UIButton  {
        let leftMenuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        leftMenuButton.setImage(UIImage(named: "menuIcon"), for: .normal)
        let barButton = UIBarButtonItem(customView: leftMenuButton)
        let width = barButton.customView?.widthAnchor.constraint(equalToConstant: 18)
        width?.isActive = true
        let height = barButton.customView?.heightAnchor.constraint(equalToConstant: 18)
        height?.isActive = true
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        return leftMenuButton
    }
}

extension ProfileViewController {
    private func addClosureListener() {
        viewModel?.reloadViewClosure = { [weak self] in
            self?.reloadTableView()
        }
        
        viewModel?.sendDataClosure = { [weak self] status, error in
            self?.updateButton.setStatus = .normal
            self?.tableView.isUserInteractionEnabled = true
            if status {
                self?.infoMessage(message: "İşlem başarı ile gerçekleşti", buttonTitle: "Tamam")
            }else {
                self?.infoMessage(message: "Bir hata oluştu. İşlem gerçekleştirilemedi!", buttonTitle: "Tamam")
            }
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.numberOfRowsInSection(section: section) else { return 0 }
        return count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = viewModel?.getCell(tableView: tableView, indexPath: indexPath) {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension ProfileViewController {
    private func addKeyboardListener () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardListener() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(with notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.bottomConstraint.constant = -keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(with notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}
