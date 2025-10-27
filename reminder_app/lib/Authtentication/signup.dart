import 'package:flutter/material.dart';
import 'package:reminder_app/Authtentication/login.dart';
import 'package:reminder_app/JsonModels/users.dart';
import 'package:reminder_app/SQLite/sqlite.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();

  final usernameCtrl = TextEditingController();
  final birthdateCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool showPassword1 = false;
  bool showPassword2 = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFFFFECB); // amarillo pastel
    final inputBg = const Color(0xFFF8F8FF); // fondo de inputs
    final borderRadiusAll = BorderRadius.circular(12);
    final labelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ===== FIGURA ARRIBA DERECHA =====
            Positioned(
              top: -140,
              right: -100,
              child: Transform.rotate(
                angle: 0.5, // ≈ 28°
                child: Image.asset(
                  'lib/assets/shapes.png',
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ===== CONTENIDO (FORM) ENCIMA =====
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título
                      const Center(
                        child: Text(
                          'Registrar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Sans', // si tienes fuente
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ===== Usuario / correo =====
                      Text('Usuario:', style: labelStyle),
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
                          controller: usernameCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'example@gmail.com',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 92, 92, 86),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El usuario es obligatorio';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ===== Fecha de nacimiento =====
                      Text('Fecha de nacimiento:', style: labelStyle),
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
                          controller: birthdateCtrl,
                          readOnly: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Selecciona tu fecha',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today_rounded,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(
                                  now.year - 18, now.month, now.day),
                              firstDate: DateTime(1900),
                              lastDate: now,
                            );
                            if (picked != null) {
                              birthdateCtrl.text =
                                  '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La fecha de nacimiento es obligatoria';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ===== Contraseña =====
                      Text('Contraseña:', style: labelStyle),
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
                          controller: passwordCtrl,
                          obscureText: !showPassword1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword1 = !showPassword1;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La contraseña es obligatoria';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ===== Confirmar contraseña =====
                      Text('Contraseña:', style: labelStyle),
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
                          controller: confirmPasswordCtrl,
                          obscureText: !showPassword2,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Repite la contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword2 = !showPassword2;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirma tu contraseña';
                            } else if (value != passwordCtrl.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ===== Botón Registrar (rojo) =====
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF15B57), // rojo coral
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  final db = DatabaseHelper();

                                  try {
                                    // crear usuario nuevo
                                    await db.signup(
                                      Users(
                                        usrName: usernameCtrl.text.trim(),
                                        usrPassword: passwordCtrl.text,
                                        birthdate: birthdateCtrl.text,
                                      ),
                                    );

                                    // ir al login
                                    if (!mounted) return;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    // usuario ya existe
                                    if (!mounted) return;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Este usuario ya existe, inicia sesión 🩷'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Registrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== Separador "ó" =====
                      const Center(
                        child: Text(
                          'ó',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
                          onPressed: () {
                            // TODO: login con Google
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadiusAll,
                            ),
                          ),
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
                          onPressed: () {
                            // TODO: login con Facebook
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadiusAll,
                            ),
                          ),
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

                      const SizedBox(height: 24),

                      // ===== Ya tengo cuenta =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '¿Ya tienes cuenta?',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
