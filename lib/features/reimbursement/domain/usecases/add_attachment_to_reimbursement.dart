import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';
import '../repositories/reimbursement_repository.dart';

class AddAttachmentToReimbursement {
  final ReimbursementRepository repository;

  AddAttachmentToReimbursement(this.repository);

  Future<Either<String, Reimbursement>> call({
    required int reimbursementId,
    required String filePath,
    required String fileName,
    required double amount,
    required String description,
  }) async {
    final reimbursementResult = await repository.getReimbursementById(
      reimbursementId,
    );

    return reimbursementResult.fold((error) => Left(error), (
      reimbursement,
    ) async {
      final newAttachment = ReimbursementAttachment(
        filePath: filePath,
        fileName: fileName,
        amount: amount,
        description: description,
      );

      final updatedAttachments = [...reimbursement.attachments, newAttachment];
      final updatedReimbursement = reimbursement.copyWith(
        attachments: updatedAttachments,
        updatedAt: DateTime.now(),
      );

      return await repository.updateReimbursement(updatedReimbursement);
    });
  }
}
