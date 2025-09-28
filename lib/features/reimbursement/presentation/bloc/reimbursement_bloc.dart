import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_reimbursement.dart'
    as create_reimbursement;
import '../../domain/usecases/get_all_reimbursements.dart';
import '../../domain/usecases/update_reimbursement.dart'
    as update_reimbursement;
import '../../domain/usecases/submit_reimbursement.dart'
    as submit_reimbursement;
import '../../domain/usecases/add_attachment_to_reimbursement.dart';
import '../../domain/usecases/delete_reimbursement.dart'
    as delete_reimbursement;
import 'reimbursement_event.dart';
import 'reimbursement_state.dart';

class ReimbursementBloc extends Bloc<ReimbursementEvent, ReimbursementState> {
  final GetAllReimbursements getAllReimbursements;
  final create_reimbursement.CreateReimbursement createReimbursement;
  final update_reimbursement.UpdateReimbursement updateReimbursement;
  final submit_reimbursement.SubmitReimbursement submitReimbursement;
  final AddAttachmentToReimbursement addAttachmentToReimbursement;
  final delete_reimbursement.DeleteReimbursement deleteReimbursement;

  ReimbursementBloc({
    required this.getAllReimbursements,
    required this.createReimbursement,
    required this.updateReimbursement,
    required this.submitReimbursement,
    required this.addAttachmentToReimbursement,
    required this.deleteReimbursement,
  }) : super(ReimbursementInitial()) {
    on<LoadReimbursements>(_onLoadReimbursements);
    on<CreateReimbursement>(_onCreateReimbursement);
    on<UpdateReimbursement>(_onUpdateReimbursement);
    on<SubmitReimbursement>(_onSubmitReimbursement);
    on<AddAttachment>(_onAddAttachment);
    on<DeleteReimbursement>(_onDeleteReimbursement);
  }

  Future<void> _onLoadReimbursements(
    LoadReimbursements event,
    Emitter<ReimbursementState> emit,
  ) async {
    emit(ReimbursementLoading());

    final result = await getAllReimbursements();
    result.fold(
      (failure) => emit(ReimbursementError(failure)),
      (reimbursements) => emit(ReimbursementLoaded(reimbursements)),
    );
  }

  Future<void> _onCreateReimbursement(
    CreateReimbursement event,
    Emitter<ReimbursementState> emit,
  ) async {
    final result = await createReimbursement(
      date: event.date,
      claimType: event.claimType,
      detail: event.detail,
    );

    result.fold((failure) => emit(ReimbursementError(failure)), (
      reimbursement,
    ) {
      emit(const ReimbursementSuccess('Reimbursement created successfully'));
      add(LoadReimbursements());
    });
  }

  Future<void> _onUpdateReimbursement(
    UpdateReimbursement event,
    Emitter<ReimbursementState> emit,
  ) async {
    final result = await updateReimbursement(event.reimbursement);

    result.fold((failure) => emit(ReimbursementError(failure)), (
      reimbursement,
    ) {
      emit(const ReimbursementSuccess('Reimbursement updated successfully'));
      add(LoadReimbursements());
    });
  }

  Future<void> _onSubmitReimbursement(
    SubmitReimbursement event,
    Emitter<ReimbursementState> emit,
  ) async {
    final result = await submitReimbursement(event.id);

    result.fold((failure) => emit(ReimbursementError(failure)), (
      reimbursement,
    ) {
      emit(const ReimbursementSuccess('Reimbursement submitted successfully'));
      add(LoadReimbursements());
    });
  }

  Future<void> _onAddAttachment(
    AddAttachment event,
    Emitter<ReimbursementState> emit,
  ) async {
    final result = await addAttachmentToReimbursement(
      reimbursementId: event.reimbursementId,
      filePaths: event.filePaths,
      fileNames: event.fileNames,
      amount: event.amount,
      description: event.description,
    );

    result.fold((failure) => emit(ReimbursementError(failure)), (
      reimbursement,
    ) {
      emit(const ReimbursementSuccess('Attachment added successfully'));
      add(LoadReimbursements());
    });
  }

  Future<void> _onDeleteReimbursement(
    DeleteReimbursement event,
    Emitter<ReimbursementState> emit,
  ) async {
    final result = await deleteReimbursement(event.id);

    result.fold((failure) => emit(ReimbursementError(failure)), (_) {
      emit(const ReimbursementSuccess('Reimbursement deleted successfully'));
      add(LoadReimbursements());
    });
  }
}
