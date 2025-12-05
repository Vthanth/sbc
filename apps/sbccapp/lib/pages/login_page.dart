import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/assets.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/stores/user.store.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userStore = locator<UserStore>();
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // Define the specific blue color from the design
  final Color _primaryBlue = const Color(0xFF004a99);
  // Define color for input icons and hint text
  final Color _inputGrey = Colors.grey.shade600;

  late ReactionDisposer _errorMessageDisposer;
  late ReactionDisposer _loginStatusDisposer;

  @override
  void initState() {
    super.initState();
    
    _loginStatusDisposer = reaction<bool>((_) => _userStore.isLoggedIn, (isLoggedIn) {
      if (isLoggedIn) {
        if (_userStore.isApprovalRequired) {
          context.go('/confirmation');
        } else {
          context.go('/home');
        }
      }
    });
    
    // Monitor error messages from the store
    _errorMessageDisposer = reaction<String>((_) => _userStore.errorMessage, (errorMessage) {
      if (mounted) {
        setState(() {
          _errorMessage = errorMessage.isNotEmpty ? errorMessage : null;
        });
      }
    });
    
    _emailController.text = 'staff@test.com';
    _passwordController.text = 'password';
  }

  @override
  void dispose() {
    _errorMessageDisposer();
    _loginStatusDisposer();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Clear any previous error
      });

      try {
        await _userStore.login(email: _emailController.text, password: _passwordController.text);
        
        // The error message will be automatically updated via the reaction
        // Just ensure we show it if login failed
        if (!_userStore.isLoggedIn && _userStore.errorMessage.isEmpty) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Login failed. Please check your credentials.';
            });
          }
        }
      } catch (e) {
        // This should rarely happen as UserStore handles errors internally
        // But just in case, show a generic error
        if (mounted) {
          setState(() {
            _errorMessage = 'An unexpected error occurred. Please try again.';
          });
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Stack(
      children: [
        // 1. White background base
        Positioned.fill(
          child: Container(
            color: Colors.white,
          ),
        ),
        // 2. Background Image Layer - using the background.jpg image
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg', // Using JPG background image
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // If image fails to load, show white background
              return Container(color: Colors.white);
            },
          ),
        ),

        // 2. Main Content Layer
        Scaffold(
          backgroundColor: Colors.transparent, // Crucial for showing the Stack background
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // --- LOGO ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Image.asset(
                          Images.sbcLogo.assetName,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // --- EMAIL SECTION ---
                      _buildLabelText("Email Address"),
                      const SizedBox(height: 10),
                      _buildEmailField(),

                      const SizedBox(height: 25),

                      // --- PASSWORD SECTION ---
                      _buildLabelText("Password"),
                      const SizedBox(height: 10),
                      _buildPasswordField(),

                      if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700, fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // --- LOGIN BUTTON ---
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.arrow_forward, size: 24),
                                  SizedBox(width: 10),
                                  Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabelText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: _primaryBlue, // Ensure the label text is blue
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (_errorMessage != null) {
          setState(() {
            _errorMessage = null;
          });
        }
      },
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "staff@test.com",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[500], size: 22),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      onChanged: (value) {
        if (_errorMessage != null) {
          setState(() {
            _errorMessage = null;
          });
        }
      },
      style: TextStyle(color: Colors.grey[900], fontSize: 16),
      decoration: InputDecoration(
        filled: false,
        hintText: "******************",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        prefixIcon: Icon(Icons.vpn_key_outlined, color: Colors.grey[500], size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.grey[500],
            size: 22,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}

/// Custom painter for drawing the star pattern background with fading effect
/// Stars are dense and dark at top/bottom, fading to almost invisible in center
/// Used as fallback if background image fails to load
class StarPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final baseStarSize = 6.0;
    final spacing = 18.0; // Dense spacing for more stars
    final fadeHeight = size.height * 0.2; // Fade area at top and bottom

    // Draw stars in a grid pattern
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Calculate opacity and size based on distance from top and bottom
        double opacity = 1.0;
        double starSize = baseStarSize;
        
        if (y < fadeHeight) {
          // Top section - stars are darker and larger at the very top, fade as we go down
          double progress = y / fadeHeight;
          opacity = 0.9 - (0.85 * progress); // Start at 0.9 opacity at top, fade to 0.05
          starSize = baseStarSize * (1.2 - (0.9 * progress)); // Larger at top, smaller as we go down
        } else if (y > size.height - fadeHeight) {
          // Bottom section - stars are darker and larger at the very bottom, fade as we go up
          double progress = (size.height - y) / fadeHeight;
          opacity = 0.9 - (0.85 * progress); // Start at 0.9 opacity at bottom, fade to 0.05
          starSize = baseStarSize * (1.2 - (0.9 * progress)); // Larger at bottom, smaller as we go up
        } else {
          // Center area - very light, almost invisible, very small stars
          double centerY = size.height / 2;
          double distanceFromCenter = (y - centerY).abs();
          double maxDistance = (size.height / 2) - fadeHeight;
          double fadeProgress = (distanceFromCenter / maxDistance).clamp(0.0, 1.0);
          
          // Very faint in center, slightly more visible near fade zones
          opacity = 0.02 + (0.03 * fadeProgress);
          starSize = baseStarSize * 0.4; // Much smaller in center
        }
        
        // Only draw stars with sufficient opacity
        if (opacity > 0.01) {
          paint.color = const Color(0xFF004a99).withOpacity(opacity.clamp(0.0, 1.0));
          _drawStar(canvas, Offset(x, y), starSize.clamp(1.0, baseStarSize * 1.5), paint);
        }
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final angle = (math.pi * 2) / 4; // 4-pointed star
    
    // Draw a 4-pointed star (diamond shape)
    for (int i = 0; i < 4; i++) {
      final x = center.dx + size * math.cos(i * angle - math.pi / 2);
      final y = center.dy + size * math.sin(i * angle - math.pi / 2);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
