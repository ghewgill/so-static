<?xml version="1.0"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xt="http://www.jclark.com/xt"
    extension-element-prefixes="xt"
>

<xsl:output
    indent="yes"
    method="html"
    doctype-public="-//W3C//DTD HTML 4.01//EN"
    doctype-system="http://www.w3.org/TR/html4/strict.dtd"
/>

<xsl:template match="/">
    <html>
        <head>
            <title>Stack Overflow static mirror</title>
        </head>
        <body>
            <p>
                This is a static mirror of <a href="http://stackoverflow.com">stackoverflow.com</a>.
            </p>
            <p>
                The <a href="/robots.txt">robots.txt</a> file for this site disallows all spiders, to avoid sucking google-juice away from the real site.
            </p>
            <p>
                <a href="questions.html">All <xsl:value-of select="count(/so/question)" /> question titles on a single page</a> (24+ MB)
            </p>
            <!--table>
                <xsl:for-each select="document('tags.xml')/tags/tag">
                    <xsl:variable name="tag" select="." />
                    <xsl:call-template name="tag-page">
                        <xsl:with-param name="tag" value="$tag" />
                    </xsl:call-template>
                    <tr>
                        <td><a href="/tags/{$tag}.html"><xsl:value-of select="$tag" /></a></td>
                        <td><xsl:value-of select="count(/so/question[tag/text() = $tag])" /></td>
                    </tr>
                </xsl:for-each>
            </table-->
        </body>
    </html>
    <xt:document href="questions.html">
        <html>
            <head>
                <title>All Questions</title>
            </head>
            <body>
                <xsl:for-each select="/so/question">
                    <div><a href="/questions/{@Id}.html"><xsl:value-of select="@Title" /></a></div>
                </xsl:for-each>
            </body>
        </html>
    </xt:document>
</xsl:template>

<xsl:template name="tag-page">
    <xsl:param name="tag" />
    <xt:document href="tags/{$tag}.html">
        <html>
            <head>
                <title>Questions tagged <xsl:value-of select="$tag" /></title>
            </head>
            <body>
                <xsl:for-each select="/so/question[tag/text() = $tag]">
                    <div><a href="/questions/{@Id}.html"><xsl:value-of select="@Title" /></a></div>
                </xsl:for-each>
            </body>
        </html>
    </xt:document>
</xsl:template>

</xsl:stylesheet>
