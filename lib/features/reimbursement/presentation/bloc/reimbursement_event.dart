import 'package:equatable/equatable.dart';
import '../../domain/entities/reimbursement.dart';

abstract class ReimbursementEvent extends Equatable {
  const ReimbursementEvent();

  @override
  List<Object?> get props => [];
}

class LoadReimbursements extends ReimbursementEvent {}

class CreateReimbursement extends ReimbursementEvent {
  final DateTime date;
  final ClaimType claimType;
  final String detail;

  const CreateReimbursement({
    required this.date,
    required this.claimType,
    required this.detail,
  });

  @override
  List<Object?> get props => [date, claimType, detail];
}

class UpdateReimbursement extends ReimbursementEvent {
  final Reimbursement reimbursement;

  const UpdateReimbursement(this.reimbursement);

  @override
  List<Object?> get props => [reimbursement];
}

class DeleteReimbursement extends ReimbursementEvent {
  final int id;

  const DeleteReimbursement(this.id);

  @override
  List<Object?> get props => [id];
}

class AddAttachment extends ReimbursementEvent {
  final int reimbursementId;
  final List<String> filePaths;
  final List<String> fileNames;
  final double amount;
  final String description;

  const AddAttachment({
    required this.reimbursementId,
    required this.filePaths,
    required this.fileNames,
    required this.amount,
    required this.description,
  });

  // Backward compatibility constructors
  AddAttachment.single({
    required int reimbursementId,
    required String filePath,
    required String fileName,
    required double amount,
    required String description,
  }) : this(
         reimbursementId: reimbursementId,
         filePaths: [filePath],
         fileNames: [fileName],
         amount: amount,
         description: description,
       );

  @override
  List<Object?> get props => [
    reimbursementId,
    filePaths,
    fileNames,
    amount,
    description,
  ];
}
