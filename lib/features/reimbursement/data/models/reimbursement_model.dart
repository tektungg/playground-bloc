import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../domain/entities/reimbursement.dart';

class ApprovalLineModel extends Equatable {
  final String name;
  final String position;
  final String photoUrl;
  final DateTime? approvedAt;
  final bool isApproved;

  const ApprovalLineModel({
    required this.name,
    required this.position,
    required this.photoUrl,
    this.approvedAt,
    this.isApproved = false,
  });

  factory ApprovalLineModel.fromEntity(ApprovalLine approvalLine) {
    return ApprovalLineModel(
      name: approvalLine.name,
      position: approvalLine.position,
      photoUrl: approvalLine.photoUrl,
      approvedAt: approvalLine.approvedAt,
      isApproved: approvalLine.isApproved,
    );
  }

  factory ApprovalLineModel.fromMap(Map<String, dynamic> map) {
    return ApprovalLineModel(
      name: map['name'] as String,
      position: map['position'] as String,
      photoUrl: map['photoUrl'] as String,
      approvedAt:
          map['approvedAt'] != null
              ? DateTime.parse(map['approvedAt'] as String)
              : null,
      isApproved: (map['isApproved'] as int?) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'photoUrl': photoUrl,
      'approvedAt': approvedAt?.toIso8601String(),
      'isApproved': isApproved ? 1 : 0,
    };
  }

  ApprovalLine toEntity() {
    return ApprovalLine(
      name: name,
      position: position,
      photoUrl: photoUrl,
      approvedAt: approvedAt,
      isApproved: isApproved,
    );
  }

  @override
  List<Object?> get props => [name, position, photoUrl, approvedAt, isApproved];
}

class ReimbursementAttachmentModel extends Equatable {
  final List<String> filePaths;
  final List<String> fileNames;
  final double amount;
  final String description;

  const ReimbursementAttachmentModel({
    required this.filePaths,
    required this.fileNames,
    required this.amount,
    required this.description,
  });

  factory ReimbursementAttachmentModel.fromEntity(
    ReimbursementAttachment attachment,
  ) {
    return ReimbursementAttachmentModel(
      filePaths: attachment.filePaths,
      fileNames: attachment.fileNames,
      amount: attachment.amount,
      description: attachment.description,
    );
  }

  factory ReimbursementAttachmentModel.fromMap(Map<String, dynamic> map) {
    // Handle both old and new format for backward compatibility
    List<String> filePaths;
    List<String> fileNames;

    if (map['filePaths'] != null) {
      // New format with multiple files
      filePaths = List<String>.from(map['filePaths'] as List);
      fileNames = List<String>.from(map['fileNames'] as List);
    } else {
      // Old format with single file - migrate to new format
      filePaths = [map['filePath'] as String];
      fileNames = [map['fileName'] as String];
    }

    return ReimbursementAttachmentModel(
      filePaths: filePaths,
      fileNames: fileNames,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filePaths': filePaths,
      'fileNames': fileNames,
      'amount': amount,
      'description': description,
      // Keep old format for backward compatibility
      'filePath': filePaths.isNotEmpty ? filePaths.first : '',
      'fileName': fileNames.isNotEmpty ? fileNames.first : '',
    };
  }

  ReimbursementAttachment toEntity() {
    return ReimbursementAttachment(
      filePaths: filePaths,
      fileNames: fileNames,
      amount: amount,
      description: description,
    );
  }

  // Convenience getters for backward compatibility
  String get filePath => filePaths.isNotEmpty ? filePaths.first : '';
  String get fileName => fileNames.isNotEmpty ? fileNames.first : '';

  @override
  List<Object?> get props => [filePaths, fileNames, amount, description];
}

class ReimbursementModel extends Equatable {
  final int? id;
  final DateTime date;
  final ClaimType claimType;
  final String detail;
  final List<ReimbursementAttachmentModel> attachments;
  final List<ApprovalLineModel> approvalLines;
  final ReimbursementStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReimbursementModel({
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

  factory ReimbursementModel.fromEntity(Reimbursement reimbursement) {
    return ReimbursementModel(
      id: reimbursement.id,
      date: reimbursement.date,
      claimType: reimbursement.claimType,
      detail: reimbursement.detail,
      attachments:
          reimbursement.attachments
              .map((e) => ReimbursementAttachmentModel.fromEntity(e))
              .toList(),
      approvalLines:
          reimbursement.approvalLines
              .map((e) => ApprovalLineModel.fromEntity(e))
              .toList(),
      status: reimbursement.status,
      createdAt: reimbursement.createdAt,
      updatedAt: reimbursement.updatedAt,
    );
  }

  factory ReimbursementModel.fromMap(Map<String, dynamic> map) {
    List<ReimbursementAttachmentModel> attachments = [];
    if (map['attachments'] != null) {
      final attachmentsList = jsonDecode(map['attachments'] as String) as List;
      attachments =
          attachmentsList
              .map((e) => ReimbursementAttachmentModel.fromMap(e))
              .toList();
    }

    List<ApprovalLineModel> approvalLines = [];
    if (map['approvalLines'] != null) {
      final approvalLinesList =
          jsonDecode(map['approvalLines'] as String) as List;
      approvalLines =
          approvalLinesList.map((e) => ApprovalLineModel.fromMap(e)).toList();
    }

    return ReimbursementModel(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      claimType: ClaimType.values.firstWhere((e) => e.name == map['claimType']),
      detail: map['detail'] as String,
      attachments: attachments,
      approvalLines: approvalLines,
      status: ReimbursementStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'claimType': claimType.name,
      'detail': detail,
      'attachments': jsonEncode(attachments.map((e) => e.toMap()).toList()),
      'approvalLines': jsonEncode(approvalLines.map((e) => e.toMap()).toList()),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Reimbursement toEntity() {
    return Reimbursement(
      id: id,
      date: date,
      claimType: claimType,
      detail: detail,
      attachments: attachments.map((e) => e.toEntity()).toList(),
      approvalLines: approvalLines.map((e) => e.toEntity()).toList(),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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
