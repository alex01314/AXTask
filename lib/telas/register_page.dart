import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _inputField(context),
                _login(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'imagens/axtasklogo.jpg', // Certifique-se de colocar o caminho correto para o seu arquivo de imagem
            width: 300, // Ajuste o tamanho conforme necessário
            height: 300,
          ),
          SizedBox(height: 10), // Espaço entre o logo e o texto
          Text(
            'Criar conta',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Preencha os dados para a criação da conta"),
        ],
      ),
    );
  }

  Widget _inputField(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: "Usuário",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: const Color.fromARGB(255, 163, 163, 163).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Senha",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: const Color.fromARGB(255, 163, 163, 163).withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            String username = _usernameController.text;
            String password = _passwordController.text;

            if (username.length < 6 || password.length < 6) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Erro'),
                  content: Text('O nome de usuário e a senha devem ter pelo menos 6 caracteres.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              DatabaseHelper dbHelper = DatabaseHelper();
              dbHelper.createUser(username, password);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromARGB(255, 184, 184, 184),
          ),
          child: const Text(
            "Criar conta",
            style: TextStyle(fontSize: 20,color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _login(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Já possui uma conta?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
          ),
        )
      ],
    );
  }
}
