//
//  RequestDetailViewController.swift
//  Marie
//
//  Created by Gabriel Olbrisch on 15/04/23.
//

import UIKit

final class RequestDetailViewController: UIViewController {
    
    private let viewModel: RequestDetailViewModel
    private let mainView: RequestDetailView = .init()
    
    private var oldscale: CGFloat = 0.0
    
    init(viewModel: RequestDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonAction))
        navigationController?.navigationBar.tintColor = .primaryTextColor
        setJsonText(text: viewModel.responseBodyFormatted)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            LogManager.shared.detach(viewModel)
        }
    }
    
    private func setupTargets() {
        mainView.segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        mainView.responseView.textView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeFontSizeButtonAction)))
        
    }
    
    private func setJsonText(text: NSAttributedString?) {
        UIView.transition(with: mainView, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self else { return }
            self.mainView.responseView.textView.attributedText = text
        }, completion: nil)
    }
    
    @objc
    private func changeFontSizeButtonAction(sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            let scale = sender.scale
            
            if scale > oldscale  && UIFont.requestResponseTextViewfontSize < 30 {
                UIFont.requestResponseTextViewfontSize += 0.5
            } else if scale < oldscale && UIFont.requestResponseTextViewfontSize > 10{
                UIFont.requestResponseTextViewfontSize -= 0.5
            }
            
            oldscale = scale
            mainView.responseView.textView.font = mainView.responseView.textView.font?.withSize(UIFont.requestResponseTextViewfontSize)
        }
    }
    
    @objc
    private func segmentedControlAction() {
        mainView.toggleTextViewsVisibility()
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
        setJsonText(text: NSAttributedString(string: viewModel.log.responseBody ?? ""))
    }
    
}


