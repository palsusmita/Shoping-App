
import UIKit

class LoginViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var viewModel = userViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }
    //MARK: - Functions
    private func fetchUserData() {
        viewModel.fetchUserData { success in
            if success {
                // Handle any additional logic if needed
            } else {
                print("Failed to fetch user data")
            }
        }
    }
    //MARK: - Interaction handlers
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email == viewModel.userEmail && password == viewModel.userPassword {
                // Navigate to the home page
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarController = storyboard.instantiateViewController(identifier: "home1") as! UITabBarController
                        
    //                     Set the root view controller of the window
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.window?.rootViewController = tabBarController
                            sceneDelegate.window?.makeKeyAndVisible()
                        }
 //               self.performSegue(withIdentifier: K.Segues.loginToHome, sender: self)
            }else{
                print("user credential not matching\(viewModel.userEmail)")
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
    //    self.performSegue(withIdentifier: K.Segues.loginToForgot, sender: self)

    }
    
}

