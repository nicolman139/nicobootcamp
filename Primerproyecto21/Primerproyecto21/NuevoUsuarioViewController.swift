//
//  NuevoUsuarioViewController.swift
//  Primerproyecto21
//
//  Created by Bootcamp on 2025-03-04.
//

import UIKit

class NuevoUsuarioViewController: UIViewController {
    
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var IngreseCorreoTextField: UITextField!
    @IBOutlet weak var IngreseUsuarioTextField: UITextField!
    @IBOutlet weak var nuevoUsuaarioTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usuarioTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var resultadoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultadoLabel.text = ""
    }
    
    @IBAction func enviarDatos(_ sender: UIButton) {
        guard let usuario = usuarioTextField.text, !usuario.isEmpty,
              let correo = correoTextField.text, !correo.isEmpty else {
            resultadoLabel.text = "Por favor, completa todos los campos."
            return
        }
        
        resultadoLabel.text = "Usuario: \(usuario)\nCorreo: \(correo)"
    }
}
