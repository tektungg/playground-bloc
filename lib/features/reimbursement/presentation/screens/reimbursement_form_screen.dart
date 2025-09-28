import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reimbursement.dart';
import '../bloc/reimbursement_bloc.dart';
import '../bloc/reimbursement_event.dart';
import '../bloc/reimbursement_state.dart';
import '../widgets/upload_attachment_bottomsheet.dart';

class ReimbursementFormScreen extends StatefulWidget {
  final Reimbursement? existingReimbursement;

  const ReimbursementFormScreen({super.key, this.existingReimbursement});

  @override
  State<ReimbursementFormScreen> createState() =>
      _ReimbursementFormScreenState();
}

class _ReimbursementFormScreenState extends State<ReimbursementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _detailController = TextEditingController();

  DateTime? _selectedDate;
  ClaimType? _selectedClaimType;
  Reimbursement? _currentReimbursement;
  final List<ReimbursementAttachment> _localAttachments = [];

  final List<ApprovalLine> _approvalLines = [
    ApprovalLine(
      name: 'Yokevin Mayer Van Persie',
      position: 'Big Boss',
      photoUrl: 'https://via.placeholder.com/50',
      approvedAt: DateTime.now(),
      isApproved: true,
    ),
    const ApprovalLine(
      name: 'Francino Gigi Satrio',
      position: 'Medium Boss',
      photoUrl: 'https://via.placeholder.com/50',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Initialize dengan data existing jika ada (mode edit)
    if (widget.existingReimbursement != null) {
      _currentReimbursement = widget.existingReimbursement;
      _selectedDate = widget.existingReimbursement!.date;
      _selectedClaimType = widget.existingReimbursement!.claimType;
      _detailController.text = widget.existingReimbursement!.detail;
    } else {
      // Mode create baru
      _selectedDate = DateTime.now();
    }

    _dateController.text = _formatDate(_selectedDate!);
  }

  String _formatDate(DateTime date) {
    // Format: Mon, 2 Jan 2025
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekday = days[date.weekday % 7];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} $month ${date.year}';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingReimbursement != null
              ? 'Edit Reimbursement'
              : 'Pengajuan Reimburs',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ReimbursementBloc, ReimbursementState>(
        listener: (context, state) {
          if (state is ReimbursementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ReimbursementSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ReimbursementLoaded &&
              widget.existingReimbursement == null &&
              _currentReimbursement == null &&
              _localAttachments.isNotEmpty) {
            final latestReimbursement = state.reimbursements.first;
            setState(() {
              _currentReimbursement = latestReimbursement;
            });

            // Upload semua attachments sekaligus dengan batch update
            _uploadAllAttachments(latestReimbursement);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Container 1: Detail Pengajuan
                  _buildDetailPengajuanContainer(),
                  const SizedBox(height: 16),

                  // Container 2: Lampiran Bukti
                  _buildLampiranBuktiContainer(),
                  const SizedBox(height: 16),

                  // Container 3: Approval Line
                  _buildApprovalLineContainer(),
                  const SizedBox(height: 24),

                  // Submit Button
                  _buildSubmitButton(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailPengajuanContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Pengajuan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Tanggal Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tanggal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Masukkan tanggal',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onTap: _selectDate,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Tanggal harus diisi';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Jenis Klaim Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Klaim',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<ClaimType>(
                value: _selectedClaimType,
                hint: const Text('Pilih jenis klaim'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items:
                    ClaimType.values.map((claimType) {
                      return DropdownMenuItem(
                        value: claimType,
                        child: Text(claimType.label),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedClaimType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Jenis klaim harus dipilih';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Detail Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _detailController,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: 'Masukkan detail pengajuan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Detail harus diisi';
                  }
                  return null;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLampiranBuktiContainer() {
    bool hasAttachments =
        _localAttachments.isNotEmpty ||
        (_currentReimbursement?.attachments.isNotEmpty ?? false);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lampiran Bukti',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Show upload button only if no attachments yet
          if (!hasAttachments)
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showUploadBottomSheet,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blue.withValues(alpha: 0.3),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Icon(
                        Icons.upload_file,
                        size: 48,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Klik untuk upload gambar dan isi nominal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PNG, JPG hingga 5MB',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

          // Show attachments in row format
          if (hasAttachments) ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getAllAttachments().length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final allAttachments = _getAllAttachments();
                final attachment = allAttachments[index];
                final isLocal = index < _localAttachments.length;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Images display
                      if (attachment.filePaths.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: attachment.filePaths.length,
                            itemBuilder: (context, imageIndex) {
                              final filePath = attachment.filePaths[imageIndex];
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[200],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child:
                                            filePath.isNotEmpty &&
                                                    File(filePath).existsSync()
                                                ? Image.file(
                                                  File(filePath),
                                                  fit: BoxFit.cover,
                                                )
                                                : const Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Description and amount row
                      Row(
                        children: [
                          // Description and details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attachment.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Amount and delete button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${attachment.amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              if (isLocal) // Only show delete for local attachments
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Remove from local attachments using actual index
                                      final localIndex = index;
                                      if (localIndex <
                                          _localAttachments.length) {
                                        _localAttachments.removeAt(localIndex);
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Add more button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _showUploadBottomSheet,
                  icon: const Icon(Icons.add, color: Colors.grey),
                  label: const Text(
                    'Tambah Item',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildApprovalLineContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Approval Line',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _approvalLines.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final approvalLine = _approvalLines[index];
              return Row(
                children: [
                  // Photo
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(approvalLine.photoUrl),
                  ),
                  const SizedBox(width: 12),

                  // Name and Position
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          approvalLine.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          approvalLine.position,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status (text only, with icon)
                  Row(
                    children: [
                      approvalLine.isApproved
                          ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 12,
                          )
                          : const Icon(
                            Icons.schedule,
                            color: Colors.grey,
                            size: 12,
                          ),
                      const SizedBox(width: 4),
                      Text(
                        approvalLine.isApproved
                            ? _formatDate(approvalLine.approvedAt!)
                            : 'Menunggu',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              approvalLine.isApproved
                                  ? Colors.green
                                  : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ReimbursementState state) {
    final hasAttachments =
        _localAttachments.isNotEmpty ||
        (_currentReimbursement?.attachments.isNotEmpty ?? false);
    final isButtonEnabled =
        (state is! ReimbursementLoading) &&
        (widget.existingReimbursement != null || hasAttachments);

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            state is ReimbursementLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  _getButtonText(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => UploadAttachmentBottomSheet(
            reimbursementId: 0, // Temporary ID for local storage
            isLocalMode: true,
            onAttachmentUploaded: () {
              // This will be called from bottom sheet when attachment is added locally
            },
            onAttachmentAdded: (attachment) {
              setState(() {
                _localAttachments.add(attachment);
              });
            },
          ),
    );
  }

  String _getButtonText() {
    if (widget.existingReimbursement != null) {
      // Mode edit
      return 'Simpan Perubahan';
    } else {
      // Mode create - hanya submit request
      return 'Submit Request';
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Validasi attachment - wajib ada minimal 1 attachment
      final totalAttachments =
          _localAttachments.length +
          (_currentReimbursement?.attachments.length ?? 0);

      if (totalAttachments == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Minimal harus ada satu lampiran bukti untuk submit request',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      if (widget.existingReimbursement != null) {
        // Mode edit - simpan perubahan
        final updatedReimbursement = widget.existingReimbursement!.copyWith(
          date: _selectedDate!,
          claimType: _selectedClaimType!,
          detail: _detailController.text,
        );

        context.read<ReimbursementBloc>().add(
          UpdateReimbursement(updatedReimbursement),
        );
      } else {
        // Mode create - langsung submit request dengan attachment
        context.read<ReimbursementBloc>().add(
          CreateReimbursement(
            date: _selectedDate!,
            claimType: _selectedClaimType!,
            detail: _detailController.text,
          ),
        );
      }
    }
  }

  List<ReimbursementAttachment> _getAllAttachments() {
    // Gabungkan local attachments dan attachments dari database
    final List<ReimbursementAttachment> allAttachments = [];

    // Tambahkan local attachments terlebih dahulu
    allAttachments.addAll(_localAttachments);

    // Tambahkan attachments dari database (jika ada)
    if (_currentReimbursement?.attachments.isNotEmpty ?? false) {
      allAttachments.addAll(_currentReimbursement!.attachments);
    }

    return allAttachments;
  }

  Future<void> _uploadAllAttachments(Reimbursement reimbursement) async {
    if (_localAttachments.isEmpty) return;

    try {
      // Gabungkan semua attachment yang ada dengan attachment baru
      final allAttachments = [
        ...reimbursement.attachments,
        ..._localAttachments,
      ];

      // Update reimbursement dengan semua attachments sekaligus
      final updatedReimbursement = reimbursement.copyWith(
        attachments: allAttachments,
        updatedAt: DateTime.now(),
      );

      // Update sekaligus
      context.read<ReimbursementBloc>().add(
        UpdateReimbursement(updatedReimbursement),
      );

      // Clear local attachments
      setState(() {
        _localAttachments.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading attachments: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
