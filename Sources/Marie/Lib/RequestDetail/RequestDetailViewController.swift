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
//        mainView.lockWidthButton.addTarget(self, action: #selector(beautifyContent), for: .touchUpInside)
        mainView.segmentedControl.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        mainView.responseView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeFontSizeButtonAction)))
        
    }
    
    private func setJsonText() {
        UIView.transition(with: mainView, duration: 0.3, options: .transitionCrossDissolve, animations: { [weak self] in
            switch self?.mainView.segmentedControl.selectedSegmentIndex {
//            case 0:
//                self?.mainView.setJSON(self?.viewModel.requestHeadersFormatted ?? NSAttributedString(string: ""))
            case 0:
                self?.mainView.setJSON(self?.viewModel.requestBodyFormatted ?? "")
            default:
                self?.mainView.setJSON(self?.viewModel.responseBodyFormatted ?? "")
            }
            
//            self?.beautifyContent()
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
//            mainView.responseView.font = mainView.responseView.font.withSize(UIFont.requestResponseTextViewfontSize)
        }
    }
    
    @objc
    private func toogleWidthTracksTextView() {
        mainView.toogleWidthTracksTextView()
    }
    
    @objc
    private func editModeButtonAction() {
        viewModel.isEditable.toggle()
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
    
//    @objc private func beautifyContent() {
//        let textView = mainView.responseView
//        let raw = textView.text ?? ""
//        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        // Se for JSON:
//        if trimmed.first == "{" || trimmed.first == "[" {
//            guard let data = raw.data(using: .utf8) else { return }
//            do {
//                let obj = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                let prettyData = try JSONSerialization.data(
//                    withJSONObject: obj,
//                    options: .prettyPrinted
//                )
//                guard let prettyString = String(data: prettyData, encoding: .utf8) else { return }
//                
//                // Atualiza o texto indentado
//                // (salva seleção para restaurar depois)
//                let selectedRange = textView.selectedTextRange
//                textView.text = prettyString
//                textView.selectedTextRange = selectedRange
//                return
//            } catch {
////                showError("JSON inválido: \(error.localizedDescription)")
//                return
//            }
//        }
//        
//        // Se for HTML (começa com "<"), opcionalmente você pode reatribuir bruto:
//        if trimmed.hasPrefix("<") {
//            // (usando SwiftSoup ou outro parser você poderia reindentar,
//            //  mas aqui apenas “re-carregamos” para disparar o highlight)
//            let selectedRange = textView.selectedTextRange
//            textView.text = raw
//            textView.selectedTextRange = selectedRange
//        }
//    }

    
}

extension RequestDetailViewController: RequestDetailViewModelDelegate {
    
    func didLogChange() {
        mainView.setupView(with: viewModel.log)
        setJsonText()
    }
    
}

//extension RequestDetailViewController: MarieTextViewDelegate {
//    
//    func textView(_ textView: MarieTextView, shouldChangeTextIn affectedCharRange: NSTextRange, replacementString: String?) -> Bool {
//        return viewModel.isEditable
//    }
//    
//    func textView(
//        _ textView: MarieTextView,
//        didChangeTextIn affectedCharRange: NSTextRange,
//        replacementString: String
//    )
//    {
//        let fullString = textView.text ?? ""
//        let fullNSString = fullString as NSString
//        let fullRange = NSRange(location: 0, length: fullNSString.length)
//        
//        // 1) Limpa todos os atributos de cor/fonte
//        textView.setAttributes([
//            .foregroundColor: UIColor.white,
//            .font: UIFont.monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .regular)
//        ], range: fullRange)
//        
//        // 2) Primeiro, destaque as KEYS (strings antes de dois-pontos)
//        let keyPattern = "\"(?:\\\\.|[^\"\\\\])*\"(?=\\s*:\\s*)"
//        if let keyRegex = try? NSRegularExpression(pattern: keyPattern, options: []) {
//            let keyMatches = keyRegex.matches(in: fullString, options: [], range: fullRange)
//            for match in keyMatches {
//                textView.addAttributes([
//                    .foregroundColor: UIColor.JSONKeyColor,
//                    .font: UIFont.monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .regular)
//                ], range: match.range)
//            }
//        }
//        
//        // 3) Depois, destaque valores (strings, números, literais, etc.)
//        let patterns: [(String, UIColor)] = [
//            // Strings (valores)
//            ("\"(?:\\\\.|[^\"\\\\])*\"", .JSONStringValueColor),
//            // Números
//            ("[-+]?\\b\\d+(?:\\.\\d+)?\\b", .JSONNumbersValueColor),
//            // Literais true/false/null
//            ("\\b(true|false|null)\\b", .JSONOtherValuesColor),
//            // Chaves e colchetes
//            ("[\\{\\}\\[\\]]", .white),
//            // Dois-pontos e vírgulas
//            ("[:{},]", .white)
//        ]
//        
//        for (pattern, color) in patterns {
//            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { continue }
//            let matches = regex.matches(in: fullString, options: [], range: fullRange)
//            for match in matches {
//                // Se o intervalo já foi marcado como KEY, pule
//                let existing = (textView.textContentManager as? NSTextContentStorage)?.textStorage?.attributes(at: match.range.location, effectiveRange: nil)
//                if existing?[.foregroundColor] as? UIColor == UIColor.JSONKeyColor || existing?[.foregroundColor] as? UIColor == UIColor.JSONStringValueColor {
//                    continue
//                }
//                // Aplica estilo
//                textView.addAttributes([
//                    .foregroundColor: color,
//                    .font: UIFont.monospacedSystemFont(ofSize: UIFont.requestResponseTextViewfontSize, weight: .regular)
//                ], range: match.range)
//            }
//        }
//    }
//}
