import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CallConnectingScreen extends StatefulWidget {
  const CallConnectingScreen({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isVideoCall,
    this.videoCallUrl,
  });

  final String name;
  final String imagePath;
  final bool isVideoCall;
  final Uri? videoCallUrl;

  @override
  State<CallConnectingScreen> createState() => _CallConnectingScreenState();
}

class _CallConnectingScreenState extends State<CallConnectingScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isOpeningVideoCall = false;
  String? _launchError;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _elapsedSeconds += 1;
      });
    });

    if (widget.isVideoCall && widget.videoCallUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openVideoCall();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF210A20),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          child: Stack(
            children: [
              Center(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.isVideoCall ? 'Video calling...' : 'Calling...',
                        style: const TextStyle(
                          color: Color(0xFF8D7B8D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF5F0E60),
                          border: Border.all(
                            color: const Color(0xFF76257A),
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.isVideoCall
                            ? 'Opening your free video call room'
                            : 'Your call has started',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF8D7B8D),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _formatTime(_elapsedSeconds),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.isVideoCall && widget.videoCallUrl != null) ...[
                        const SizedBox(height: 22),
                        _buildVideoCallActions(),
                      ],
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 112,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF646D),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Icon(
                          widget.isVideoCall
                              ? Icons.videocam_off
                              : Icons.call_end,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(99),
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

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final String minuteLabel = minutes.toString().padLeft(2, '0');
    final String secondLabel = seconds.toString().padLeft(2, '0');
    return '$minuteLabel:$secondLabel';
  }

  Widget _buildVideoCallActions() {
    return Column(
      children: [
        SizedBox(
          width: 210,
          height: 46,
          child: FilledButton.icon(
            onPressed: _isOpeningVideoCall ? null : _openVideoCall,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE0C238),
              foregroundColor: Colors.black,
              disabledBackgroundColor: const Color(0xFF6B5D28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: _isOpeningVideoCall
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : const Icon(Icons.open_in_new),
            label: Text(_isOpeningVideoCall ? 'Opening...' : 'Open video room'),
          ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: _copyVideoCallLink,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy invite link'),
        ),
        if (_launchError != null) ...[
          const SizedBox(height: 8),
          Text(
            _launchError!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFF9BA1),
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _openVideoCall() async {
    final Uri? url = widget.videoCallUrl;
    if (url == null || _isOpeningVideoCall) {
      return;
    }

    setState(() {
      _isOpeningVideoCall = true;
      _launchError = null;
    });

    try {
      final bool didLaunch = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!didLaunch && mounted) {
        setState(() {
          _launchError = 'Could not open the video room. Copy the invite link instead.';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _launchError = 'Could not open the video room. Copy the invite link instead.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningVideoCall = false;
        });
      }
    }
  }

  Future<void> _copyVideoCallLink() async {
    final Uri? url = widget.videoCallUrl;
    if (url == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: url.toString()));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video call link copied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
