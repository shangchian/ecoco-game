import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/pages/common/alerts/simple_error_alert.dart';
import '/l10n/app_localizations.dart';

class PhotoFormField extends StatefulWidget {
  final List<int>? defaultPhoto;
  final ValueChanged<File?> onChanged;

  const PhotoFormField({
    super.key,
    this.defaultPhoto,
    required this.onChanged,
  });

  @override
  State<PhotoFormField> createState() => _PhotoFormFieldState();
}

class _PhotoFormFieldState extends State<PhotoFormField> {
  final ImagePicker _picker = ImagePicker();
  File? photoFile;

  Future<void> _pickImage(ImageSource source) async {
    final appLocale = AppLocalizations.of(context);
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 400,
      );

      if (image != null) {
        setState(() {
          photoFile = File(image.path);
        });
        widget.onChanged(photoFile);
      }
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => SimpleErrorAlert(
            message: appLocale?.profilePhotoSelectedException ?? "",
            buttonText: appLocale?.okay ?? "",
            onPressed: () {},
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    final appLocale = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(appLocale?.profilePhotoChoose ?? ""),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(appLocale?.camera ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(appLocale?.photoAlbum ?? ""),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: GestureDetector(
            onTap: _showImageSourceDialog,
            child: Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    image: photoFile != null
                        ? DecorationImage(
                            image: FileImage(photoFile!),
                            fit: BoxFit.cover,
                          )
                        : widget.defaultPhoto != null
                            ? DecorationImage(
                                image: MemoryImage(
                                    Uint8List.fromList(widget.defaultPhoto!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: photoFile == null && widget.defaultPhoto == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 235, 72, 13),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
