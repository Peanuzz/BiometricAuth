//
//  BiometricsHelper.swift
//  BiometricsAuth
//
//  Created by AJ-CHARA WAROROS on 21/5/2564 BE.
//

import Foundation
import LocalAuthentication

public extension LAContext {
  func evaluateWithBiometrics(evaluationSuccess: @escaping () -> Void,
                              evaluationFailure: @escaping () -> Void,
                              cannotEvaluate: @escaping () -> Void,
                              localizedReason: String = "Access requires authentication"
  ) {
    
    if canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
      
      evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason, reply: { (success: Bool, _: Error?) in
        
        if success {
          DispatchQueue.main.sync {
            evaluationSuccess()
          }
        } else {
          // Biometrics failed
          DispatchQueue.main.sync {
            evaluationFailure()
          }
        }
      })
    } else {
      // Biometrics Disabled/ Not found
      cannotEvaluate()
    }
  }
}

