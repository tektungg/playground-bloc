import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../domain/entities/reimbursement.dart';
import '../bloc/reimbursement_bloc.dart';
import '../bloc/reimbursement_event.dart';

class UploadAttachmentBottomSheet extends StatefulWidget {
  final int reimbursementId;
  final VoidCallback onAttachmentUploaded;
  final Function(ReimbursementAttachment)? onAttachmentAdded;
  final bool isLocalMode;

  const UploadAttachmentBottomSheet({
    super.key,
    required this.reimbursementId,
    required this.onAttachmentUploaded,
    this.onAttachmentAdded,
    this.isLocalMode = false,
  });

  @override
  State<UploadAttachmentBottomSheet> createState() =>
      _UploadAttachmentBottomSheetState();
}

class _UploadAttachmentBottomSheetState
    extends State<UploadAttachmentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _selectedFilePaths = [];
  final List<String> _selectedFileNames = [];
  final List<File> _selectedImageFiles = [];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bukti dan Nominal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bukti Foto Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bukti Foto',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectFile,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[50],
                          ),
                          child:
                              _selectedImageFiles.isNotEmpty
                                  ? Column(
                                    children: [
                                      // Display selected images in a horizontal scroll
                                      SizedBox(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _selectedImageFiles.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: Image.file(
                                                      _selectedImageFiles[index],
                                                      height: 120,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  // Remove button
                                                  Positioned(
                                                    top: 4,
                                                    right: 4,
                                                    child: GestureDetector(
                                                      onTap:
                                                          () => _removeImage(
                                                            index,
                                                          ),
                                                      child: Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                              color: Colors.red,
                                                              shape:
                                                                  BoxShape
                                                                      .circle,
                                                            ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.photo,
                                              color: Colors.blue,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${_selectedImageFiles.length} gambar dipilih',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              'Tap untuk tambah/ubah',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                  : SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.photo_camera,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Pilih gambar dari galeri',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nominal Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nominal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        onEditingComplete:
                            () => FocusScope.of(context).nextFocus(),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Masukkan nominal',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Nominal harus diisi';
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Nominal harus berupa angka';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Keterangan Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Keterangan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Masukkan keterangan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Keterangan harus diisi';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveAttachment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage(imageQuality: 80);

      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImageFiles.addAll(images.map((image) => File(image.path)));
          _selectedFileNames.addAll(images.map((image) => image.name));
          _selectedFilePaths.addAll(images.map((image) => image.path));
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${images.length} gambar berhasil dipilih'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImageFiles.removeAt(index);
      _selectedFileNames.removeAt(index);
      _selectedFilePaths.removeAt(index);
    });
  }

  void _saveAttachment() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedFilePaths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan pilih minimal 1 gambar terlebih dahulu'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final amount = double.parse(_amountController.text);

      if (widget.isLocalMode && widget.onAttachmentAdded != null) {
        // Mode lokal - hanya return data attachment
        final attachment = ReimbursementAttachment(
          filePaths: _selectedFilePaths,
          fileNames: _selectedFileNames,
          amount: amount,
          description: _descriptionController.text,
        );
        widget.onAttachmentAdded!(attachment);
      } else {
        // Mode normal - simpan ke database
        context.read<ReimbursementBloc>().add(
          AddAttachment(
            reimbursementId: widget.reimbursementId,
            filePaths: _selectedFilePaths,
            fileNames: _selectedFileNames,
            amount: amount,
            description: _descriptionController.text,
          ),
        );
      }

      widget.onAttachmentUploaded();
      Navigator.of(context).pop();
    }
  }
}
