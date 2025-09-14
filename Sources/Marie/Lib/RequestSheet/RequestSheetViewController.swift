//
//  RequestSheetViewController.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 14/04/23.
//

import UIKit

public final class RequestSheetViewController: UIViewController {
    
    private var viewModel: RequestSheetViewModelProtocol
    private let mainView: RequestSheetView = .init()
    private var phonewavesButton: UIBarButtonItem?
    
    init(viewModel: RequestSheetViewModelProtocol = RequestSheetViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        mainView.tableView.estimatedRowHeight = 160
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(RequestSheetTableViewCell.self, forCellReuseIdentifier: RequestSheetTableViewCell.reuseId)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        mainView.tableView.layoutSubviews()
    }
    
    private func setupNavigationController() {
        phonewavesButton = UIBarButtonItem(image: .phonewavesIcon, style: .plain, target: self, action: #selector(phonewavesAction))
        phonewavesButton?.tintColor = ImpactController.isEnable ? .primaryTextColor : .gray
        
        navigationItem.rightBarButtonItems = [phonewavesButton ?? UIBarButtonItem() ]
        
        let closeButton = UIBarButtonItem(image: .xMarkIcon, style: .plain, target: self, action: #selector(closeButtonAction))
        closeButton.tintColor = .primaryTextColor
        
        let leftButton = UIBarButtonItem(image: .trashIcon, style: .plain, target: self, action: #selector(cleanButtonAction))
        leftButton.tintColor = .primaryTextColor
        navigationItem.leftBarButtonItems = [closeButton, leftButton]
    }
    
    @objc
    private func phonewavesAction() {
        ImpactController.isEnable.toggle()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.phonewavesButton?.tintColor = ImpactController.isEnable ? .primaryTextColor : .gray
        }
    }
    
    @objc
    private func cleanButtonAction() {
        LogManager.shared.clean()
    }
    
    @objc
    private func closeButtonAction() {
        self.dismiss(animated: true)
    }
    
}

extension RequestSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LogManager.shared.requestsLog.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RequestSheetTableViewCell.reuseId, for: indexPath) as? RequestSheetTableViewCell else { return UITableViewCell() }
        let log = LogManager.shared.requestsLog[indexPath.row]
        cell.setup(logModel: log)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = LogManager.shared.requestsLog[indexPath.row]
        let viewModel = RequestDetailViewModel(log: log)
        let viewController = RequestDetailViewController(viewModel: viewModel)
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RequestSheetViewController: RequestSheetViewModelDelegate {
    
    func didLogChange() {
        mainView.tableView.reloadData()
    }
    
}
