//
//  HalfOpenStateTests.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-05.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CircuitBreaker

class HalfOpenStateTests: QuickSpec {
  override func spec() {
    describe("HalfOpenState") {
      var subject: HalfOpenState!
      
      let breakerSwitch = MockSwitch()
      let invoker       = MockInvoker()
      
      beforeEach {
        subject = HalfOpenState(breakerSwitch, invoker: invoker, successThreshold: 2, invocationTimeout: 0.2)
        
        breakerSwitch.clearCalls()
        invoker.clearCalls()
      }
      
      context("initialization") {
        it("sets up all the things") {
          expect(subject.successThreshold).to(equal(2))
          expect(subject.invocationTimeout).to(equal(0.2))
          expect(subject.successes).to(equal(0))
        }
      }
      
      context("type") {
        it("is half open") {
          expect(subject.type()).to(equal(StateType.HalfOpen))
        }
      }
      
      context("active") {
        it("resets the success count to 0") {
          subject.onSuccess()
          expect(subject.successes).to(equal(1))
          
          subject.activate()
          expect(subject.successes).to(equal(0))
        }
      }
      
      context("onSuccess") {
        it("resets the breaker when successThreshold is reached") {
          subject.onSuccess()
          subject.onSuccess()
          
          expect(breakerSwitch).to(haveReceived("reset"))
        }
        
        it("only resets the breaker when the threshold is reached") {
          subject.onSuccess()
          
          expect(breakerSwitch).toNot(haveReceived("reset"))
        }
      }
      
      context("onError") {
        it("trips the breaker") {
          subject.onError()
          
          expect(breakerSwitch).to(haveReceived("trip"))
        }
      }

      context("invoke") {
        it("executes the function") {
          try! subject.invoke { return "ok" }
          expect(invoker).to(haveReceived("invoke"))
        }

        it("only allows a single run at a time") {
          try! subject.invoke { return "ok" }
          expect(invoker).to(haveReceived("invoke"))

          expect { try subject.invoke { return } }.to(throwError(Error.OpenCircuit))
        }
      }
    }
  }
}
