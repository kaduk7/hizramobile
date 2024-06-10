import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hizramobile/models/http_login.dart';
import 'package:hizramobile/pages/home_page.dart';
import 'package:hizramobile/utils/animations.dart';
import 'package:provider/provider.dart';

import '../data/bg_data.dart';
import '../utils/text_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0;
  bool showOption = false;
  @override
  Widget build(BuildContext context) {
    final dataLogin = Provider.of<HttpLogin>(context, listen: false);
    final TextEditingController myUsernama = TextEditingController();
    final TextEditingController myPassword = TextEditingController();

    AlertDialog logingagal = AlertDialog(
      title: const Text('Gagal Login'),
      content: const Text('Usernama dan Password tidak valid'),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    void _login() async {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      String username = myUsernama.text;
      String password = myPassword.text;

      await dataLogin.koneksiAPI(username, password);

      Navigator.of(context).pop();

      if (dataLogin.pesan == 'Login berhasil') {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
        ;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return logingagal;
          },
        );
      }
    }

    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: showOption
                    ? ShowUpAnimation(
                        delay: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: bgList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: selectedIndex == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                        bgList[index],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : const SizedBox()),
            const SizedBox(
              width: 20,
            ),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            bgList[selectedIndex],
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: Container(
        
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgList[selectedIndex]), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            
            SizedBox(
              
              width: 150,
              height: 190,
              child: Image.asset("images/favico.png"),
            ),
            // SizedBox(height: 10),

            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.1),
              ),
              
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Center(
                              child: TextUtil(
                            text: "Login",
                            weight: true,
                            size: 30,
                          )),
                          const Spacer(),
                          // TextUtil(
                          //   text: "Email",
                          // ),
                          // Container(
                          //   height: 35,
                          //   decoration: const BoxDecoration(
                          //       border: Border(
                          //           bottom: BorderSide(color: Colors.white))),
                          //   child: TextFormField(
                          //     style: const TextStyle(color: Colors.white),
                          //     decoration: const InputDecoration(
                          //       suffixIcon: Icon(
                          //         Icons.mail,
                          //         color: Colors.white,
                          //       ),
                          //       fillColor: Colors.white,
                          //       border: InputBorder.none,
                          //     ),
                          //   ),
                          // ),
                          // const Spacer(),
                          // TextUtil(
                          //   text: "Password",
                          // ),
                          // Container(
                          //   height: 35,
                          //   decoration: const BoxDecoration(
                          //       border: Border(
                          //           bottom: BorderSide(color: Colors.white))),
                          //   child: TextFormField(
                          //     style: const TextStyle(color: Colors.white),
                          //     decoration: const InputDecoration(
                          //       suffixIcon: Icon(
                          //         Icons.lock,
                          //         color: Colors.white,
                          //       ),
                          //       fillColor: Colors.white,
                          //       border: InputBorder.none,
                          //     ),
                          //   ),
                          // ),
                          // const Spacer(),
                          TextUtil(
                            text: "Usernama",
                          ),
                          Container(
                            height: 35,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: TextField(
                              controller: myUsernama,
                              onSubmitted: (value) => (print(value)),
                              autocorrect: false,
                              showCursor: true,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                ),
                                fillColor: Colors.white,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextUtil(
                            text: "Password",
                          ),
                          Container(
                            height: 35,
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: TextField(
                              controller: myPassword,
                              onSubmitted: (value) => (print(value)),
                              autocorrect: false,
                              showCursor: true,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                                fillColor: Colors.white,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Row(
                          //   children: [
                          //     Container(
                          //       height: 15,
                          //       width: 15,
                          //       color: Colors.white,
                          //     ),
                          //    const  SizedBox(width: 10,),
                          //     Expanded(child: TextUtil(text: "Remember Me , FORGET PASSWORD",size: 12,weight: true,))
                          //   ],
                          // ),

                          const Spacer(),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: OutlinedButton(
                              onPressed: _login,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  // fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // const Spacer(),
                          // Center(
                          //     child: TextUtil(
                          //   text: "Don't have a account REGISTER",
                          //   size: 12,
                          //   weight: true,
                          // )),
                          const Spacer(),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
