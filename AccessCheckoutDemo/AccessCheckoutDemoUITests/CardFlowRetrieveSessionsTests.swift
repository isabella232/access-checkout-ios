@testable import AccessCheckoutSDK
import XCTest

class CardPaymentFlowRetrieveSessionsTests: XCTestCase {
    private let expectedVtSessionRegex = "https:\\/\\/npe\\.access\\.worldpay\\.com\\/verifiedTokens\\/sessions\\/[a-zA-Z0-9\\-]+"
    private let expectedCvcSessionRegex = "https:\\/\\/npe\\.access\\.worldpay\\.com\\/sessions\\/[a-zA-Z0-9\\-]+"
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    func testRetrievesAVerifiedTokensSession_whenPaymentsCvcSessionToggleIsOff() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokensSession-success")
            .launch()
        let expectedTitle = "Verified Tokens Session"
        
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        XCTAssertNotNil(alert.message.range(of: expectedVtSessionRegex, options: .regularExpression))
    }
    
    func testRetrievesAVerifiedTokensSessionAndAPaymentsCvcSessionToken_whenPaymentsCvcSessionToggleIsOn() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokensSession-success")
            .sessionsStub(respondsWith: "sessions-success")
            .sessionsPaymentsCvcStub(respondsWith: "sessions-paymentsCvc-success")
            .launch()
        let view = CardFlowViewPageObject(app)
        let expectedTitle = "Verified Tokens & Payments CVC Sessions"
        
        fillUpFormWithValidValues(using: view)
        view.paymentsCvcSessionToggle.toggleOn()
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        XCTAssertNotNil(alert.message.range(of: expectedVtSessionRegex, options: .regularExpression))
        XCTAssertNotNil(alert.message.range(of: expectedCvcSessionRegex, options: .regularExpression))
    }
    
    func testClearsFormAndDisablesButtonWhenAlertWithSessionIsClosed() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokensSession-success")
            .launch()
        let view = CardFlowViewPageObject(app)
        let expectedTitle = "Verified Tokens Session"
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.title, expectedTitle)
        
        alert.close()
        XCTAssertFalse(alert.exists)
        
        waitFor(timeoutInSeconds: 0.5)
        XCTAssertEqual(view.panField.placeholderValue, view.panText)
        XCTAssertEqual(view.expiryDateField.placeholderValue, view.expiryDateText)
        XCTAssertEqual(view.cvcField.placeholderValue, view.cvcText)
        XCTAssertEqual(view.submitButton.isEnabled, false)
    }
    
    func testResponse_internalServerError() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-internalServerError")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("internalServerError"))
    }
    
    func testResponse_bodyDoesNotMatchSchema_panFailedLuhnCheck() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-bodyDoesNotMatchSchema-panFailedLuhnCheck")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("bodyDoesNotMatchSchema"))
        XCTAssert(alert.title.contains("panFailedLuhnCheck"))
        XCTAssert(alert.title.contains(VerifiedTokensSessionRequest.Key.cardNumber.rawValue))
    }
    
    func testResponse_bodyDoesNotMatchSchema_fieldIsMissing_cardNumber() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-bodyDoesNotMatchSchema-fieldIsMissing-cardNumber")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("bodyDoesNotMatchSchema"))
        XCTAssert(alert.title.contains("fieldIsMissing"))
        XCTAssert(alert.title.contains(VerifiedTokensSessionRequest.Key.cardNumber.rawValue))
    }
    
    func testResponse_unknown_variation1() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation1")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("variation1"))
    }
    
    func testResponse_unknown_variation2() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation2")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("variation2"))
    }
    
    func testResponse_unknown_variation3() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation3")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("variation3"))
    }
    
    func testResponse_unknown_variation4() {
        let app = appLauncher().discoveryStub(respondsWith: "Discovery-success")
            .verifiedTokensStub(respondsWith: "VerifiedTokens-success")
            .verifiedTokensSessionStub(respondsWith: "VerifiedTokens-unknown-variation4")
            .launch()
        let view = CardFlowViewPageObject(app)
        
        fillUpFormWithValidValues(using: view)
        view.submit()
        waitFor(timeoutInSeconds: 0.05)
        
        let alert = view.alert
        XCTAssertTrue(alert.exists)
        XCTAssert(alert.title.contains("variation4"))
    }
    
    private func fillUpFormWithValidValues(using view: CardFlowViewPageObject) {
        view.typeTextIntoPan("4111111111111111")
        view.typeTextIntoExpiryDate("01/99")
        view.typeTextIntoCvc("123")
    }
    
    private func waitFor(timeoutInSeconds: Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
    
    private func formatStringAsStaticTextLabel(_ string: String) -> String {
        // The XCUI framework seems to replace carriage returns by spaces for alert labels
        // This function is designed to format strings the same way so that we can search staticTexts accordingly
        return string.replacingOccurrences(of: "\n", with: " ")
    }
}
