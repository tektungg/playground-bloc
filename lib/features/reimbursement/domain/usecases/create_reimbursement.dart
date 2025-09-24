import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';
import '../repositories/reimbursement_repository.dart';

class CreateReimbursement {
  final ReimbursementRepository repository;

  CreateReimbursement(this.repository);

  Future<Either<String, Reimbursement>> call({
    required DateTime date,
    required ClaimType claimType,
    required String detail,
  }) async {
    final now = DateTime.now();

    final approvalLines = [
      const ApprovalLine(
        name: 'John Doe',
        position: 'Manager',
        photoUrl: 'https://via.placeholder.com/50',
      ),
      const ApprovalLine(
        name: 'Jane Smith',
        position: 'Finance Director',
        photoUrl: 'https://via.placeholder.com/50',
      ),
    ];

    final reimbursement = Reimbursement(
      date: date,
      claimType: claimType,
      detail: detail,
      attachments: [],
      approvalLines: approvalLines,
      status: ReimbursementStatus.draft,
      createdAt: now,
      updatedAt: now,
    );

    return await repository.createReimbursement(reimbursement);
  }
}
