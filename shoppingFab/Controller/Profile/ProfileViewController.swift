import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileUserEmailLabel: UILabel!
    @IBOutlet weak var profileUserAddressLabel: UILabel!
    
    private let imagePicker = UIImagePickerController()
    
    private var selectedImage: UIImage?
    private var email: String?
    private var username: String?
    private var viewModel = userViewModel()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePictureSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserDetails()
    }
    
    //MARK: - Interaction handlers
    @IBAction func uploadProfilePhotoButtonPressed(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        signOut()
    }
    func fetchUserDetails(){
        viewModel.fetchUserData { success in
            if success {
                DispatchQueue.main.async {
                    self.profileUsernameLabel.text = self.viewModel.userName
                    self.profileUserEmailLabel.text = self.viewModel.userEmail
                    self.profileUserAddressLabel.text = self.viewModel.userAddress
                }
            } else {
                print("Failed to fetch user details")
            }
        }
    }
    //MARK: - Functions
    func signOut() {
        // Remove the isLoggedIn value from UserDefaults
          UserDefaults.standard.removeObject(forKey: "isLoggedIn")
          
          // Navigate back to the login screen
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let homeViewController = storyboard.instantiateViewController(withIdentifier: "homeViewController") as? HomeViewController {
              self.view.window?.rootViewController = homeViewController
              self.view.window?.makeKeyAndVisible()
          }
    }
        
    func profilePictureSetup() {
        imagePicker.delegate = self
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.height / 2
        profilePictureImageView.layer.masksToBounds = true
    }
}

//MARK: - Extensions
extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = pickedImage
            profilePictureImageView.image = selectedImage
            dismiss(animated: true)
         //   uploadProfilePhotoToFirebase()
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    
}
