//
//  MockInvoker.swift
//  CircuitBreaker
//
//  Created by David Muto on 2016-02-05.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

@testable import CircuitBreaker

class MockInvoker: Invoker, Mock {
  private(set) var calls: [Call] = []
  private let queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_SERIAL)
  
  init() {
    super.init(queue)
  }
  
  func clearCalls() {
    calls.removeAll()
  }
  
  override func invoke<T>(state: State, timeout: NSTimeInterval, block: () throws -> T) throws -> T {
    calls.append(Call(method: "invoke", args: [state, block]))
    return try block()
  }
}
