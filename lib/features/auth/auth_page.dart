import 'package:flutter/material.dart';
import 'dart:ui';
import '../../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Please enter both email and password.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = _isSignUp
          ? await AuthService.signup(email, password)
          : await AuthService.login(email, password);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success']) {
        // Success: Go back to the website (home page)
        Navigator.of(context).pop(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSignUp ? "Account created successfully!" : "Logged in successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() => _errorMessage = result['message']);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = "An unexpected error occurred. Please try again.";
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
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 40,
              left: 40,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
                tooltip: "Back to Home",
              ),
            ),
            
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_person_rounded, size: 40, color: Color(0xFF3B82F6)),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isSignUp ? "Create Account" : "Access Your Account",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isSignUp 
                          ? "Join the circle of modern developers." 
                          : "Welcome back! Please enter your details.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      const SizedBox(height: 48),

                      // Email Field
                      _buildField(
                        label: "Email Address",
                        controller: _emailController,
                        hint: "email@example.com",
                        icon: Icons.alternate_email_rounded,
                      ),
                      const SizedBox(height: 24),

                      // Password Field
                      _buildField(
                        label: "Password",
                        controller: _passwordController,
                        hint: "••••••••",
                        icon: Icons.key_rounded,
                        isPassword: true,
                        obscure: _obscurePassword,
                        toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),

                      // Forgot & Remember
                      if (!_isSignUp)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24, width: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (v) => setState(() => _rememberMe = v!),
                                      activeColor: const Color(0xFF3B82F6),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("Keep me logged in", style: TextStyle(color: Colors.white60, fontSize: 14)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("Forgot?", style: TextStyle(color: Color(0xFF60A5FA))),
                              ),
                            ],
                          ),
                        ),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                        ),

                      const SizedBox(height: 48),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : _handleSubmit,
                          child: _isLoading
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                _isSignUp ? "Sign Up Now" : "Sign In",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Switch Login / Register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isSignUp ? "Already have an account?" : "New to the platform?",
                            style: const TextStyle(color: Colors.white54),
                          ),
                          TextButton(
                            onPressed: () => setState(() => _isSignUp = !_isSignUp),
                            child: Text(
                              _isSignUp ? "Log In" : "Create One",
                              style: const TextStyle(color: Color(0xFF60A5FA), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              prefixIcon: Icon(icon, color: Colors.white38, size: 20),
              suffixIcon: isPassword 
                ? IconButton(
                    icon: Icon(obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.white38, size: 20),
                    onPressed: toggle,
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
        ),
      ],
    );
  }
}
