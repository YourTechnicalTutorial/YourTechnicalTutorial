import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Please fill all required fields.");
      return;
    }

    if (password != confirm) {
      setState(() => _errorMessage = "Passwords do not match.");
      return;
    }

    setState(() {
      isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await AuthService.signup(email, password);
      
      if (!mounted) return;
      setState(() => isLoading = false);
      print("SIGNUP RESPONSE: $result"); // 🔥 IMPORTANT DEBUG

      if (result['success'] == true) {
        // Save State
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        setState(() => _errorMessage = result['message'] ?? "Signup failed.");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        _errorMessage = "Connection error. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF111C2E), Color(0xFF16263F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Container(
              width: 480,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.9),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 20)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add_rounded, size: 48, color: Color(0xFF3B82F6)),
                  const SizedBox(height: 24),
                  const Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text("Start your learning journey today", style: TextStyle(color: Colors.white60, fontSize: 16)),
                  const SizedBox(height: 48),

                  _buildField(label: "Email", controller: emailController, icon: Icons.email_outlined),
                  const SizedBox(height: 24),
                  _buildField(
                    label: "Password",
                    controller: passwordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscure: _obscurePassword,
                    toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  const SizedBox(height: 24),
                  _buildField(
                    label: "Confirm Password",
                    controller: confirmPasswordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscure: _obscurePassword,
                  ),

                  if (_errorMessage != null)
                    Padding(padding: const EdgeInsets.only(top: 20), child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent))),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: isLoading ? null : _handleSignup,
                      child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Create Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Already have an account? Log In", style: TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({required String label, required TextEditingController controller, required IconData icon, bool isPassword = false, bool obscure = false, VoidCallback? toggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.1))),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.white38, size: 20),
              suffixIcon: isPassword && toggle != null ? IconButton(icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white38, size: 20), onPressed: toggle) : null,
              border: InputBorder.none,
              hintText: "Enter your $label",
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
