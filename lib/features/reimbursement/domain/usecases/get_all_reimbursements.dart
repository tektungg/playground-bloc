import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';
import '../repositories/reimbursement_repository.dart';

class GetAllReimbursements {
  final ReimbursementRepository repository;

  GetAllReimbursements(this.repository);

  Future<Either<String, List<Reimbursement>>> call() async {
    return await repository.getAllReimbursements();
  }
}
