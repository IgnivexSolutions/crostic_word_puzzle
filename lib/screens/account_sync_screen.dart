import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_account.dart';
import '../services/sound_service.dart';
import '../services/sync_service.dart';
import '../services/storage_service.dart';

class AccountSyncScreen extends StatefulWidget {
  final UserAccount user;
  final Function(UserAccount updated) onUserUpdated;

  const AccountSyncScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<AccountSyncScreen> createState() => _AccountSyncScreenState();
}

class _AccountSyncScreenState extends State<AccountSyncScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SyncService _sync = SyncService();
  final SoundService _sound = SoundService();
  final StorageService _storage = StorageService();

  final TextEditingController _syncCodeController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccessMessage = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _syncCodeController.dispose();
    _registerUsernameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _showMessage(String msg, {bool isSuccess = true}) {
    setState(() {
      _statusMessage = msg;
      _isSuccessMessage = isSuccess;
    });
    if (isSuccess) {
      _sound.playWordComplete();
    } else {
      _sound.playError();
    }
  }

  Future<void> _handleDeviceSync() async {
    final code = _syncCodeController.text.trim();
    if (code.isEmpty) {
      _showMessage('Please enter a 6-digit Sync Code.', isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);
    final result = await _sync.syncFromDeviceCode(code);
    setState(() => _isLoading = false);

    if (result.success && result.account != null) {
      widget.onUserUpdated(result.account!);
      _showMessage(result.message, isSuccess: true);
    } else {
      _showMessage(result.message, isSuccess: false);
    }
  }

  Future<void> _handleRegister() async {
    final username = _registerUsernameController.text.trim();
    final email = _registerEmailController.text.trim();
    final pass = _registerPasswordController.text;

    if (username.isEmpty || email.isEmpty || pass.isEmpty) {
      _showMessage('Please fill in all registration fields.', isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);
    final result = await _sync.createOnlineAccount(
      username: username,
      email: email,
      password: pass,
      displayName: username,
    );
    setState(() => _isLoading = false);

    if (result.success && result.account != null) {
      widget.onUserUpdated(result.account!);
      _showMessage(result.message, isSuccess: true);
    } else {
      _showMessage(result.message, isSuccess: false);
    }
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final pass = _loginPasswordController.text;

    if (email.isEmpty || pass.isEmpty) {
      _showMessage('Please enter email and password.', isSuccess: false);
      return;
    }

    setState(() => _isLoading = true);
    final result = await _sync.loginAccount(email: email, password: pass);
    setState(() => _isLoading = false);

    if (result.success && result.account != null) {
      widget.onUserUpdated(result.account!);
      _showMessage(result.message, isSuccess: true);
    } else {
      _showMessage(result.message, isSuccess: false);
    }
  }

  void _copySyncCode() {
    Clipboard.setData(ClipboardData(text: widget.user.syncCode));
    _sound.playKeyTap();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sync Code ${widget.user.syncCode} copied to clipboard!'),
        backgroundColor: const Color(0xFF0284C7),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Student Profile & Cloud Sync',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0284C7),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF0284C7),
          tabs: const [
            Tab(text: 'Device Sync'),
            Tab(text: 'Sign Up'),
            Tab(text: 'Log In'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // Current User Card
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8.0, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFBAE6FD),
                      child: Text(
                        widget.user.displayName.isNotEmpty
                            ? widget.user.displayName[0].toUpperCase()
                            : 'S',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.displayName,
                            style: GoogleFonts.spaceGrotesk(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.user.email,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: const Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  '🪙 ${widget.user.coins} Coins',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF92400E),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  '📚 ${widget.user.learnedWords.length} Words',
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Status Message Box
              if (_statusMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: _isSuccessMessage ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: _isSuccessMessage ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccessMessage ? Icons.check_circle_rounded : Icons.error_rounded,
                        color: _isSuccessMessage ? const Color(0xFF059669) : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: _isSuccessMessage ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Tab Content Area
              SizedBox(
                height: 380,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab 1: Device Sync Code
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Device Sync Code',
                            style: GoogleFonts.spaceGrotesk(fontSize: 15.0, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.user.syncCode,
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.0,
                                    color: const Color(0xFF0284C7),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy_rounded, color: Color(0xFF0284C7)),
                                  onPressed: _copySyncCode,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Enter this code on another phone, tablet, or PC to seamlessly transfer your stars, coins, and unlocked levels.',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12.0, color: const Color(0xFF64748B)),
                          ),
                          const Divider(height: 24.0),
                          Text(
                            'Pair Another Device',
                            style: GoogleFonts.spaceGrotesk(fontSize: 15.0, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: _syncCodeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'e.g. CR-9041',
                              prefixIcon: const Icon(Icons.phonelink_setup_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: _isLoading ? null : _handleDeviceSync,
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Sync Progress From Code',
                                      style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab 2: Create Account
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _registerUsernameController,
                            decoration: InputDecoration(
                              labelText: 'Student Username',
                              prefixIcon: const Icon(Icons.person_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: _registerEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            controller: _registerPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: _isLoading ? null : _handleRegister,
                              child: Text(
                                'Create Online Account',
                                style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab 3: Log In
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          TextField(
                            controller: _loginPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0284C7),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                              child: Text(
                                'Log In & Download Cloud Save',
                                style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
