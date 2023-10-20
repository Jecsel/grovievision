import 'package:flutter/material.dart';
import 'package:grovievision/models/UserModel.dart';
import 'package:grovievision/screens/admin.dart';
import 'package:grovievision/screens/home.dart';
import 'package:grovievision/screens/user_choice.dart';
import 'package:grovievision/service/mangroveDatabaseHelper.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import 'home.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  var isLogin = false;

  bool _obscurePassword = true;
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

    Future<void> _login() async {
    isLogin = await dbHelper.loginUser(_controllerUsername.text, _controllerPassword.text);

    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AdminScreen();
          },
        ),
      );
    }
    print("==========isLogin===========");
    print(isLogin);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // if (_boxLogin.get("loginStatus") ?? false) {
    //   return Home();
    // }

    return MaterialApp(
    home: Scaffold(
        appBar: AppBar( 
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserChoice()));
            },
          ),
          title: Text('Login'), // Add your app title here
        ),
        body: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(228, 0, 200, 83), Color.fromARGB(236, 0, 214, 50)], // Gradient colors
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Text(
                    "Welcome back",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Login to your account",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    controller: _controllerUsername,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onEditingComplete: () => _focusNodePassword.requestFocus(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username.";
                      } else if (!_boxAccounts.containsKey(value)) {
                        return "Username is not registered.";
                      }
        
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _controllerPassword,
                    focusNode: _focusNodePassword,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: _obscurePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password.";
                      } else if (value !=
                          _boxAccounts.get(_controllerUsername.text)) {
                        return "Wrong password.";
                      }
        
                      return null;
                    },
                  ),
                  const SizedBox(height: 60),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20),
                          minimumSize: Size(double.infinity, 60)
                        ),
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) {
                          //         return AdminScreen();
                          //       },
                          //     ),
                          //   );
                          _login();

                          // if (isLogin) {
                          //   _boxLogin.put("loginStatus", true);
                          //   _boxLogin.put("userName", _controllerUsername.text);
        

                            
                          // }
                        },
                        child: const Text("Login"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
        
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Signup();
                                  },
                                ),
                              );
                            },
                            child: const Text("Signup"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
