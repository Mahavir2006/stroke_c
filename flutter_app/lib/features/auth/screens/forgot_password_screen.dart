// Stroke Mitra - Forgot Password Screen
//
/// Password reset with animated gradient background and glass card.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;
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
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).resetPassword(
            _emailController.text.trim(),
          );
      final state = ref.read(authControllerProvider);
      if (!state.hasError) {
        setState(() => _emailSent = true);
      }
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
                  -1.0 + _bgController.value * 0.4,
                  -1.0 + _bgController.value * 0.4,
                ),
                end: Alignment(
                  1.0 - _bgController.value * 0.4,
                  1.0 - _bgController.value * 0.4,
                ),
                colors: isDark
                    ? [
                        const Color(0xFF0B1120),
                        const Color(0xFF1A0B2E),
                        const Color(0xFF0B1120),
                      ]
                    : [
                        const Color(0xFFFAFBFC),
                        const Color(0xFFF0FDFA),
                        const Color(0xFFEEF2FF),
                      ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spaceLG),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? colors.primarySurface
                                  : AppTheme.teal50,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Icon(
                              _emailSent
                                  ? Icons.mark_email_read_rounded
                                  : Icons.lock_reset_rounded,
                              color: theme.colorScheme.primary,
                              size: 28,
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

                          // Glass card
                          Container(
                            padding:
                                const EdgeInsets.all(AppTheme.spaceLG),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(
                                  AppTheme.radiusXL),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white
                                        .withValues(alpha: 0.08)
                                    : colors.cardBorder
                                        .withValues(alpha: 0.5),
                              ),
                              boxShadow:
                                  isDark ? [] : AppTheme.shadowLG,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: _emailSent
                                  ? _buildSuccessView(theme)
                                  : _buildFormView(
                                      theme, colors, authState),
                            ),
                          )
                              .animate()
                              .fadeIn(
                                  delay: 200.ms, duration: 500.ms)
                              .slideY(begin: 0.15, end: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.statusSuccess.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppTheme.statusSuccess,
            size: 32,
          ),
        )
            .animate()
            .scale(duration: 500.ms, curve: Curves.easeOutBack),
        const SizedBox(height: AppTheme.spaceMD),
        Text(
          context.l10n.auth_checkEmail,
          style: AppTheme.headingMD.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spaceSM),
        Text(
          context.l10n.auth_resetLinkSent(_emailController.text.trim()),
          style: AppTheme.bodyMD.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spaceLG),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(context.l10n.auth_backToLogin),
          ),
        ),
      ],
    );
  }

  Widget _buildFormView(
      ThemeData theme, AppColors colors, AsyncValue authState) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.auth_resetPassword,
            style: AppTheme.headingMD.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spaceXS),
          Text(
            context.l10n.auth_resetSubtitle,
            style: AppTheme.bodyMD.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
              if (value == null || value.isEmpty || !value.contains('@')) {
                return context.l10n.auth_validEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spaceLG),
          _GradientButton(
            onPressed: authState.isLoading ? null : _submit,
            isLoading: authState.isLoading,
            label: context.l10n.auth_sendResetLink,
            gradient: colors.heroGradient,
          ),
        ],
      ),
    );
  }
}

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
              boxShadow:
                  enabled ? AppTheme.shadowColored(AppTheme.primary) : null,
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
