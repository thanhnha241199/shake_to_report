import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'widget/bottom_space.dart';

class ReportScreen extends StatefulWidget {
  final Function(List<XFile> images, String reason) onReport;
  const ReportScreen({Key? key, required this.onReport}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<XFile> _imageFileList = [];
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  bool isValidate = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report'), backgroundColor: Colors.black),
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text('Reason',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                controller: _reasonController,
                validator: (val) =>
                    val?.isEmpty ?? false ? 'Enter reason' : null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  disabledBorder: inputBorder,
                  focusedErrorBorder: inputBorder,
                  hintText: 'Enter reason',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                  errorStyle: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                  labelText: '',
                ),
              ),
              SizedBox(height: 30),
              Text('Image',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 16),
              Wrap(
                children: [
                  ...List.generate(
                          _imageFileList.length, (index) => _buildImage(index))
                      .toList(),
                  _buildAddImage(),
                ],
              ),
              if (_imageFileList.isEmpty && isValidate) ...[
                SizedBox(height: 10),
                Text(
                  'Choose image to upload',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.red),
                )
              ],
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _imageFileList.isNotEmpty) {
                      widget.onReport(_imageFileList, _reasonController.text);
                      Navigator.pop(context);
                    }
                    setState(() {
                      isValidate = true;
                    });
                  },
                  child: Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    maximumSize:
                        MaterialStateProperty.all(Size(double.infinity, 50)),
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 50)),
                  )),
              BottomSpace(),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder get inputBorder => OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(10));

  Widget _buildAddImage() {
    return GestureDetector(
      onTap: () async {
        final images = await ImagePicker().pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _imageFileList.addAll(images);
          });
        }
      },
      child: Container(
        height: 80,
        width: 80,
        child: Icon(Icons.camera_alt_outlined, color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Image.file(
              File(_imageFileList[index].path),
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () => setState(() {
                  _imageFileList.removeAt(index);
                }),
                child: Icon(Icons.close, size: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
