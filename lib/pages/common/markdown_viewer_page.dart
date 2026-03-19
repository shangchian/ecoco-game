import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '/constants/colors.dart';

@RoutePage()
class MarkdownViewerPage extends StatefulWidget {
  final String title;
  final String? tagText;
  final String? contentTitle;
  final String? url;
  final String? localAssetPath;
  final String? pageType;

  const MarkdownViewerPage({
    super.key,
    required this.title,
    this.tagText,
    this.contentTitle,
    this.url,
    this.localAssetPath,
    this.pageType,
  });

  @override
  State<MarkdownViewerPage> createState() => _MarkdownViewerPageState();
}

class _MarkdownViewerPageState extends State<MarkdownViewerPage> {
  String? _markdownContent;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    final hasLocalAsset = widget.localAssetPath?.isNotEmpty == true;
    final hasUrl = widget.url?.isNotEmpty == true;

    if (!hasLocalAsset && !hasUrl) {
      setState(() {
        _error = '無效的連結';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      String content;
      if (hasLocalAsset) {
        content = await rootBundle.loadString(widget.localAssetPath!);
      } else {
        final dio = Dio();
        final response = await dio.get(
          widget.url!,
          options: Options(
            responseType: ResponseType.plain,
            validateStatus: (status) => status == 200,
          ),
        );
        content = response.data as String;
      }

      if (mounted) {
        setState(() {
          _markdownContent = content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '載入內容失敗';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryHighlightColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.secondaryTextColor,
            size: 24,
          ),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          widget.title == '服務條款與隱私權政策'
              ? widget.title
              : (widget.pageType == 'announcement'
                    ? '公告'
                    : (widget.pageType == 'campaign' ? '活動' : widget.title)),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryHighlightColor,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMarkdown,
              child: const Text(
                '重試',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.contentTitle != null) ...[
              Text(
                widget.contentTitle!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_markdownContent != null)
              Markdown(
                data: _markdownContent!,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(
                  h1: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                      top: BorderSide(width: 0.6, color: Colors.grey),
                    ),
                  ),
                ),
                onTapLink: (text, href, title) async {
                  if (href != null) {
                    final uri = Uri.parse(href);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
              )
            else
              const Text(
                '無內容',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
