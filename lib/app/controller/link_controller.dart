import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class LinkController extends GetxController {
  var title = ''.obs;
  var faviconUrl = ''.obs;

  Future<void> fetchWebsiteData(String url) async {
    // Clear the previous values
    title.value = '';
    faviconUrl.value = '';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        // Extract title
        String fetchedTitle = document.querySelector('title')?.text ?? '';

        // Extract favicon
        String? fetchedFaviconUrl;
        var faviconElement = document.querySelector(
          'link[rel="icon"], link[rel="shortcut icon"], link[rel="apple-touch-icon"]',
        );
        if (faviconElement != null) {
          fetchedFaviconUrl = faviconElement.attributes['href'];
          if (fetchedFaviconUrl != null &&
              !fetchedFaviconUrl.startsWith('http')) {
            final uri = Uri.parse(url);
            fetchedFaviconUrl =
                '${uri.scheme}://${uri.host}${fetchedFaviconUrl.startsWith('/') ? '' : '/'}$fetchedFaviconUrl';
          }
        }

        log('Fetched Title: $fetchedTitle');
        log('Fetched Favicon URL: $fetchedFaviconUrl');

        // Update state
        title.value = fetchedTitle;
        faviconUrl.value = fetchedFaviconUrl ?? '';
      } else {
        throw Exception('Failed to load website data');
      }
    } catch (e) {
      log('Error: $e');
      title.value = url; // Fallback to using the URL as the title
      faviconUrl.value = '';
    }
  }
}
