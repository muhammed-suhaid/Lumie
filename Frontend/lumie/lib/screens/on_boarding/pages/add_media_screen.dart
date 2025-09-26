import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';

class AddMediaScreen extends StatefulWidget {
  final Function(List<File>, File?) onMediaSelected;
  final List<File> selectedPhotos;
  final File? selectedVideo;

  const AddMediaScreen({
    super.key,
    required this.onMediaSelected,
    required this.selectedPhotos,
    this.selectedVideo,
  });

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  late List<File> _selectedPhotos;
  late File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _selectedPhotos = widget.selectedPhotos;
    _selectedVideo = widget.selectedVideo;
  }

  Future<void> _pickPhotos() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 50);
    setState(() {
      _selectedPhotos = pickedFiles.map((x) => File(x.path)).toList();
    });
    widget.onMediaSelected(_selectedPhotos, _selectedVideo);
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
      widget.onMediaSelected(_selectedPhotos, _selectedVideo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* Title *************************//
          Text(
            AppTexts.addMediaTitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeXXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          //************************* Subtitle *************************//
          Text(
            AppTexts.addMediaSubTitle,
            style: GoogleFonts.poppins(
              fontSize: AppConstants.kFontSizeM,
              color: colorScheme.onSurface.withAlpha(160),
            ),
          ),

          SizedBox(height: screenHeight * 0.04),

          //************************* Photo Gallery Preview *************************//
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedPhotos.length + 1,
              itemBuilder: (context, index) {
                if (index == _selectedPhotos.length) {
                  return GestureDetector(
                    onTap: _pickPhotos,
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withAlpha(30),
                        borderRadius: BorderRadius.circular(
                          AppConstants.kRadiusM,
                        ),
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        color: colorScheme.secondary,
                        size: 40,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppConstants.kRadiusM,
                      ),
                      image: DecorationImage(
                        image: FileImage(_selectedPhotos[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          //************************* Video placeholder *************************//
          GestureDetector(
            onTap: _pickVideo,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.secondary),
                borderRadius: BorderRadius.circular(AppConstants.kRadiusM),
              ),
              child: _selectedVideo != null
                  ? Icon(Icons.videocam, size: 60, color: Colors.green)
                  : Center(
                      child: Icon(
                        Icons.add_to_photos,
                        size: 60,
                        color: colorScheme.secondary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
