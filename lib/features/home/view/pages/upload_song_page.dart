import 'dart:io';

import 'package:client/core/theme/app_colors.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _formKey = GlobalKey<FormState>();
  File? thumbnail;
  File? audio;
  final _artistController = TextEditingController();
  final _songNameController = TextEditingController();
  Color _selectedColor = AppColors.cardColor;

  void selectImage() async {
    final selectedImage = await pickImage();
    if (selectedImage != null) {
      setState(() {
        thumbnail = selectedImage;
      });
    }
  }

  void selectAudio() async {
    final selectedAudio = await pickAudio();
    if (selectedAudio != null) {
      setState(() {
        audio = selectedAudio;
      });
    }
  }

  @override
  void dispose() {
    _artistController.dispose();
    _songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        homeViewModelProvider.select((value) => value?.isLoading == true));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate() &&
                  audio != null &&
                  thumbnail != null) {
                await ref.read(homeViewModelProvider.notifier).uploadSong(
                      audio: audio!,
                      thumbnail: thumbnail!,
                      artist: _artistController.text.trim(),
                      songName: _songNameController.text.trim(),
                      color: _selectedColor,
                    );
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      thumbnail != null
                          ? GestureDetector(
                              onTap: selectImage,
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      Image.file(thumbnail!, fit: BoxFit.cover),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: selectImage,
                              child: DottedBorder(
                                color: AppColors.borderColor,
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.folder_open, size: 40),
                                      SizedBox(height: 15),
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 40),
                      audio != null
                          ? AudioWave(path: audio!.path)
                          : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectAudio,
                            ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: 'Artist',
                        controller: _artistController,
                      ),
                      const SizedBox(height: 20),
                      CustomField(
                        hintText: 'Song Name',
                        controller: _songNameController,
                      ),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: const {
                          ColorPickerType.wheel: true,
                        },
                        color: _selectedColor,
                        onColorChanged: (Color color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
