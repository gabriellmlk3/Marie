//
//  MarieGutterView.swift
//  MarieLib
//
//  Created by Gabriel Olbrisch de Souza on 08/06/25.
//

import UIKit

/// A gutter to the side of a scroll view’s document view.
open class MarieGutterView: UIView {
    internal let containerView: UIView

    /// The font used to draw line numbers.
    ///
    /// Initialized with a textView font value and does not update automatically when
    /// text view font changes.
    @Invalidating(.display)
    open var font = adjustGutterFont(UIFont(descriptor: UIFont.monospacedDigitSystemFont(ofSize: 0, weight: .regular).fontDescriptor.withSymbolicTraits(.traitCondensed)!, size: 0))

    /// The insets of the ruler view.
    @Invalidating(.display)
    open var insets: RulerInsets = RulerInsets(leading: 6.0, trailing: 6.0)

    /// Minimum thickness.
    @Invalidating(.layout)
    open var minimumThickness: CGFloat = 40

    /// The text color of the line numbers.
    @Invalidating(.display)
    open var textColor = UIColor.secondaryLabel

    /// A Boolean that controls whether the text view highlights the currently selected line. Default false.
    @Invalidating(.display)
    open var highlightSelectedLine: Bool = true

    /// The background color of the highlighted line.
    @Invalidating(.display)
    open var selectedLineHighlightColor: UIColor = .tintColor.withAlphaComponent(0.2)

    /// The text color of the highlighted line numbers.
    @Invalidating(.display)
    open var selectedLineTextColor: UIColor? = nil

    /// The color of the separator.
    ///
    /// Needs ``drawSeparator`` to be set to `true`.
    @Invalidating(.display)
    open var separatorColor = UIColor.separator.withAlphaComponent(0.1)

    public override init(frame: CGRect) {
        containerView = UIView(frame: frame)
        containerView.clipsToBounds = true
        containerView.isOpaque = true
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        super.init(frame: frame)
        clipsToBounds = true
        isUserInteractionEnabled = true
        isOpaque = false

        addSubview(containerView)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backgroundColor = self.backgroundColor?.resolvedColor(with: traitCollection) ?? UIColor.systemBackground.resolvedColor(with: traitCollection)
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setLineWidth(1)
        context.setStrokeColor(separatorColor.cgColor)
        context.addLines(between: [CGPoint(x: frame.width - 0.5, y: 0), CGPoint(x: frame.width - 0.5, y: bounds.maxY) ])
        context.strokePath()
    }

}

private func adjustGutterFont(_ font: UIFont) -> UIFont {
    let features: [[UIFontDescriptor.FeatureKey: Int]] = [
        [
            .type: kTextSpacingType,
            .selector: kMonospacedTextSelector
        ],
        [
            .type: kNumberSpacingType,
            .selector: kMonospacedNumbersSelector
        ],
        [
            .type: kNumberCaseType,
            .selector: kUpperCaseNumbersSelector
        ],
        [
            .type: kStylisticAlternativesType,
            .selector: kStylisticAltOneOnSelector
        ],
        [
            .type: kStylisticAlternativesType,
            .selector: kStylisticAltTwoOnSelector
        ],
        [
            .type: kTypographicExtrasType,
            .selector: kSlashedZeroOnSelector
        ]
    ]

    return UIFont(descriptor: font.fontDescriptor.addingAttributes([.featureSettings: features]), size: 0)
}
