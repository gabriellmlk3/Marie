//
//  RequestDetailViewController.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit
import Foundation

final class RequestDetailViewController: UIViewController {
    
    private var viewModel: RequestDetailViewModelProtocol
    private let mainView: RequestDetailView = .init()
    private var isFormatting = false
    
    private lazy var editModeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .pencilIcon, style: .plain, target: self, action: #selector(editModeButtonAction))
        button.tintColor = .gray
        return button
    }()
    
    private var oldscale: CGFloat = 0.0
    
    init(viewModel: RequestDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargets()
        mainView.setupView(with: viewModel.log)
//        mainView.responseView.textDelegate = self
        setupNavigationController()
        setJsonText()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            LogManager.shared.detach(viewModel)
        }
    }
    
    private func setupNavigationController() {
        let remakeRequestCallButton = UIBarButtonItem(image: .repeatIcon, style: .plain, target: self, action: #selector(remakeRequestCallAction))
        remakeRequestCallButton.tintColor = .primaryTextColor
        
        navigationItem.rightBarButtonItems = [
            remakeRequestCallButton ?? UIBarButtonItem(),
            editModeButton
        ]
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonAction))
        
        navigationController?.navigationBar.tintColor = .primaryTextColor
    }
    
    private func setupTargets() {
        mainView.lockWidthButton.addTarget(self, action: #selector(toogleWidthTracksTextView), for: .touchUpInside)
        mainView.segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        mainView.responseView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeFontSizeButtonAction)))
        
    }
    
    private func setJsonText() {
        UIView.transition(with: mainView, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            switch self?.mainView.segmentedControl.selectedSegmentIndex {
//            case 0:
//                self?.mainView.setJSON(self?.viewModel.requestHeadersFormatted ?? NSAttributedString(string: ""))
            case 0:
                self?.mainView.setJSON(self?.viewModel.requestBodyFormatted)
            default:
                self?.mainView.setJSON(self?.viewModel.responseBodyFormatted)
            }
        }, completion: nil)
        mainView.responseView.updateGutter()
    }
    
    @objc
    private func changeFontSizeButtonAction(sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            let scale = sender.scale
            
            if scale > oldscale  && UIFont.requestResponseTextViewfontSize < 30 {
                UIFont.requestResponseTextViewfontSize += 0.5
                UIFont.requestResponseGutterfontSize += 0.5
            } else if scale < oldscale && UIFont.requestResponseTextViewfontSize > 10{
                UIFont.requestResponseTextViewfontSize -= 0.5
                UIFont.requestResponseGutterfontSize -= 0.5
            }
            
            oldscale = scale
            mainView.responseView.textView.font = mainView.responseView.textView.font?.withSize(UIFont.requestResponseTextViewfontSize)
            mainView.responseView.gutterFontSize = UIFont.requestResponseGutterfontSize
        }
    }
    
    @objc
    private func toogleWidthTracksTextView() {
        mainView.toogleWidthTracksTextView()
    }
    
    @objc
    private func editModeButtonAction() {
        viewModel.isEditable.toggle()
        mainView.responseView.textView.isEditable = viewModel.isEditable
        editModeButton.tintColor = viewModel.isEditable ? .primaryTextColor : .gray
    }
    
    @objc
    private func remakeRequestCallAction() {
        mainView.clear()
        viewModel.recallRequest()
    }
    
    @objc
    private func segmentedControlAction() {
        setJsonText()
    }
    
    @objc
    private func backButtonAction() {
        LogManager.shared.detach(viewModel)
        navigationController?.popViewController(animated: true)
    }
    
}

extension RequestDetailViewController: RequestDetailViewModelDelegate {
    
    func didLogChange() {
        mainView.setupView(with: viewModel.log)
        setJsonText()
    }
    
}
