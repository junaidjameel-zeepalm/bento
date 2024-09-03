import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class WebsitePreview extends StatefulWidget {
  final String url;

  const WebsitePreview({super.key, required this.url});

  @override
  WebsitePreviewState createState() => WebsitePreviewState();
}

class WebsitePreviewState extends State<WebsitePreview> {
  String? title;
  String? faviconUrl;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<Map<String, String>> fetchWebsiteData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        // Extract title
        String title = document.querySelector('title')?.text ?? '';

        // Extract favicon
        String? faviconUrl;
        var faviconElement = document.querySelector(
          'link[rel="icon"], link[rel="shortcut icon"], link[rel="apple-touch-icon"]',
        );
        if (faviconElement != null) {
          faviconUrl = faviconElement.attributes['href'];
          if (faviconUrl != null && !faviconUrl.startsWith('http')) {
            final uri = Uri.parse(url);
            faviconUrl =
                '${uri.scheme}://${uri.host}${faviconUrl.startsWith('/') ? '' : '/'}$faviconUrl';
          }
        }

        log('Fetched Title: $title');
        log('Fetched Favicon URL: $faviconUrl');

        return {'title': title, 'faviconUrl': faviconUrl ?? ''};
      } else {
        throw Exception('Failed to load website data');
      }
    } catch (e) {
      log('Error: $e');
      throw Exception('Error: $e');
    }
  }

  void _fetchData() async {
    try {
      final data = await fetchWebsiteData(widget.url);
      setState(() {
        title = data['title'];
        faviconUrl = data['faviconUrl'];
      });
    } catch (e) {
      print(e);
      setState(() {
        title = widget.url;
        faviconUrl = '';
      });
    }
  }

  void _launchUrl() async {
    if (await canLaunch(widget.url)) {
      await launch(widget.url);
    } else {
      log('Could not launch ${widget.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (faviconUrl != null && faviconUrl!.isNotEmpty)
                  Image.network(
                    faviconUrl!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.link),
                  )
                else
                  const Icon(Icons.link),
                const SizedBox(height: 15),
                if (title != null)
                  Text(
                    title!,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  const Text('Loading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
