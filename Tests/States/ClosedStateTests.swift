//
//  ClosedStateTests.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-05.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CircuitBreaker

class ClosedStateTests: QuickSpec {
  override func spec() {
    describe("ClosedState") {
      var subject: ClosedState!
      
      let breakerSwitch = MockSwitch()
      let invoker       = MockInvoker()
      
      beforeEach {
        subject = ClosedState(breakerSwitch, invoker: invoker, errorThreshold: 2, invocationTimeout: 0.1)
        
        breakerSwitch.clearCalls()
        invoker.clearCalls()
      }
      
      context("initialization") {
        it("sets up all the things") {
          expect(subject.errorThreshold).to(equal(2))
          expect(subject.invocationTimeout).to(equal(0.1))
          expect(subject.failures).to(equal(0))
        }
      }
      
      context("type") {
        it("is closed") {
          expect(subject.type()).to(equal(StateType.Closed))
        }
      }
      
      context("activate") {
        it("resets failures to 0") {
          subject.onError()
          expect(subject.failures).to(equal(1))
          
          subject.activate()
          expect(subject.failures).to(equal(0))
        }
      }
      
      context("invoke") {
        it("invokes the block via the invoker") {
          let result = try! subject.invoke { return "ok" }
          
          expect(result).to(equal("ok"))
          expect(invoker).to(haveReceived("invoke"))
        }
      }
      
      context("onSuccess") {
        it("resets failures to 0") {
          subject.onError()
          expect(subject.failures).to(equal(1))
          
          subject.activate()
          expect(subject.failures).to(equal(0))
        }
      }
      
      context("onError") {
        it("increments the failure count") {
          let current = subject.failures
          subject.onError()
          
          expect(subject.failures).to(equal(current + 1))
        }
        
        it("trips the circuit when errorThreshold reached") {
          subject.onError()
          subject.onError()
          
          expect(breakerSwitch).to(haveReceived("trip"))
        }
        
        it("only trips the switch when the threshold is reached") {
          subject.onError()
          
          expect(breakerSwitch).toNot(haveReceived("trip"))
        }
      }
    }
  }
}
