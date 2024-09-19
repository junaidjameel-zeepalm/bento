import * as functions from 'firebase-functions';
import axios from 'axios';
import * as cheerio from 'cheerio';

exports.getWebsiteInfo = functions.https.onCall(async (data, context) => {
  if (!data.url) {
    throw new functions.https.HttpsError('invalid-argument', 'The URL must be provided.');
  }

  try {
    const url = data.url;
    const response = await axios.get(url);
    const html = response.data;

    const $ = cheerio.load(html);

    // Extract title
    const title = $('head title').text();

    // Extract favicon
    let faviconUrl = '';
    const link = $('link[rel="icon"], link[rel="shortcut icon"]').attr('href');
    if (link) {
      faviconUrl = new URL(link, url).href; // Ensure it's a full URL
    }

    return {
      title,
      faviconUrl
    };
  } catch (error) {
    console.error('Error fetching website info:', error);
    throw new functions.https.HttpsError('internal', 'Failed to fetch website info.');
  }
});