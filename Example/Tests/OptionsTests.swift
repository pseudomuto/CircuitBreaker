//
//  OptionTests.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-02.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import CircuitBreaker

class OptionsTests: QuickSpec {
  override func spec() {
    describe("Option") {
      var subject: CircuitBreaker.Options!
      
      context("with defaults") {
        beforeEach { subject = CircuitBreaker.Options() }
        
        it("sets some 'reasonable' defaults") {
          expect(subject.errorThreshold).to(equal(2))
          expect(subject.successThreshold).to(equal(2))
          expect(subject.invocationTimeout).to(equal(1000))
          expect(subject.resetTimeout).to(equal(3000))
        }
      }
      
      context("with memberwise initializer") {
        beforeEach {
          subject = CircuitBreaker.Options(errorThreshold: 1, successThreshold: 1, invocationTimeout: 500, resetTimeout: 1000)
        }
        
        it("stores the supplied values") {
          expect(subject.errorThreshold).to(equal(1))
          expect(subject.successThreshold).to(equal(1))
          expect(subject.invocationTimeout).to(equal(500))
          expect(subject.resetTimeout).to(equal(1000))
        }
      }
    }
  }
}
