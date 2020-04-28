import UIKit

/// A view representing a card's expiry date
@IBDesignable public class ExpiryDateView: UIView {
    
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    /// The delegate to handle view events
    weak public var accessCheckoutViewDelegate: AccessCheckoutViewDelegate?
    
    /// The expiry date month element
    public var month: ExpiryMonth? {
        guard let text = monthTextField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    /// The expiry date year element
    public var year: ExpiryYear? {
        guard let text = yearTextField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    /// Initialize ExpiryDateView from storyboard
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewFromNib()
    }
    
    /// Initializer override
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViewFromNib()
    }
    
    private func setupViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        
        monthTextField.delegate = self
        yearTextField.delegate = self
        
        monthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case monthTextField:
            (accessCheckoutViewDelegate as? ExpiryDateViewDelegate)?.didUpdate(expiryMonth: text, expiryYear: nil)
        case yearTextField:
            (accessCheckoutViewDelegate as? ExpiryDateViewDelegate)?.didUpdate(expiryMonth: nil, expiryYear: text)
        default:
            return
        }
    }
}

extension ExpiryDateView: AccessCheckoutDateView {
    
    public var isEnabled: Bool {
        get {
            return monthTextField.isEnabled && yearTextField.isEnabled
        }
        set {
            monthTextField.isEnabled = newValue
            yearTextField.isEnabled = newValue
        }
    }
    
    /**
     The validity of the expiry date has updated.
     
     - Parameters:
        - valid: View represents a valid expiry date
     */
    public func isValid(valid: Bool) {
        monthTextField.textColor = valid ? UIColor.black : UIColor.red
        yearTextField.textColor = valid ? UIColor.black : UIColor.red
    }
    
    /// Clears any text input.
    public func clear() {
        monthTextField.text = nil
        yearTextField.text = nil
    }
}

extension ExpiryDateView: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case monthTextField:
            (accessCheckoutViewDelegate as? ExpiryDateViewDelegate)?.didEndUpdate(expiryMonth: text, expiryYear: nil)
        case yearTextField:
            (accessCheckoutViewDelegate as? ExpiryDateViewDelegate)?.didEndUpdate(expiryMonth: nil, expiryYear: text)
        default:
            return
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case monthTextField:
            return (accessCheckoutViewDelegate as? ExpiryDateViewDelegate)?.canUpdate(expiryMonth: textField.text, withText: string, inRange: range) ?? true
        case yearTextField:
            return (accessCheckoutViewDelegate as? ExpiryDateViewDelegate)?.canUpdate(expiryYear: textField.text, withText: string, inRange: range) ?? true
        default:
            return false
        }
    }
}
