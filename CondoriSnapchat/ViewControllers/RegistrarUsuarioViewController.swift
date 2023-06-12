
import UIKit
import FirebaseAuth
import FirebaseDatabase
      
class RegistrarUsuarioViewController: UIViewController{
    var email: String?
    
    //@IBOutlet weak var newEmailTextField: UITextField!
    
    @IBOutlet weak var newEmailTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    
    //@IBOutlet weak var newPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newEmailTextField.text = email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crearUsuarioTapped(_ sender: Any) {
        
        guard let email = newEmailTextField.text, !email.isEmpty,
             let password = newPasswordTextField.text, !password.isEmpty else {
           return
       }
       
       Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
           print("Intentando crear un usuario")
           if let error = error {
               print("Se presentó el siguiente error al crear el usuario: \(error)")
           } else {
               print("El usuario fue creado exitosamente")
               
               Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
               
               let alert = UIAlertController(title: "Usuario Creado", message: "Usuario creado exitosamente.", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "Aceptar", style: .default) { (_) in
                   self.dismiss(animated: true, completion: nil)
               }
               
               
               
               alert.addAction(okAction)
               self.present(alert, animated: true, completion: nil)
           }
       }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "redireccionarvista" {
            // Aquí puedes realizar cualquier preparación adicional antes de la redirección
        }
    }
    
}
