import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'task_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                _inputField(context), // Passando o contexto para a função _inputField
                _signup(context), // Passando o contexto para a função _signup
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
            "Bem-vindo ao AXTask",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Faça o login!"),
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
          onPressed: () async {
            String username = _usernameController.text;
            String password = _passwordController.text;

            DatabaseHelper dbHelper = DatabaseHelper();
            int? userId = await dbHelper.authenticateUser(username, password);

            if (userId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskPage(userId: userId)),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('ERRO'),
                  content: Text('Usuário ou senha incorretos'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Color.fromARGB(255, 187, 184, 184),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        )
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Ainda não possui uma conta?"),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
          child: const Text(
            "Criar conta",
            style: TextStyle(color: Color.fromARGB(255, 112, 112, 112)),
          ),
        )
      ],
    );
  }
}
