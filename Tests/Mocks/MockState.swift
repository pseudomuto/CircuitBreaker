//
//  MockState.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-06.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import CircuitBreaker

class MockState: State, Mock {
  private(set) var calls: [Call] = []
  
  func clearCalls() {
    calls.removeAll()
  }
  
  func type() -> StateType {
    return .Closed
  }
  
  func activate() {
    calls.append(Call(method: "activate", args: []))
  }
  
  func onSuccess() {
    calls.append(Call(method: "onSuccess", args: []))
  }
  
  func onError() {
    calls.append(Call(method: "onError", args: []))
  }
  
  func invoke<T>(block: () throws -> T) throws -> T {
    calls.append(Call(method: "invoke", args: [block]))
    return try block()
  }
}
