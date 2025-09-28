import 'package:dartz/dartz.dart';
import '../entities/reimbursement.dart';
import '../repositories/reimbursement_repository.dart';

class AddAttachmentToReimbursement {
  final ReimbursementRepository repository;

  AddAttachmentToReimbursement(this.repository);

  Future<Either<String, Reimbursement>> call({
    required int reimbursementId,
    required List<String> filePaths,
    required List<String> fileNames,
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
        filePaths: filePaths,
        fileNames: fileNames,
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

  // Backward compatibility method
  Future<Either<String, Reimbursement>> callSingle({
    required int reimbursementId,
    required String filePath,
    required String fileName,
    required double amount,
    required String description,
  }) async {
    return call(
      reimbursementId: reimbursementId,
      filePaths: [filePath],
      fileNames: [fileName],
      amount: amount,
      description: description,
    );
  }
}
