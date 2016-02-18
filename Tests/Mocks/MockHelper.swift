//
//  MockHelper.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-05.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Nimble

struct Call {
  var method: String
  var args: [Any]
}

protocol Mock {
  var calls: [Call] { get }
  
  func clearCalls()
}

func haveReceived<T: Mock>(method: String) -> MatcherFunc<T?> {
  return MatcherFunc { mock, message in
    message.actualValue    = nil
    message.postfixMessage = "have received \(method)"
    
    if let instance = try mock.evaluate() {
      return instance?.calls.filter { $0.method == method }.count > 0
    }

    return false
  }
}