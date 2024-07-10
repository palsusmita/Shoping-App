import UIKit

class RegisterViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
   
        
    //MARK: - Interaction handlers
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, let username = usernameLabel.text {
            if isPasswordsMatch(password: password, confirmPassword: confirmPassword) {
                self.performSegue(withIdentifier: K.Segues.registerToLogin, sender: self)
            }
            else{
                DuplicateFuncs.alertMessage(title: "ERROR", message: "Passwords do not match!", vc: self)
            }
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.Segues.registerToLogin, sender: self)
    }
    func isPasswordsMatch(password: String, confirmPassword: String) -> Bool {
        if let password = passwordTextField.text, let passwordConfirm = confirmPasswordTextField.text {
            if password == passwordConfirm {
                return true
            }
        }
        return false
    }
}
