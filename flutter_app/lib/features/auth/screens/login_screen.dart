// Stroke Mitra - Login Screen
//
/// Premium glassmorphism auth card with animated gradient background.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authControllerProvider.notifier).signIn(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final isDark = context.isDark;

    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) {
        if (!state.isLoading && state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: AppTheme.statusError,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              ),
            ),
          );
        }
      },
    );

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(
                  -1.0 + _bgController.value * 0.5,
                  -1.0 + _bgController.value * 0.3,
                ),
                end: Alignment(
                  1.0 - _bgController.value * 0.3,
                  1.0 - _bgController.value * 0.5,
                ),
                colors: isDark
                    ? [
                        const Color(0xFF0B1120),
                        const Color(0xFF0B2027),
                        const Color(0xFF0B1120),
                      ]
                    : [
                        const Color(0xFFF0FDFA),
                        const Color(0xFFEEF2FF),
                        const Color(0xFFFAFBFC),
                      ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spaceLG),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo + Branding
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: colors.heroGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppTheme.shadowColored(AppTheme.primary),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                        .animate()
                        .scale(
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                          begin: const Offset(0.5, 0.5),
                        )
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: AppTheme.spaceMD),
                    Text(
                      'Stroke Mitra',
                      style: AppTheme.headingLG.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 150.ms, duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppTheme.spaceXL),

                    // Glass card
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spaceLG),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.white.withValues(alpha: 0.8),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusXL),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : colors.cardBorder.withValues(alpha: 0.5),
                        ),
                        boxShadow: isDark ? [] : AppTheme.shadowLG,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              context.l10n.auth_welcomeBack,
                              style: AppTheme.headingMD.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spaceXS),
                            Text(
                              context.l10n.auth_signInSubtitle,
                              style: AppTheme.bodyMD.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppTheme.spaceLG),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: context.l10n.auth_emailLabel,
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return context.l10n.auth_validEmail;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppTheme.spaceMD),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: context.l10n.auth_passwordLabel,
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return context.l10n.auth_validPassword;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: AppTheme.spaceSM),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.push('/forgot-password'),
                                style: TextButton.styleFrom(
                                  foregroundColor: theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                                child: Text(
                                  context.l10n.auth_forgotPassword,
                                  style: AppTheme.bodySM.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spaceMD),
                            _GradientButton(
                              onPressed: authState.isLoading ? null : _submit,
                              isLoading: authState.isLoading,
                              label: context.l10n.auth_signIn,
                              gradient: colors.ctaGradient,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideY(begin: 0.15, end: 0),

                    const SizedBox(height: AppTheme.spaceLG),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.auth_noAccount,
                          style: AppTheme.bodyMD.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/signup'),
                          child: Text(
                            context.l10n.auth_signUp,
                            style: AppTheme.bodyMD.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient-filled button used across auth screens.
class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;
  final Gradient gradient;

  const _GradientButton({
    required this.onPressed,
    required this.isLoading,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              boxShadow: enabled
                  ? AppTheme.shadowColored(AppTheme.primary)
                  : null,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      label,
                      style: AppTheme.bodyMD.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
