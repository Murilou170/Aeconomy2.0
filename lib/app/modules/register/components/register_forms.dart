import 'package:aeconomy/app/modules/home/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aeconomy/app/modules/sing_in/usuario.dart';

class RegisterForms extends StatefulWidget {
  const RegisterForms({Key? key}) : super(key: key);

  @override
  _RegisterFormsState createState() => _RegisterFormsState();
}

class _RegisterFormsState extends State<RegisterForms> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerSobrenome = TextEditingController();
  TextEditingController _controllercep = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String sobrenome = _controllerSobrenome.text;
    String cep = _controllercep.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (sobrenome.isNotEmpty) {
        if (cep.isNotEmpty && cep.length == 9) {
          if (email.isNotEmpty && email.contains("@")) {
            if (senha.isNotEmpty && senha.length > 6) {
              setState(() {
                _mensagemErro = "";
              });

              Usuario usuario = Usuario(nome, sobrenome, cep, email, senha);
              usuario.nome = nome;
              usuario.sobrenome = sobrenome;
              usuario.cep = cep;
              usuario.email = email;
              usuario.senha = senha;
              _cadastrarUsuario(usuario);
            } else {
              setState(() {
                _mensagemErro =
                    "Preencha a senha corretamente com mais de 6 caracteres";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Preencha o E-mail corretamente utilizando @";
            });
          }
        } else {
          setState(() {
            _mensagemErro =
                "Preencha o campo de CEP com um valor válido ex: 55641-715";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha seu sobrenome";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha seu nome";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    )
        .then((firebaseUser) {
      FirebaseFirestore.instance
          .collection("Usuários")
          .doc(firebaseUser.user!.uid)
          .set(usuario.toMap());

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error) {
      setState(() {
        _mensagemErro =
            "Erro ao cadastrar usuário, verifique os campos e tente novamente";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controllerNome,
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              hintText: "Primeiro Nome",
              filled: true,
              fillColor: Colors.grey[100],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _controllerSobrenome,
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              hintText: "Segundo Nome",
              filled: true,
              fillColor: Colors.grey[100],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _controllercep,
            autofocus: true,
            keyboardType: TextInputType.streetAddress,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              hintText: "CEP",
              filled: true,
              fillColor: Colors.grey[100],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(height: 20),
          TextField(
              controller: _controllerEmail,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                
                hintText: "E-mail",
                filled: true,
                fillColor: Colors.grey[100],
                border:  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),),
              SizedBox(height: 20),
          TextField(
            controller: _controllerSenha,
            autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              hintText: "Senha",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            obscureText: true,
          ),
          SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              child: Text(
                "Cadastrar",
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              onPressed: () {
                _validarCampos();
              },
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(250, 255, 99, 71),
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  )),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              _mensagemErro,
              style: TextStyle(color: Colors.redAccent, fontSize: 26),
            ),
          )
        ],
      ),
    );
  }
}