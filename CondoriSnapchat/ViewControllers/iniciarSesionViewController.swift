
import UIKit
import FirebaseAuth
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password:
        passwordTextField.text!) { (user, error) in
        print ("Intentando Iniciar Sesion" )
    if error != nil{
        print("Se presento el siguient error: \(error)")
        
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
            print("Intentando crear un usuario")
            if error != nil {
                print("Se presento el siguiente error al crear el usuario: \(error)")
            } else {
                print("el usuario fue creado exitosamente")
                //nuevop
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario: \(self.emailTextField.text!)",preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)})
                self.present(alerta, animated: true, completion: nil)
            }
            
        })
        
        
    }else{
        print("Inicio de sesion exitoso")
        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
        }
    }
    }
//MARK: Ingresar mediante numero
    @IBAction func capturarNumeroTapped(_ sender: Any) {
        
        guard let phoneNumber = emailTextField.text else {
                return
        }
            
        verifyPhoneNumber(phoneNumber: phoneNumber)
    }
    
    func verifyPhoneNumber(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Error al enviar el código de verificación: \(error.localizedDescription)")
                return
            }
            
            // Guarda el verificationID para usarlo posteriormente
            
            // Presenta la pantalla para ingresar el código de verificación
            // Aquí puedes mostrar una nueva vista o presentar un alert para que el usuario ingrese el código de verificación
            // Puedes pasar el verificationID a la siguiente vista o mantenerlo en una propiedad de la clase para usarlo después
            self.showVerificationCodeScreen(verificationID: verificationID ?? "")
        }
    }

    func showVerificationCodeScreen(verificationID: String) {
        let alertController = UIAlertController(title: "Verificar Código", message: "Ingrese el código de verificación", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Código de Verificación"
        }
        
        let confirmAction = UIAlertAction(title: "Confirmar", style: .default) { (_) in
            if let verificationCode = alertController.textFields?.first?.text {
                self.signInWithVerificationCode(verificationID: verificationID, verificationCode: verificationCode)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func signInWithVerificationCode(verificationID: String, verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error al iniciar sesión con número de teléfono: \(error.localizedDescription)")
                return
            }
            
            // Inicio de sesión exitoso
            print("Inicio de sesión exitoso para el número: \(authResult?.user.phoneNumber ?? "")")
        }
    }

}
