import 'package:flutter/material.dart';

import '../../../../core/di/app_dependencies.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String gender;
  final String? dateOfBirth;

  const ProfileScreen({
    super.key,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.gender = 'Male',
    this.dateOfBirth,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late String selectedGender;
  DateTime? _selectedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
    selectedGender = widget.gender;

    if (widget.dateOfBirth != null && widget.dateOfBirth!.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.dateOfBirth!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String get _formattedDob {
    if (_selectedDate == null) return '';
    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }

  String? get _dobForApi {
    if (_selectedDate == null) return null;
    return '${_selectedDate!.year}-'
        '${_selectedDate!.month.toString().padLeft(2, '0')}-'
        '${_selectedDate!.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFE0C238),
              surface: Color(0xFF29142A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your name.');
      return;
    }
    if (phone.isEmpty) {
      _showError('Please enter your phone number.');
      return;
    }
    if (email.isEmpty) {
      _showError('Please enter your email.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await AppDependencies.updateProfile(
        name: name,
        gender: selectedGender,
        email: email,
        phone: phone,
        dateOfBirth: _dobForApi,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D0A1D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ------------------------------------------------
              // BACK + TITLE
              // ------------------------------------------------
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'My Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 45),

              // ------------------------------------------------
              // AVATAR
              // ------------------------------------------------
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF65116B),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset(
                          selectedGender == 'Male'
                              ? 'assets/images/male.png'
                              : 'assets/images/female.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Change Avatar',
                      style: TextStyle(
                        color: Color(0xFF9D589E),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ------------------------------------------------
              // NAME
              // ------------------------------------------------
              _label('Name'),
              _inputField(controller: _nameController, hint: 'Enter your name'),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // PHONE
              // ------------------------------------------------
              _label('Phone number'),
              _inputField(
                controller: _phoneController,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // EMAIL
              // ------------------------------------------------
              _label('Email Address'),
              _inputField(
                controller: _emailController,
                hint: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // GENDER
              // ------------------------------------------------
              _label('Gender'),

              Row(
                children: [
                  Expanded(
                    child: _genderButton(
                      icon: Icons.male,
                      title: 'Male',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _genderButton(
                      icon: Icons.female,
                      title: 'Female',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ------------------------------------------------
              // DATE OF BIRTH
              // ------------------------------------------------
              _label('Date of birth'),

              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: const Color(0xFF29142A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formattedDob.isEmpty ? 'DD / MM / YYYY' : _formattedDob,
                    style: TextStyle(
                      color: _formattedDob.isEmpty
                          ? const Color(0xFF9D969D)
                          : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ------------------------------------------------
              // SAVE
              // ------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0C238),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // LABEL
  // ------------------------------------------------
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF9E8F9E),
          fontSize: 10,
        ),
      ),
    );
  }

  // ------------------------------------------------
  // EDITABLE INPUT FIELD
  // ------------------------------------------------
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 35,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF9D969D),
            fontSize: 12,
          ),
          filled: true,
          fillColor: const Color(0xFF29142A),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFFE0C238),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------
  // GENDER BUTTON
  // ------------------------------------------------
  Widget _genderButton({
    required IconData icon,
    required String title,
  }) {
    final bool selected = selectedGender == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = title;
        });
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xFF29142A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? const Color(0xFF7B397B)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFFB7A8B7),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFB7A8B7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
