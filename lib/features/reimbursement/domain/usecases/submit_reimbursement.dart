import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';
import '../repositories/reimbursement_repository.dart';

class SubmitReimbursement {
  final ReimbursementRepository repository;

  SubmitReimbursement(this.repository);

  Future<Either<String, Reimbursement>> call(int id) async {
    return await repository.submitReimbursement(id);
  }
}
