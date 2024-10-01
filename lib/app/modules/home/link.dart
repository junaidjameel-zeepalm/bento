import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_functions/cloud_functions.dart';

class WebsitePreview extends StatefulWidget {
  final String url;

  const WebsitePreview({super.key, required this.url});

  @override
  WebsitePreviewState createState() => WebsitePreviewState();
}

class WebsitePreviewState extends State<WebsitePreview> {
  String? title;
  String? faviconUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<Map<String, dynamic>> fetchWebsiteData(String url) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('fetchWebsiteData');
      final response = await callable.call(url);
      log('Response after sending email: ${response.data}');
      return response.data as Map<String, dynamic>;
    } on Exception catch (e) {
      log('Error while sending email: $e');
      return {'success': false};
    }
  }

  void _fetchData() async {
    try {
      final data = await fetchWebsiteData(widget.url);
      setState(() {
        title = data['title'];
        faviconUrl = data['faviconUrl'];
        isLoading = false;
      });
    } catch (e) {
      log('Error: $e');
      setState(() {
        title = widget.url;
        faviconUrl = '';
        isLoading = false;
      });
    }
  }

  void _launchUrl() async {
    if (await canLaunchUrl(Uri.parse(widget.url))) {
      await launchUrl(Uri.parse(widget.url));
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
                // Display favicon if available, otherwise show an icon
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

                // Display the title or loading state
                if (isLoading)
                  const Text('Loading...')
                else if (title != null)
                  Text(
                    title!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                else
                  const Text('No Title Found'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CallableService {
//   static Future<Map<String, dynamic>> sendEmail(
//       InviteViaEmailModel invite) async {}
// }
