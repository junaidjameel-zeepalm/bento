import * as functions from 'firebase-functions';
import axios from 'axios';
import * as cheerio from 'cheerio';
import { map } from 'cheerio/dist/commonjs/api/traversing';

export const fetchWebsiteData = functions.https.onCall(async (req: any, res:any) => {
    const url = req.query.url as string;

  if (!url) {
    return res.status(400).json({ error: 'URL parameter is required' });
  }

  try {
    const { data } = await axios.get(url, {
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
      },
    });

    // Parse HTML with Cheerio
    const $ = cheerio.load(data);

    // Extract title
    const title = $('title').text() || '';

    // Extract favicon
    let faviconUrl = $('link[rel="icon"]').attr('href');
    if (!faviconUrl) {
      faviconUrl = $('link[rel="shortcut icon"]').attr('href') || '';
    }

    if (faviconUrl && !faviconUrl.startsWith('http')) {
      const baseUrl = new URL(url);
      faviconUrl = `${baseUrl.origin}${faviconUrl.startsWith('/') ? '' : '/'}${faviconUrl}`;
    }

return {
  title,
  faviconUrl,
  

} ;

  } catch (error) {
    console.error('Error fetching website data:', error);
  return  {}
  }
});
