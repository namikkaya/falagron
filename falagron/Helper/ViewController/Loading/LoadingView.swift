//
//  LoadingView.swift
//  falagron
//
//  Created by namik kaya on 6.03.2021.
//  Copyright © 2021 namik kaya. All rights reserved.
//

import UIKit

protocol LoadingDisplayDelegate {
    var simpleDescription: String { get }
    mutating func adjust()
}

enum LoadingDisplay: LoadingDisplayDelegate {
    case defaultDisplay
    
    var simpleDescription: String {
        return ""
    }
    
    mutating func adjust() {
        self = LoadingDisplay.defaultDisplay
    }
}

let loadingTransition = LoadingTransition()

final class LoadingManager {
    enum LoadingStatus {
        case start
        case stop
    }
    
    var status: LoadingStatus?
    var rootVC:UIViewController?
    var loadingVC:LoadingView?
    init(target:UIViewController) {
        self.rootVC = target
    }
    
    func start() {
        guard let rootVC = rootVC else { return }
        let storyBoard = UIStoryboard(name: "Loading", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "LoadingView") as? LoadingView {
            vc.modalPresentationStyle = .overFullScreen
            vc.transitioningDelegate = loadingTransition
            loadingVC = vc
            DispatchQueue.main.async {
                rootVC.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func stop() {
        //guard loadingVC != nil else { return }
        //loadingVC?.dismiss(animated: true, completion: nil)
        loadingVC?.stop()
    }
    
    deinit {
        if loadingVC != nil {
            loadingVC?.dismiss(animated: false, completion: nil)
            loadingVC = nil
        }
        if rootVC != nil {
            rootVC = nil
        }
    }
}

class LoadingView: UIViewController {
    
    enum DisplayStatus {
        case start
        case stop
    }

    @IBOutlet private weak var containerView: UIView!{
        didSet {
            containerView.isHidden = true
            containerView.alpha = 0
        }
    }
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    var status: DisplayStatus?
    
    var viewModel:LoadingViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.alpha = 0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewModel = LoadingViewModel(containerView: containerView, indicator: indicator, delegate: self)
        status = (status == nil && status == .stop) ? .start : .stop
        if status == .stop {
            stop()
        }else {
            start()
        }
    }
    
    func start() {
        status = .start
        viewModel?.startLoading()
    }
    
    func stop() {
        status = .stop
        viewModel?.stopLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension LoadingView:LoadingViewModelDelegate {
    func stopFinishComplete() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func startFinishComplete() {
        
    }
}
