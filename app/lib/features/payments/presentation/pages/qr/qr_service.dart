import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class QrService {
  static const String _tempPrefix = 'finipay_qr_';
  Future<Uint8List> _generatePdf(Uint8List qrData) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                "Ваш QR-код Finipay",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 2),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(10),
                  ),
                ),
                child: pw.Image(
                  pw.MemoryImage(qrData),
                  width: 200,
                  height: 200,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Отсканируйте для оплаты",
                style: pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                DateTime.now().toString(),
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey500,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  Future<void> sharePdf(Uint8List qrData) async {
    try {
      log("📄 Генерация PDF с QR-кодом...");
      final pdfData = await _generatePdf(qrData);

      // Сохраняем PDF во временный файл
      final tempFile = await _savePdfTemp(pdfData);

      if (tempFile != null) {
        // Делимся файлом через SharePlus 11.x
        final params = ShareParams(
          text: 'QR-код для оплаты',
          subject: 'QR-код Finipay',
          files: [XFile(tempFile.path)],
        );
        final result = await SharePlus.instance.share(params);
        if (result.status == ShareResultStatus.success) {
          log('✅ Пользователь поделился QR-кодом!');
        }

        // Удаляем временный файл
        await _cleanupTempFiles();
      }
    } catch (e) {
      log("❌ Ошибка при создании PDF: $e");
      rethrow;
    }
  }

  Future<File?> _savePdfTemp(Uint8List pdfData) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File(
        '${tempDir.path}/${_tempPrefix}qr_$timestamp.pdf',
      );

      await tempFile.writeAsBytes(pdfData);
      return tempFile;
    } catch (e) {
      log("❌ Ошибка при сохранении временного файла: $e");
      return null;
    }
  }

  Future<void> _cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFiles = tempDir.listSync().whereType<File>().where((file) => file.path.contains(_tempPrefix));

      for (final file in tempFiles) {
        await file.delete();
      }
    } catch (e) {
      log("⚠️ Ошибка при очистке временных файлов: $e");
    }
  }

  Future<String?> savePdfToDownloads(Uint8List qrData) async {
    try {
      // Проверяем разрешения
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        log("❌ Нет разрешения на сохранение файлов");
        return null;
      }

      final pdfData = await _generatePdf(qrData);
      final directory = await _getDownloadPath();

      if (directory == null) {
        log("❌ Не удалось получить директорию для сохранения");
        return null;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/finipay_qr_$timestamp.pdf';

      await File(filePath).writeAsBytes(pdfData);
      log("✅ PDF сохранён: $filePath");

      return filePath;
    } catch (e) {
      log("❌ Ошибка при сохранении PDF: $e");
      return null;
    }
  }

  Future<Directory?> _getDownloadPath() async {
    try {
      if (Platform.isAndroid) {
        // Для Android используем директорию загрузок
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          return await getExternalStorageDirectory();
        }
        return directory;
      } else if (Platform.isIOS) {
        // Для iOS используем директорию документов
        return await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      log("❌ Ошибка при получении пути для загрузки: $e");
    }
    return null;
  }

  Uint8List? decodeQr(String base64Qr) {
    try {
      return base64Decode(base64Qr);
    } catch (e) {
      log("❌ Ошибка при декодировании QR: $e");
      return null;
    }
  }
}
