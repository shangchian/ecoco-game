import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '/constants/colors.dart';

/// Terms and Privacy Dialog Widget
///
/// This dialog displays the terms of service and privacy policy.
/// It has two modes:
///
/// 1. requireScrollToBottom: true (Mode 1)
///    - Shows two buttons: "同意" (orange) and "不同意" (blue)
///    - Buttons are disabled (gray) until user scrolls to bottom
///    - Shows instruction text
///    - Returns true for agree, false for disagree
///
/// 2. requireScrollToBottom: false (Mode 2)
///    - Shows single "確認" button (orange)
///    - Button is always enabled
///    - No scroll requirement
///    - Returns true on confirm
class TermsAndPrivacyDialog extends StatefulWidget {
  final bool requireScrollToBottom;

  const TermsAndPrivacyDialog({
    super.key,
    this.requireScrollToBottom = false,
  });

  @override
  State<TermsAndPrivacyDialog> createState() => _TermsAndPrivacyDialogState();

  /// Show the dialog with a semi-transparent backdrop
  static Future<bool?> show(
    BuildContext context, {
    bool requireScrollToBottom = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => TermsAndPrivacyDialog(
        requireScrollToBottom: requireScrollToBottom,
      ),
    );
  }
}

class _TermsAndPrivacyDialogState extends State<TermsAndPrivacyDialog> {
  String _markdownContent = '';
  bool _isLoading = true;
  bool _hasScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMarkdownContent();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      // Consider scrolled to bottom if within 10 pixels of the bottom
      if (maxScroll - currentScroll <= 10) {
        if (!_hasScrolledToBottom) {
          setState(() {
            _hasScrolledToBottom = true;
          });
        }
      }
    }
  }

  Future<void> _loadMarkdownContent() async {
    try {
      final content = await rootBundle.loadString('assets/data/tos.md');
      setState(() {
        _markdownContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _markdownContent = '無法載入服務條款內容';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Terms of Service & Privacy Policy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Text(
                      '服務條款及隱私權政策',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),


              // Content
              Flexible(
                child: _isLoading
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryHighlightColor,
                    ),
                  ),
                )
                    : Markdown(
                  controller: _scrollController,
                  data: _markdownContent,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 10, bottom: 10),
                  styleSheet: MarkdownStyleSheet(
                    h1: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                    h2: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    p: const TextStyle(
                      fontSize: 14,
                      height: 1.0,
                      color: Colors.black87,
                    ),
                    listBullet: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    horizontalRuleDecoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 0.6,            // 這裡設定粗細度
                          color: Colors.grey,    // 這裡設定線條顏色
                        ),
                      ),
                    ),
                  ),
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final uri = Uri.parse(href);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    }
                  },
                ),
              ),

              // Scroll instruction (only show in requireScrollToBottom mode)
              if (widget.requireScrollToBottom)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: const Text(
                    '要閱讀完全文才能按下確認哦！',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.formFieldErrorBorder,
                    ),
                  ),
                ),

              // Buttons based on mode
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: widget.requireScrollToBottom
                    ? _buildTwoButtonMode()
                    : _buildSingleButtonMode(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build two button mode: "同意" and "不同意"
  Widget _buildTwoButtonMode() {
    final bool isEnabled = _hasScrolledToBottom;

    return Row(
      children: [
        // 同意 button (orange)
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: isEnabled ? () => Navigator.pop(context, true) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? AppColors.termsAgreeButton
                    : AppColors.termsDisabledButton,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                disabledBackgroundColor: AppColors.termsDisabledButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                '同意',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // 不同意 button (blue)
        Expanded(
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, false),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.primaryDisabledColor,
                side: BorderSide(
                  color:AppColors.secondaryValueColor,
                  width: 1,
                ),
                foregroundColor: AppColors.secondaryValueColor,
                disabledForegroundColor: Colors.white,
                disabledBackgroundColor: AppColors.termsDisabledButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                '不同意',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Build single button mode: "確認" (always enabled)
  Widget _buildSingleButtonMode() {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.termsAgreeButton,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: const Text(
          '確認',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
