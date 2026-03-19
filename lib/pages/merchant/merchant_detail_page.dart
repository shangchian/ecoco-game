import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../models/brand_model.dart';

@RoutePage()
class MerchantDetailPage extends StatefulWidget {
  final Brand brand;

  const MerchantDetailPage({
    super.key,
    required this.brand,
  });

  @override
  State<MerchantDetailPage> createState() => _MerchantDetailPageState();
}

class _MerchantDetailPageState extends State<MerchantDetailPage> {
  String? _markdownContent;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.logEvent(
      name: 'view_item_list',
      parameters: {
        'list_name': widget.brand.name,
      },
    );
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    if (widget.brand.descriptionMdUrl == null || widget.brand.descriptionMdUrl!.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        widget.brand.descriptionMdUrl!,
        options: Options(
          responseType: ResponseType.plain,
          validateStatus: (status) => status == 200,
        ),
      );

      if (mounted) {
        setState(() {
          _markdownContent = response.data as String;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '載入商家介紹失敗';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          '商家介紹',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand header with logo and name
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Brand logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.brand.logoUrl ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildLogoPlaceholder(),
                      errorWidget: (context, url, error) => _buildLogoPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Brand name and category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category tag
                        if (widget.brand.category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.secondaryValueColor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.brand.category!.displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryValueColor
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        // Brand name
                        Text(
                          widget.brand.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 4, color: AppColors.greyBackground),

            // Description section (Markdown)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '商家介紹',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: AppColors.primaryHighlightColor,
                        ),
                      ),
                    )
                  else if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    )
                  else if (_markdownContent != null)
                    Markdown(
                      data: _markdownContent!,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onTapLink: (text, href, title) async {
                        if (href != null) {
                          final uri = Uri.parse(href);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                    )
                  else
                    const Text(
                      '此商家暫無介紹',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),

            // Bottom padding
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.greyBackground,
      child: Icon(
        Icons.store,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }
}
