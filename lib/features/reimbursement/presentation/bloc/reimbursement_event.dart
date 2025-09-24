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

class SubmitReimbursement extends ReimbursementEvent {
  final int id;

  const SubmitReimbursement(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteReimbursement extends ReimbursementEvent {
  final int id;

  const DeleteReimbursement(this.id);

  @override
  List<Object?> get props => [id];
}

class AddAttachment extends ReimbursementEvent {
  final int reimbursementId;
  final String filePath;
  final String fileName;
  final double amount;
  final String description;

  const AddAttachment({
    required this.reimbursementId,
    required this.filePath,
    required this.fileName,
    required this.amount,
    required this.description,
  });

  @override
  List<Object?> get props => [
    reimbursementId,
    filePath,
    fileName,
    amount,
    description,
  ];
}
