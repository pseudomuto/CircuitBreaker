//
//  BreakerTests.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-05.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CircuitBreaker

class BreakerTests: QuickSpec {
  enum TestError: ErrorType { case Error }
  
  override func spec() {
    describe("Breaker") {
      var subject: Breaker!
      
      let options = Options(
        errorThreshold: 2,
        successThreshold: 2,
        invocationTimeout: 0.2,
        resetTimeout: 0.5
      )
      
      let thrower: () throws -> String = {
        throw TestError.Error
      }

      func timeoutFn(timeout: NSTimeInterval) -> () -> String {
        return {
          NSThread.sleepForTimeInterval(timeout)
          return "Shouldn't be received"
        }
      }
      
      beforeEach { subject = Breaker("testBreaker", withOptions: options) }
      
      context("default initialization") {
        it("starts in an closed state") {
          expect(subject.isClosed).to(beTrue())
        }
      }
      
      context("states") {
        it("has correct state when closed") {
          expect(subject.isClosed).to(beTrue())
          expect(subject.isOpen).to(beFalse())
          expect(subject.isHalfOpen).to(beFalse())
        }
        
        it("has correct state when open") {
          subject.force(.Open)
          
          expect(subject.isClosed).to(beFalse())
          expect(subject.isOpen).to(beTrue())
          expect(subject.isHalfOpen).to(beFalse())
        }
        
        it("has correct state when half open") {
          subject.force(.HalfOpen)
          
          expect(subject.isClosed).to(beFalse())
          expect(subject.isOpen).to(beFalse())
          expect(subject.isHalfOpen).to(beTrue())
        }
      }
      
      context("invoke") {
        it("invokes the method when closed") {
          subject.force(.Closed)
        }
        
        it("invokes the method when half open") {
          subject.force(.HalfOpen)
        }
        
        it("when open throws a circuit error") {
          subject.force(.Open)
          expect { try subject.invoke() { return } }.to(throwError(Error.OpenCircuit))
        }
      }
      
      context("trip") {
        it("happens when the error threshold is reached") {
          expect { try subject.invoke(thrower) }.to(throwError(TestError.Error))
          expect { try subject.invoke(thrower) }.to(throwError(TestError.Error))

          expect(subject.isOpen).to(beTrue())
        }
        
        it("both errors and timeouts count towards the error threshold") {
          expect { try subject.invoke(thrower) }.to(throwError(TestError.Error))
          expect { try subject.invoke(timeoutFn(0.5)) }.to(throwError(Error.InvocationTimeout))

          expect(subject.isOpen).to(beTrue())
        }
        
        it("doesn't happen until the threshold is reached") {
          expect { try subject.invoke(thrower) }.to(throwError(TestError.Error))
          
          expect(subject.isOpen).to(beFalse())
        }
      }

      context("attempt") {
        it("happens when the reset timeout lapses after opening the circuit") {
          expect { try subject.invoke(thrower) }.to(throwError(TestError.Error))
          expect { try subject.invoke(thrower) }.to(throwError(TestError.Error))
          expect(subject.isOpen).to(beTrue())

          expect(subject.isHalfOpen).toEventually(beTrue(), timeout: 0.6)
        }
      }

      context("reset") {
        beforeEach { subject.force(.HalfOpen) }

        it("happens when the success threshold is reached") {
          expect { try subject.invoke() { return "aha" } }.to(equal("aha"))
          expect { try subject.invoke() { return "aha" } }.to(equal("aha"))

          expect(subject.isClosed).to(beTrue())
        }

        it("only happens when the success threshold is reached") {
          expect { try subject.invoke() { return "aha" } }.to(equal("aha"))

          expect(subject.isHalfOpen).to(beTrue())
        }
      }
    }
  }
}