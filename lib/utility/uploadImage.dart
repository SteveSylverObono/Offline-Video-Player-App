import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageEditor {
  Future<File?> uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      return File(pickedImage.path);
    }

    return null;
  }

  Future<File?> saveImage(imageFile) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String appDirPath = appDir.path;

    final String savedImagePath = '$appDirPath/saved_image.jpg';
    final File savedImageFile = File(savedImagePath);

    try {
      if (savedImageFile.existsSync()) {
        await savedImageFile.delete();
      }

      await savedImageFile.writeAsBytes(await imageFile.readAsBytes());
      print("image saved");
      return savedImageFile;
    } catch (e) {
      print('Failed to save image: $e');
      return null;
    }
  }

  String displayImage(File? imageFile, {double size = 100.0}) {
    if (imageFile != null && imageFile.existsSync()) {
      return imageFile.path;
    } else {
      return 'assets/avatar.png'; // Replace with your default image path
    }
  }
}
