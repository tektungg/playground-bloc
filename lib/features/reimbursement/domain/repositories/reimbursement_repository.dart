import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';

abstract class ReimbursementRepository {
  Future<Either<String, List<Reimbursement>>> getAllReimbursements();
  Future<Either<String, Reimbursement>> getReimbursementById(int id);
  Future<Either<String, Reimbursement>> createReimbursement(
    Reimbursement reimbursement,
  );
  Future<Either<String, Reimbursement>> updateReimbursement(
    Reimbursement reimbursement,
  );
  Future<Either<String, void>> deleteReimbursement(int id);
  Future<Either<String, Reimbursement>> submitReimbursement(int id);
  Future<Either<String, List<Reimbursement>>> getReimbursementsByStatus(
    ReimbursementStatus status,
  );
}
