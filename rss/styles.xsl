<?xml version="1.0" encoding="UTF-8"?>
<!-- Makes the feed readable when opened in a browser. Feed readers ignore it. -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="/rss/channel/title"/> · feed</title>
        <style>
          :root { color-scheme: light dark; }
          body { max-width: 66ch; margin: 3rem auto; padding: 0 16px; font: 18px/1.55 Georgia, 'Times New Roman', serif; }
          h1 { font-weight: 500; margin: 0 0 .25rem; }
          .note { color: #777; font: 14px/1.4 system-ui, sans-serif; margin: 0 0 2rem; }
          .item { margin: 1.4rem 0; }
          .item a { font-size: 1.15rem; }
          .date { color: #777; font: 13px system-ui, sans-serif; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="/rss/channel/title"/></h1>
        <p class="note">This is the RSS feed. Paste this page's address into a feed reader to subscribe. <a href="/">Back to the site.</a></p>
        <xsl:for-each select="/rss/channel/item">
          <div class="item">
            <a><xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute><xsl:value-of select="title"/></a>
            <div class="date"><xsl:value-of select="pubDate"/></div>
            <p><xsl:value-of select="description"/></p>
          </div>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
