import 'package:image_picker/image_picker.dart';

Future<XFile?> takePicture() async {
  final ImagePicker _picker = ImagePicker();
  return await _picker.pickImage(source: ImageSource.camera);
}
