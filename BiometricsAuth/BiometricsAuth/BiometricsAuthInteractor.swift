//
//  BiometricsAuthInteractor.swift
//  BiometricsAuth
//
//  Created by AJ-CHARA WAROROS on 21/5/2564 BE.
//  Copyright (c) 2564 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol BiometricsAuthInteractorInterface {
  func preceedWithBiometrics(request: BiometricsAuth.ValidateBiometrics.Request)
  func setPinCharacter(request: BiometricsAuth.SetCharacter.Request)
}

class BiometricsAuthInteractor: BiometricsAuthInteractorInterface {
  var presenter: BiometricsAuthPresenterInterface!
  var worker: BiometricsAuthWorker?
  var model: Entity?
  var pin: String = ""
  
  // MARK: - Business logic
  
  func preceedWithBiometrics(request: BiometricsAuth.ValidateBiometrics.Request) {
    let context = LAContext()
    
    context.evaluateWithBiometrics(
      evaluationSuccess: { [weak self] in
        guard let weakSelf = self else { return }
        weakSelf.presenter.presentValidateBiometrics(response: BiometricsAuth.ValidateBiometrics.Response(result: .success(())))
      },
      evaluationFailure: { [weak self] in
        //enable Pin
        self?.presenter.presentValidateBiometrics(response: BiometricsAuth.ValidateBiometrics.Response(result: .error()))
      },
      cannotEvaluate: {
        return
      }
    )
  }
  
  func setPinCharacter(request: BiometricsAuth.SetCharacter.Request) {
    let character = request.character
    
    // backspace
    if character == 10 {
      pin = String(pin.dropLast())
    } else {
      // append number
      pin.append("\(character)")
    }
    presentPin(pin: pin)
  }
  
  private func presentPin(pin: String) {
    presenter.presentPin(response: BiometricsAuth.SetCharacter.Response(pin: pin))
  }
}
