import 'package:flutter/material.dart';

// Rutas relativas correctas
import 'package:reminder_app/Authtentication/signup.dart';
import 'package:reminder_app/JsonModels/users.dart';
import 'package:reminder_app/SQLite/sqlite.dart';
import 'package:reminder_app/Views/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool isVisible = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  final formKey = GlobalKey<FormState>();

login() async {
  final enteredUser = username.text.trim();
  final enteredPass = password.text;

  final ok = await db.login(
    Users(
      usrName: enteredUser,
      usrPassword: enteredPass,
    ),
  );

  if (ok) {
    if (!mounted) return;

    // feedback verde
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bienvenido $enteredUser'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          username: enteredUser,
        ),
      ),
    );
  } else {
    if (!mounted) return;

    setState(() {
      isLoginTrue = true;
    });

    // feedback rojo con lo que intentaste
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No coincide en la base de datos.\nuser: "$enteredUser"\npass: "$enteredPass"',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    final bgYellow = const Color(0xFFFFFACA); // amarillo pastel suave
    final inputBg = const Color(0xFFF6F6FF); // fondo campos moradito claro
    final borderRadiusAll = BorderRadius.circular(24);

    return Scaffold(
      backgroundColor: bgYellow, // <- pantalla completa amarilla
      body: SafeArea(
        child: Stack(
          children: [
            // ===== FIGURA ARRIBA DERECHA =====
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'lib/assets/shapes.png',
                width: 110,
                fit: BoxFit.contain,
              ),
            ),

            // ===== FIGURA ABAJO IZQUIERDA =====
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'lib/assets/shapes.png',
                width: 110,
                fit: BoxFit.contain,
              ),
            ),

            // ===== CONTENIDO SCROLLEABLE =====
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // título centrado
                  const Center(
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== Usuario =====
                        const Text(
                          'Usuario:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: borderRadiusAll,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El usuario es obligatorio';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'example@gmail.com',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB9B9C5),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ===== Contraseña =====
                        const Text(
                          'Contraseña:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: borderRadiusAll,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: TextFormField(
                            controller: password,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La contraseña es obligatoria';
                              }
                              return null;
                            },
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '•••••',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB9B9C5),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(
                                  isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ===== Botón Iniciar Sesión =====
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5A58),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: borderRadiusAll,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                login();
                              }
                            },
                            child: const Text('Iniciar Sesión'),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ===== Registrarse / ó =====
                        Center(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'ó',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ===== Gmail =====
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: borderRadiusAll,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/assets/google.png',
                                  height: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Gmail',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== Facebook =====
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: inputBg,
                            borderRadius: borderRadiusAll,
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/assets/facebook.png',
                                  height: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Facebook',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (isLoginTrue)
                          const Center(
                            child: Text(
                              'Usuario o contraseña incorrectos',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
