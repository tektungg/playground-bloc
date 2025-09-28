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
      ApprovalLine(
        name: 'Yokevin Mayer Van Persie',
        position: 'Big Boss',
        photoUrl: 'https://via.placeholder.com/50',
        approvedAt: DateTime.now(),
        isApproved: true,
      ),
      const ApprovalLine(
        name: 'Francino Gigi Satrio',
        position: 'Medium Boss',
        photoUrl: 'https://via.placeholder.com/50',
      ),
    ];

    final reimbursement = Reimbursement(
      date: date,
      claimType: claimType,
      detail: detail,
      attachments: [],
      approvalLines: approvalLines,
      status: ReimbursementStatus.submitted,
      createdAt: now,
      updatedAt: now,
    );

    return await repository.createReimbursement(reimbursement);
  }
}
