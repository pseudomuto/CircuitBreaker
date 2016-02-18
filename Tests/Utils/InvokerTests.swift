//
//  InvokerTests.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-06.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CircuitBreaker

class InvokerTests: QuickSpec {
  override func spec() {
    describe("Invoker") {
      var subject: Invoker!
      let state = MockState()
      
      beforeEach {
        subject = Invoker(dispatch_queue_create("testInvoker", DISPATCH_QUEUE_SERIAL))
        state.clearCalls()
      }
      
      context("invoke") {
        context("when successful") {
          var result: String!

          beforeEach {
            result = try! subject.invoke(state, timeout: 0.2) { return "got it" }
          }

          it("returns the result of the function") {
            expect(result).to(equal("got it"))
          }

          it("lets the state know the call was successful") {
            expect(state).to(haveReceived("onSuccess"))
          }
        }

        context("when invocation times out") {
          let block: () -> String = {
            NSThread.sleepForTimeInterval(0.3)
            return "won't get here"
          }

          it("throws an invocation timeout error") {
            expect { try subject.invoke(state, timeout: 0.1, block: block) }.to(throwError(Error.InvocationTimeout))
          }

          it("notifies the state object") {
            expect { try subject.invoke(state, timeout: 0.1, block: block) }.to(throwError(Error.InvocationTimeout))
            expect(state).to(haveReceived("onError"))
          }
        }

        context("when invocation throws") {
          enum TestError: ErrorType { case Error }

          let block: () throws -> String = {
            throw TestError.Error
          }

          it("bubbles the error up to the caller") {
            expect { try subject.invoke(state, timeout: 0.1, block: block) }.to(throwError(TestError.Error))
          }

          it("notifies the state object") {
            expect { try subject.invoke(state, timeout: 0.1, block: block) }.to(throwError(TestError.Error))
            expect(state).to(haveReceived("onError"))
          }
        }
      }
    }
  }
}