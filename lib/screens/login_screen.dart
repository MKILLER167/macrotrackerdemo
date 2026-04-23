import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/user_cubit.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserProfile? generatedProfile;
  const LoginScreen({super.key, this.generatedProfile});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    if (widget.generatedProfile != null) {
      context.read<UserCubit>().completeOnboarding(widget.generatedProfile!);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  Future<void> _guest() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    if (widget.generatedProfile != null) {
      context.read<UserCubit>().completeOnboarding(widget.generatedProfile!);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppTheme.mint, AppTheme.violet], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: AppTheme.mint.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: const Icon(Icons.eco_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 28),
                const Text('Welcome back', style: TextStyle(color: AppTheme.muted, fontSize: 16)),
                const SizedBox(height: 4),
                const Text('Sign in to\nyour account', style: TextStyle(color: AppTheme.white, fontSize: 32, fontWeight: FontWeight.w800, height: 1.2)),
                const SizedBox(height: 36),

                // Email field
                const Text('Email', style: TextStyle(color: AppTheme.muted, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailC,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: const InputDecoration(hintText: 'you@example.com', prefixIcon: Icon(Icons.email_outlined, size: 20)),
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter email' : null,
                ),
                const SizedBox(height: 20),

                // Password field
                const Text('Password', style: TextStyle(color: AppTheme.muted, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passC,
                  obscureText: _obscure,
                  style: const TextStyle(color: AppTheme.white),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: AppTheme.muted),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter password' : null,
                ),
                const SizedBox(height: 32),

                // Sign in button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.mint,
                      disabledBackgroundColor: AppTheme.border,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _loading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Sign In', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Row(children: [
                  const Expanded(child: Divider(color: AppTheme.border)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: TextStyle(color: AppTheme.muted))),
                  const Expanded(child: Divider(color: AppTheme.border)),
                ]),
                const SizedBox(height: 16),

                // Guest button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _loading ? null : _guest,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.border, width: 1.5),
                      foregroundColor: AppTheme.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Continue as Guest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    widget.generatedProfile != null ? '✅ Your personalized nutrition plan is ready!' : 'Your nutrition journey starts here.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
