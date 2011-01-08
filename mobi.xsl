<?xml version="1.0"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xt="http://www.jclark.com/xt"
    extension-element-prefixes="xt"
>

<xsl:output
    indent="yes"
/>

<xsl:param name="tag" select="'git'" />
<xsl:param name="minq" select="10" />

<xsl:template match="/">
    <xsl:variable name="questions" select="/so/question[($tag = '' or tag = $tag) and ($minq = '' or @Score >= $minq)]" />
    <xsl:variable name="date">
        <xsl:call-template name="format-month">
            <xsl:with-param name="timestamp" select="$questions[last()]/@CreationDate" />
        </xsl:call-template>
    </xsl:variable>
    <package unique-identifier="uid" xmlns:dc="Dublin Core">
        <metadata>
            <dc-metadata>
                <dc:Identifier id="uid">stack_overflow</dc:Identifier>
                <dc:Title>Stack Overflow - <xsl:value-of select="$tag" /> (<xsl:value-of select="count($questions)" />) - <xsl:value-of select="$date" /></dc:Title>
                <dc:Language>EN</dc:Language>
            </dc-metadata>
        </metadata>
        <xsl:message>Total questions: <xsl:value-of select="count($questions)" /></xsl:message>
        <manifest>
            <item id="contents" href="contents.html" media-type="text/html" />
            <xsl:for-each select="$questions">
                <xsl:variable name="fn">
                    <xsl:call-template name="shard">
                        <xsl:with-param name="id" select="@Id" />
                    </xsl:call-template>
                </xsl:variable>
                <item id="q{@Id}" href="static/questions/{$fn}.html" media-type="text/html" />
            </xsl:for-each>
            <item id="toc" media-type="application/x-dtbncx+xml" href="toc.ncx" />
        </manifest>
        <spine toc="toc">
            <itemref idref="contents" />
            <xsl:for-each select="$questions">
                <xsl:sort select="@Id" data-type="number" order="descending" />
                <itemref idref="q{@Id}" />
            </xsl:for-each>
        </spine>
    </package>
    <xt:document href="contents.html">
        <html>
            <body>
                <h1>Stack Overflow - <xsl:value-of select="$tag" /> - <xsl:value-of select="$date" /></h1>
                <xsl:for-each select="$questions">
                    <xsl:sort select="@Score" order="descending" data-type="number" />
                    <xsl:variable name="fn">
                        <xsl:call-template name="shard">
                            <xsl:with-param name="id" select="@Id" />
                        </xsl:call-template>
                    </xsl:variable>
                    <div>
                        <a href="static/questions/{$fn}.html">
                            <xsl:value-of select="@Score" />: <xsl:value-of select="@Title" />
                        </a>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xt:document>
    <xt:document href="toc.ncx">
        <ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1" xml:lang="en-US">
            <docTitle><text>Stack Overflow</text></docTitle>
            <navMap>
                <navPoint class="toc" id="toc" playOrder="1">
                    <navLabel><text>Table of Contents</text></navLabel>
                    <content src="contents.html" />
                </navPoint>
                <xsl:for-each select="$questions">
                    <navPoint class="chapter" id="q{@Id}" playOrder="{1 + position()}">
                        <navLabel><text><xsl:value-of select="@Title" /></text></navLabel>
                        <xsl:variable name="fn">
                            <xsl:call-template name="shard">
                                <xsl:with-param name="id" select="@Id" />
                            </xsl:call-template>
                        </xsl:variable>
                        <content src="static/questions/{$fn}.html" />
                    </navPoint>
                </xsl:for-each>
            </navMap>
        </ncx>
    </xt:document>
</xsl:template>

<xsl:template name="shard">
    <xsl:param name="id" />
    <xsl:choose>
        <xsl:when test="string-length($id) &lt;= 3">
            <xsl:value-of select="$id" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="rest">
                <xsl:call-template name="shard">
                    <xsl:with-param name="id" select="substring($id, 4)" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat(substring($id, 1, 3), '/', $rest)" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="format-month">
    <xsl:param name="timestamp" />
    <xsl:variable name="month" select="substring($timestamp, 6, 2)" />
    <xsl:choose>
        <xsl:when test="$month = '01'">Jan</xsl:when>
        <xsl:when test="$month = '02'">Feb</xsl:when>
        <xsl:when test="$month = '03'">Mar</xsl:when>
        <xsl:when test="$month = '04'">Apr</xsl:when>
        <xsl:when test="$month = '05'">May</xsl:when>
        <xsl:when test="$month = '06'">Jun</xsl:when>
        <xsl:when test="$month = '07'">Jul</xsl:when>
        <xsl:when test="$month = '08'">Aug</xsl:when>
        <xsl:when test="$month = '09'">Sep</xsl:when>
        <xsl:when test="$month = '10'">Oct</xsl:when>
        <xsl:when test="$month = '11'">Nov</xsl:when>
        <xsl:when test="$month = '12'">Dec</xsl:when>
    </xsl:choose>
    <xsl:value-of select="' '" />
    <xsl:value-of select="substring($timestamp, 1, 4)" />
</xsl:template>

</xsl:stylesheet>
