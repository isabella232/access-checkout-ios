import XCTest

class CardPaymentFlowViewPageObject {

    private let app: XCUIApplication
    
    var panField: XCUIElement {
        return app.textFields["pan"]
    }
    
    var panText: String? {
        return panField.value as? String
    }
    
    var expiryDateText: String? {
        return expiryDateField.value as? String
    }
    
    var expiryDateField: XCUIElement {
        return app.textFields["expiryDate"]
    }
    
    var cvcField: XCUIElement {
        return app.textFields["cvc"]
    }
    
    var cvcText: String? {
        return cvcField.value as? String
    }
    
    var cardBrandImage: XCUIElement {
        return app.images["cardBrandImage"]
    }
    
    var submitButton: XCUIElement {
        return app.buttons["Submit"]
    }
    
    var paymentsCvcSessionToggleLabel: XCUIElement {
        return app.staticTexts["paymentsCvcSessionToggleLabel"]
    }
    
    var paymentsCvcSessionToggleHintLabel: XCUIElement {
        return app.staticTexts["paymentsCvcSessionToggleHintLabel"]
    }
    
    var alert: AlertViewPageObject {
        return AlertViewPageObject(element: app.alerts.firstMatch)
    }
    
    var paymentsCvcSessionToggle: SwitchViewPageObject {
        return SwitchViewPageObject(element: app.switches["paymentsCvcSessionToggle"])
    }
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
    
    func typeTextIntoPan(_ text: String) {
        if !panField.isFocused {
            panField.tap()
        }
        panField.typeText(text)
    }
    
    func typeTextIntoExpiryDate(_ text: String) {
        if !expiryDateField.isFocused {
            expiryDateField.tap()
        }
        expiryDateField.typeText(text)
    }
    
    func typeTextIntoCvc(_ text: String) {
        if !cvcField.isFocused {
            cvcField.tap()
        }
        cvcField.typeText(text)
    }
    
    func submit() {
        submitButton.tap()
    }
}

extension XCUIElement {
    var isFocused: Bool {
        let isFocused = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return isFocused
    }
}
