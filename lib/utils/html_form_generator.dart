import 'package:flutter/foundation.dart';

String generatePaymentForm(String accessToken) {
  final html = '''
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Redirecting to PayFast</title>
    </head>
    <body onload="document.f.submit();">
      <form name="f" method="post" action="https://ipguat.apps.net.pk/Ecommerce/index.jsp">
        <input type="hidden" name="ACCESS_TOKEN" value="$accessToken" />
        <input type="hidden" name="SUCCESS_URL" value="https://success.payfast.local/" />
        <input type="hidden" name="FAILURE_URL" value="https://failure.payfast.local/" />
      </form>
      <p>Redirecting to PayFast, please wait...</p>

      <script>
        console.log('PayFast Form submitting...');
        console.log('ACCESS_TOKEN:', '$accessToken');
        console.log('Action URL:', 'https://ipguat.apps.net.pk/Ecommerce/index.jsp');
      </script>
    </body>
  </html>
  ''';

  if (kDebugMode) {
    print("📤 [PayFast Form Generator]");
    print("🔐 Token: $accessToken");
    print("➡️ Action: https://ipguat.apps.net.pk/Ecommerce/index.jsp");
    print("✅ Success URL: https://success.payfast.local/");
    print("❌ Failure URL: https://failure.payfast.local/");
  }

  return html;
}
