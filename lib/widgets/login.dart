import 'package:flutter/material.dart';
import 'package:hizramobile/models/http_login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final dataLogin = Provider.of<HttpLogin>(context, listen: false);
    final TextEditingController usernama = TextEditingController();
    final TextEditingController password = TextEditingController();
    String user = usernama.text;
    String pass = password.text;
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("images/logohks.png"),
              ),
              SizedBox(height: 30),
              TextField(
                controller: usernama,
                onSubmitted: (value) => (print(value)),
                autocorrect: false,
                showCursor: true,
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    size: 35,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  labelText: "Usernama",
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: password,
                onSubmitted: (value) => (print(value)),
                autocorrect: false,
                showCursor: true,
                cursorColor: Colors.black,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.key,
                    size: 35,
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {},
                  ),
                  labelText: "Password",
                ),
              ),
              SizedBox(height: 40),
              OutlinedButton(
                onPressed: () {
                  dataLogin.koneksiAPI('ayu@gmail.com', '123');
                },
                child: Text(
                  "Login",
                  style: TextStyle(
                    // fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                child: Consumer<HttpLogin>(
                  builder: (context, value, child) => Text(
                    (value.data["usernama"] == null)
                        ? "usernama : Belum ada data"
                        : " ${value.data["usernama"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FittedBox(
                child: Consumer<HttpLogin>(
                  builder: (context, value, child) => Text(
                    (value.data["status"] == null)
                        ? " Status:Belum ada data"
                        : "${value.data["status"]}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              ElevatedButton(
                // color: Colors.blue,
                // textColor: Colors.white,
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (context) {
                  //     return Coba();
                  //   }),
                  // );
                },

                // String username = myUsername.text;
                // String password = myPassword.text;

                // if (username.isNotEmpty && password.isNotEmpty) {
                //   print('Login successful');
                //   print(myUsername.text);
                //   print(myPassword.text);
                // } else {
                //   print('Username and password are required');
                // }
                child: Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
