//
//  BiometricsAuthModels.swift
//  BiometricsAuth
//
//  Created by AJ-CHARA WAROROS on 21/5/2564 BE.
//  Copyright (c) 2564 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

struct BiometricsAuth {
  struct ValidateBiometrics {
    struct Request {}
    struct Response {
      let result: Content<Void>
    }
    struct ViewModel {
      let content: Content<Void>
    }
  }
  
  struct SetCharacter {
    struct Request {
      let character: Int
    }
    struct Response {
      let pin: String
    }
    struct ViewModel {
      let pin: String
    }
  }
}

public enum Content<T> {
  case error(SimpleError? = nil)
  case success(T)
}

public struct SimpleError: Error {
  public let header: String?
  public let message: String
  
  public init(header: String? = nil, message: String) {
    self.header = header
    self.message = message
  }
}
