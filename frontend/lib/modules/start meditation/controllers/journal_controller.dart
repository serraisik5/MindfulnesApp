// lib/modules/journal/controllers/journal_controller.dart

import 'package:get/get.dart';
import 'package:minder_frontend/models/journal_entry_model.dart';
import 'package:minder_frontend/services/journal_service.dart';

class JournalController extends GetxController {
  final entries = <JournalEntryModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      entries.value = await JournalService.fetchEntries();
    } catch (err) {
      errorMessage.value = err.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addEntry(String text) async {
    try {
      isLoading.value = true;
      final newEntry = await JournalService.createEntry(text);
      entries.insert(0, newEntry);
      Get.snackbar('Saved', 'Your journal entry was created');
    } catch (err) {
      Get.snackbar('Error', 'Could not save entry');
    } finally {
      isLoading.value = false;
    }
  }
}
