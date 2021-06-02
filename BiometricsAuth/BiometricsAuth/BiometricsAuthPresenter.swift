//
//  BiometricsAuthPresenter.swift
//  BiometricsAuth
//
//  Created by AJ-CHARA WAROROS on 21/5/2564 BE.
//  Copyright (c) 2564 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BiometricsAuthPresenterInterface {
  func presentValidateBiometrics(response: BiometricsAuth.ValidateBiometrics.Response)
  func presentPin(response: BiometricsAuth.SetCharacter.Response)
}

class BiometricsAuthPresenter: BiometricsAuthPresenterInterface {
  weak var viewController: BiometricsAuthViewControllerInterface!

  // MARK: - Presentation logic
  
  func presentValidateBiometrics(response: BiometricsAuth.ValidateBiometrics.Response) {
    switch response.result {
    case .success:
      let viewModel = BiometricsAuth.ValidateBiometrics.ViewModel(content: .success(()))
      viewController.displayValidateBiometrics(viewModel: viewModel)
      
    case .error (let error):
      let viewModel = BiometricsAuth.ValidateBiometrics.ViewModel(content: .error(error))
      viewController.displayValidateBiometrics(viewModel: viewModel)
    }
  }
  
  func presentPin(response: BiometricsAuth.SetCharacter.Response) {
    let viewModel = BiometricsAuth.SetCharacter.ViewModel(pin: response.pin)
    viewController.displayPin(viewModel: viewModel)
  }
}
