import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../profile_setup/presentation/screens/name_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _getOtp() async {
    final phone = _normalizedIndianPhone(_phoneController.text);

    if (phone.isEmpty) {
      _showError('Please enter your mobile number.');
      return;
    }

    if (phone.length != 10) {
      _showError('Please enter a valid 10-digit mobile number.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AppDependencies.sendOtp(phone);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phoneNumber: phone,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showError(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _normalizedIndianPhone(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length <= 10) return digitsOnly;
    return digitsOnly.substring(digitsOnly.length - 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 30,
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // -----------------------------------------
                // LOGO
                // -----------------------------------------
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0C238),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.favorite,
                          color: Color(0xFF561052),
                          size: 40,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // -----------------------------------------
                // TITLE
                // -----------------------------------------
                const Text(
                  'Login or Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 55),

                // -----------------------------------------
                // MOBILE NUMBER LABEL
                // -----------------------------------------
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mobile number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                // -----------------------------------------
                // PHONE INPUT
                // -----------------------------------------
                Row(
                  children: [
                    // Country code
                    Container(
                      height: 42,
                      width: 62,
                      decoration: BoxDecoration(
                        color: const Color(0xFF202020),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '🇮🇳',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '+91',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 7),

                    // Number field
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Enter mobile number',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF202020),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(7),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // -----------------------------------------
                // GET OTP BUTTON
                // -----------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _getOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFE0C238),
                      disabledBackgroundColor:
                          const Color(0xFF555555),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Get OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                // -----------------------------------------
                // TERMS
                // -----------------------------------------
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'By signing-up you agree to our ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Terms Of Use',
                        style: TextStyle(
                          color: Color(0xFFE0C238),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      ' & ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFE0C238),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
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
    );
  }
}


// ========================================================
// OTP SCREEN
// ========================================================

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController =
      TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.replaceAll(RegExp(r'\D'), '');
    final phone = _normalizedIndianPhone(widget.phoneNumber);

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 4-digit OTP.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      await AppDependencies.verifyOtp(
        phone: phone,
        otp: otp,
      );

      if (!mounted) return;

      setState(() {
        _isVerifying = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NameScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isVerifying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _isVerifying) return;
    final phone = _normalizedIndianPhone(widget.phoneNumber);

    setState(() => _isResending = true);

    try {
      await AppDependencies.sendOtp(phone);

      if (!mounted) return;
      _otpController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new OTP has been sent.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = _normalizedIndianPhone(widget.phoneNumber);

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
        ),
        child: Column(
          children: [
            const SizedBox(height: 200),

            const Text(
              'We just sent the OTP to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '+91 $phoneNumber',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            // -----------------------------------------
            // EDIT NUMBER
            // -----------------------------------------
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Edit Number',
                style: TextStyle(
                  color: Color(0xFFE0C238),
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // -----------------------------------------
            // OTP FIELD - CENTERED
            // -----------------------------------------
            Center(
              child: SizedBox(
                width: 230,
                child: TextField(
                  controller: _otpController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textAlign: TextAlign.center,
                  textAlignVertical:
                      TextAlignVertical.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 12,
                    fontWeight: FontWeight.bold,
                  ),

                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFF202020),
                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // -----------------------------------------
            // VERIFY BUTTON
            // -----------------------------------------
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed:
                    _isVerifying ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE0C238),
                  disabledBackgroundColor:
                      const Color(0xFF555555),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Verify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: _isResending || _isVerifying ? null : _resendOtp,
              child: Text(
                _isResending
                    ? 'Sending a new code...'
                    : "Didn't receive the code? Send Again",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _normalizedIndianPhone(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length <= 10) return digitsOnly;
    return digitsOnly.substring(digitsOnly.length - 10);
  }
}
