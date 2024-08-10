import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini/widgets/button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _CapturePhotoScreenState();
}

class _CapturePhotoScreenState extends State<HomeScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _identifiedIngredients = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    setState((){
      _identifiedIngredients = '';
    });
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
    _identifyIngredients();
  }

  Future<void> _capturePhoto() async {
    setState((){
      _identifiedIngredients = '';
    });
    final capturedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = capturedFile;
    });
    _identifyIngredients();
  }

  void _identifyIngredients() async {
    if (_imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    final file = File(_imageFile!.path);
    final gemini = Gemini.instance;

    gemini.textAndImage(
      text:
          "What ingredients are in this dish or in fruit? Give me detailed nutrition information.",
      images: [file.readAsBytesSync()],
    ).then((value) {
      setState(() {
        _identifiedIngredients =
            value?.content?.parts?.last.text ?? 'No ingredients identified';
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _identifiedIngredients = 'Failed to identify ingredients';
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Identify Ingredients'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                SizedBox(
                  height: 400,
                  child: Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: Colors.deepOrange,
                      size: 50,
                    ),
                  ),
                )
              else if (_imageFile != null)
                Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.file(
                        File(_imageFile!.path),
                        height: 400,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ))
              else
                Column(
                  children: [
                    SizedBox(
                      height: 400,
                      child: Center(
                          child: Lottie.asset('assets/lottie/animation-1.json')),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      child: Text(
                        "Capture an image of fruit or dish or select it from the gallery to discover the ingredients it contains.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MarkdownBody(
                  data: _identifiedIngredients,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    text: 'Camera',
                    icon: Icons.camera_alt,
                    onPressed: _capturePhoto,
                  ),
                  CustomButton(
                    text: 'Gallery',
                    icon: Icons.photo,
                    onPressed: _pickImage,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
