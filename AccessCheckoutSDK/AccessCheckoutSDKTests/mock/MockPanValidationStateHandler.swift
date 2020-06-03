import Cuckoo
@testable import AccessCheckoutSDK

import Foundation


 class MockPanValidationStateHandler: PanValidationStateHandler, Cuckoo.ProtocolMock {
    
     typealias MocksType = PanValidationStateHandler
    
     typealias Stubbing = __StubbingProxy_PanValidationStateHandler
     typealias Verification = __VerificationProxy_PanValidationStateHandler

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PanValidationStateHandler?

     func enableDefaultImplementation(_ stub: PanValidationStateHandler) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)  {
        
    return cuckoo_manager.call("handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)",
            parameters: (isValid, cardBrand),
            escapingParameters: (isValid, cardBrand),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.handle(isValid: isValid, cardBrand: cardBrand))
        
    }
    
    
    
     func isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool {
        
    return cuckoo_manager.call("isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool",
            parameters: (cardBrand),
            escapingParameters: (cardBrand),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.isCardBrandDifferentFrom(cardBrand: cardBrand))
        
    }
    

	 struct __StubbingProxy_PanValidationStateHandler: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func handle<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(isValid: M1, cardBrand: M2) -> Cuckoo.ProtocolStubNoReturnFunction<(Bool, AccessCardConfiguration.CardBrand?)> where M1.MatchedType == Bool, M2.OptionalMatchedType == AccessCardConfiguration.CardBrand {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, AccessCardConfiguration.CardBrand?)>] = [wrap(matchable: isValid) { $0.0 }, wrap(matchable: cardBrand) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method: "handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)", parameterMatchers: matchers))
	    }
	    
	    func isCardBrandDifferentFrom<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.ProtocolStubFunction<(AccessCardConfiguration.CardBrand?), Bool> where M1.OptionalMatchedType == AccessCardConfiguration.CardBrand {
	        let matchers: [Cuckoo.ParameterMatcher<(AccessCardConfiguration.CardBrand?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPanValidationStateHandler.self, method: "isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PanValidationStateHandler: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func handle<M1: Cuckoo.Matchable, M2: Cuckoo.OptionalMatchable>(isValid: M1, cardBrand: M2) -> Cuckoo.__DoNotUse<(Bool, AccessCardConfiguration.CardBrand?), Void> where M1.MatchedType == Bool, M2.OptionalMatchedType == AccessCardConfiguration.CardBrand {
	        let matchers: [Cuckoo.ParameterMatcher<(Bool, AccessCardConfiguration.CardBrand?)>] = [wrap(matchable: isValid) { $0.0 }, wrap(matchable: cardBrand) { $0.1 }]
	        return cuckoo_manager.verify("handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func isCardBrandDifferentFrom<M1: Cuckoo.OptionalMatchable>(cardBrand: M1) -> Cuckoo.__DoNotUse<(AccessCardConfiguration.CardBrand?), Bool> where M1.OptionalMatchedType == AccessCardConfiguration.CardBrand {
	        let matchers: [Cuckoo.ParameterMatcher<(AccessCardConfiguration.CardBrand?)>] = [wrap(matchable: cardBrand) { $0 }]
	        return cuckoo_manager.verify("isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PanValidationStateHandlerStub: PanValidationStateHandler {
    

    

    
     func handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)   {
        return DefaultValueRegistry.defaultValue(for: (Void).self)
    }
    
     func isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool  {
        return DefaultValueRegistry.defaultValue(for: (Bool).self)
    }
    
}
