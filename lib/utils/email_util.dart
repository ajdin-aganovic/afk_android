import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailUtil {
  static Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final smtpServer = gmail('aplikacijafudbalskogkluba@gmail.com', 'leneytiifigvuucr');

    final message = Message()
      ..from = Address('aplikacijafudbalskogkluba@gmail.com', 'Aplikacija Fudbalskog Kluba')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
