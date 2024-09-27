import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:requests_plus/requests_plus.dart';
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
      // Define headers if needed
      final headers = {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.9',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
      };

      // Using the RequestsPlus package to send the request
      final response = await RequestsPlus.get(url, headers: headers);

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
        log('Failed to load website data with status code: ${response.statusCode}');
        return {'title': 'Unable to fetch', 'faviconUrl': ''};
      }
    } catch (e) {
      log('Error fetching website data: $e');
      return {'title': 'Error fetching data', 'faviconUrl': ''};
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
