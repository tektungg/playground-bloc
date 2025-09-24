import 'package:dartz/dartz.dart';
import '../repositories/reimbursement_repository.dart';

class DeleteReimbursement {
  final ReimbursementRepository repository;

  DeleteReimbursement(this.repository);

  Future<Either<String, void>> call(int id) async {
    return await repository.deleteReimbursement(id);
  }
}
