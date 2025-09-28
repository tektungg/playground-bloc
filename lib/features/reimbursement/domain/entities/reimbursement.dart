import 'package:equatable/equatable.dart';

enum ReimbursementStatus { draft, submitted, approved, rejected }

enum ClaimType {
  officeSupplies('Alat Kantor'),
  transportation('Transportasi'),
  accommodation('Akomodasi'),
  meal('Makanan'),
  communication('Komunikasi'),
  other('Lainnya');

  const ClaimType(this.label);
  final String label;
}

class ApprovalLine extends Equatable {
  final String name;
  final String position;
  final String photoUrl;
  final DateTime? approvedAt;
  final bool isApproved;

  const ApprovalLine({
    required this.name,
    required this.position,
    required this.photoUrl,
    this.approvedAt,
    this.isApproved = false,
  });

  ApprovalLine copyWith({
    String? name,
    String? position,
    String? photoUrl,
    DateTime? approvedAt,
    bool? isApproved,
  }) {
    return ApprovalLine(
      name: name ?? this.name,
      position: position ?? this.position,
      photoUrl: photoUrl ?? this.photoUrl,
      approvedAt: approvedAt ?? this.approvedAt,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  @override
  List<Object?> get props => [name, position, photoUrl, approvedAt, isApproved];
}

class ReimbursementAttachment extends Equatable {
  final List<String> filePaths;
  final List<String> fileNames;
  final double amount;
  final String description;

  const ReimbursementAttachment({
    required this.filePaths,
    required this.fileNames,
    required this.amount,
    required this.description,
  });

  ReimbursementAttachment copyWith({
    List<String>? filePaths,
    List<String>? fileNames,
    double? amount,
    String? description,
  }) {
    return ReimbursementAttachment(
      filePaths: filePaths ?? this.filePaths,
      fileNames: fileNames ?? this.fileNames,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }

  // Convenience getters for backward compatibility
  String get filePath => filePaths.isNotEmpty ? filePaths.first : '';
  String get fileName => fileNames.isNotEmpty ? fileNames.first : '';

  @override
  List<Object?> get props => [filePaths, fileNames, amount, description];
}

class Reimbursement extends Equatable {
  final int? id;
  final DateTime date;
  final ClaimType claimType;
  final String detail;
  final List<ReimbursementAttachment> attachments;
  final List<ApprovalLine> approvalLines;
  final ReimbursementStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reimbursement({
    this.id,
    required this.date,
    required this.claimType,
    required this.detail,
    required this.attachments,
    required this.approvalLines,
    this.status = ReimbursementStatus.draft,
    required this.createdAt,
    required this.updatedAt,
  });

  Reimbursement copyWith({
    int? id,
    DateTime? date,
    ClaimType? claimType,
    String? detail,
    List<ReimbursementAttachment>? attachments,
    List<ApprovalLine>? approvalLines,
    ReimbursementStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reimbursement(
      id: id ?? this.id,
      date: date ?? this.date,
      claimType: claimType ?? this.claimType,
      detail: detail ?? this.detail,
      attachments: attachments ?? this.attachments,
      approvalLines: approvalLines ?? this.approvalLines,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get totalAmount {
    return attachments.fold(0.0, (sum, attachment) => sum + attachment.amount);
  }

  @override
  List<Object?> get props => [
    id,
    date,
    claimType,
    detail,
    attachments,
    approvalLines,
    status,
    createdAt,
    updatedAt,
  ];
}
