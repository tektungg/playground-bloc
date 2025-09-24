import 'package:equatable/equatable.dart';
import '../../domain/entities/reimbursement.dart';

abstract class ReimbursementState extends Equatable {
  const ReimbursementState();

  @override
  List<Object?> get props => [];
}

class ReimbursementInitial extends ReimbursementState {}

class ReimbursementLoading extends ReimbursementState {}

class ReimbursementLoaded extends ReimbursementState {
  final List<Reimbursement> reimbursements;

  const ReimbursementLoaded(this.reimbursements);

  @override
  List<Object?> get props => [reimbursements];
}

class ReimbursementSuccess extends ReimbursementState {
  final String message;

  const ReimbursementSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ReimbursementError extends ReimbursementState {
  final String message;

  const ReimbursementError(this.message);

  @override
  List<Object?> get props => [message];
}
