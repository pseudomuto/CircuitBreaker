//
//  OpenStateTests.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-04.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CircuitBreaker

class OpenStateTests: QuickSpec {
  override func spec() {
    describe("OpenState") {
      var subject: OpenState!
      let breakerSwitch = MockSwitch()
      
      beforeEach {
        subject = OpenState(breakerSwitch, invoker: MockInvoker(), resetTimeout: 0.2)
      }
      
      context("type") {
        it("is open") {
          expect(subject.type()).to(equal(StateType.Open))
        }
      }
      
      context("activate") {
        it("schedules the transition") {
          expect(subject.scheduled).to(beFalse())
          
          subject.activate()
          expect(subject.scheduled).to(beTrue())
        }
        
        it("halfOpens the circuit after the reset timeout") {
          subject.activate()
          expect(subject.scheduled).to(beTrue())
          
          expect(subject.scheduled).toEventually(beFalse(), timeout: 0.4, pollInterval: 0.1, description: nil)
          expect(breakerSwitch).to(haveReceived("attempt"))
        }
      }
      
      context("invoke") {
        it("immediately throws Error.Open") {
          expect { try subject.invoke() { return } }.to(throwError(Error.OpenCircuit))
        }
      }
    }
  }
}
