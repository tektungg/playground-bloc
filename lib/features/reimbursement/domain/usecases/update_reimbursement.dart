import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';
import '../repositories/reimbursement_repository.dart';

class UpdateReimbursement {
  final ReimbursementRepository repository;

  UpdateReimbursement(this.repository);

  Future<Either<String, Reimbursement>> call(
    Reimbursement reimbursement,
  ) async {
    final updatedReimbursement = reimbursement.copyWith(
      updatedAt: DateTime.now(),
    );

    return await repository.updateReimbursement(updatedReimbursement);
  }
}
