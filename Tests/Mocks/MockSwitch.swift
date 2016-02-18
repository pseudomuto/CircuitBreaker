//
//  MockSwitch.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-05.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import CircuitBreaker

class MockSwitch: Switch, Mock {
  private(set) var calls: [Call] = []
  
  func clearCalls() {
    calls.removeAll()
  }
  
  func reset(fromState: State) {
    calls.append(Call(method: "reset", args: [fromState]))
  }
  
  func trip(fromState: State) {
    calls.append(Call(method: "trip", args: [fromState]))
  }
  
  func attempt(fromState: State) {
    calls.append(Call(method: "attempt", args: [fromState]))
  }
}
