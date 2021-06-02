//
//  BiometricsAuthViewController.swift
//  BiometricsAuth
//
//  Created by AJ-CHARA WAROROS on 21/5/2564 BE.
//  Copyright (c) 2564 BE ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol BiometricsAuthViewControllerInterface: class {
  func displayValidateBiometrics(viewModel: BiometricsAuth.ValidateBiometrics.ViewModel)
  func displayPin(viewModel: BiometricsAuth.SetCharacter.ViewModel)
}

class BiometricsAuthViewController: UIViewController, BiometricsAuthViewControllerInterface {
  var interactor: BiometricsAuthInteractorInterface!
  var router: BiometricsAuthRouterInterface!
  
  @IBOutlet weak var enterPinLabel: UILabel!
  @IBOutlet weak var pinStackView: UIStackView!
  @IBOutlet weak var keypadStackView: UIStackView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var closeButton: UIButton!
  @IBOutlet weak var tryFaceIDAgainButton: UIButton!
  
  private var didPreAuthenticate: Bool = false
  
  // MARK: - Object lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure(viewController: self)
  }
  
  // MARK: - Configuration
  
  private func configure(viewController: BiometricsAuthViewController) {
    let router = BiometricsAuthRouter()
    router.viewController = viewController
    
    let presenter = BiometricsAuthPresenter()
    presenter.viewController = viewController
    
    let interactor = BiometricsAuthInteractor()
    interactor.presenter = presenter
    interactor.worker = BiometricsAuthWorker(store: BiometricsAuthStore())
    
    viewController.interactor = interactor
    viewController.router = router
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPinStackView(characters: 0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    if !didPreAuthenticate {
      didPreAuthenticate = true
      authenticate()
    }
  }
  
  // MARK: - Event handling
  
  func authenticate() {
    //show loading
    let request = BiometricsAuth.ValidateBiometrics.Request()
    interactor.preceedWithBiometrics(request: request)
  }
  
  func setupPinStackView(characters: Int) {
    for (index, element) in pinStackView.arrangedSubviews.enumerated() {
      if index < characters {
        element.backgroundColor = UIColor.white
      } else {
        element.backgroundColor = UIColor.clear
      }
    }
  }
  
  // MARK: - Display logic
  
  func displayValidateBiometrics(viewModel: BiometricsAuth.ValidateBiometrics.ViewModel) {
    switch viewModel.content {
    case .success:
      let vc = UIViewController()
      vc.title = "Welcome"
      vc.view.backgroundColor = .systemBlue
      present(UINavigationController(rootViewController: vc),
              animated: true,
              completion: nil)
    case .error:
      enablePin()
    }
  }
  
  func displayPin(viewModel: BiometricsAuth.SetCharacter.ViewModel) {
    let pinCount = viewModel.pin.count
    setupPinStackView(characters: pinCount)
  }
  
  func enablePin() {
    keypadStackView.isUserInteractionEnabled = true
  }
  
  //Actions
  
  @IBAction func faceIDButtonTouchUpInside(_ sender: Any) {
    authenticate()
  }
  
  @IBAction func closeButtonTouchUpInside(_ sender: Any) {
    if let navController = navigationController,
      navController.viewControllers.count > 1 {
      navController.popViewController(animated: true)
    } else {
      dismiss(animated: true)
    }
  }
  
  @IBAction func keyboardButtonTouchDown(_ sender: UIButton) {
    sender.layer.backgroundColor = UIColor.gray.cgColor
  }
  
  @IBAction func keyboardButtonTouchUpOutside(_ sender: UIButton) {
    sender.layer.backgroundColor = UIColor.clear.cgColor
  }
  
  @IBAction func keyboardButtonTouchUpInside(_ sender: UIButton) {
    sender.layer.backgroundColor = UIColor.clear.cgColor
    interactor.setPinCharacter(request: BiometricsAuth.SetCharacter.Request(character: sender.tag))
  }
}
