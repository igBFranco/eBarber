import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/main.dart';
import 'package:ebarber/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  const Register({Key? key, required this.onClickedSignIn}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future createNewUserOnDatabase([DocumentSnapshot? documentSnapshot]) async {
    final user = FirebaseAuth.instance.currentUser!;

    if (documentSnapshot == null) {
      await _users.doc(user.uid).set({
        "name": nameController.text,
        "email": user.email,
        "phone": phoneController.text
      });
      user.updateDisplayName(nameController.text);
      user.updatePhotoURL(
          'https://cdn-icons-png.flaticon.com/512/7752/7752992.png');
    }
    //phoneController.text = '';
    //Navigator.pop(context);
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      createNewUserOnDatabase();
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Center(
                  child: SizedBox(
                      width: 100,
                      child: Image.asset('assets/images/logo.png'))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Center(
                  child: Text(
                "Cadastro",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Nome', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Digite um email válido'
                              : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? 'A senha deve possuir pelo menos 6 caracteres'
                          : null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        signUp();
                      },
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: Color(0xFF777777)),
                text: 'Já possui uma conta?',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignIn,
                    text: ' Faça Login',
                    style: TextStyle(
                        color: Color(0xFF0DA6DF), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
