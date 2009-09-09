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

<xsl:template match="question">
    <html>
        <head>
            <title><xsl:value-of select="@Title" /></title>
        </head>
        <body>
            <xsl:variable name="q" select="." />
            <h1><xsl:value-of select="@Title" /></h1>
            <xsl:call-template name="post" />
            <xsl:for-each select="answer">
                <xsl:sort select="@Score" data-type="number" order="descending" />
                <hr />
                <xsl:call-template name="post">
                    <xsl:with-param name="accepted" select="$q/@AcceptedAnswerId" />
                </xsl:call-template>
            </xsl:for-each>
        </body>
    </html>
</xsl:template>

<xsl:template name="post">
    <xsl:param name="accepted" />
    <div>
        Score: <xsl:value-of select="@Score" />
        <xsl:if test="@Id = $accepted">*</xsl:if>
    </div>
    <div>
        <xsl:value-of select="@Body" disable-output-escaping="yes" />
    </div>
    <xsl:if test="@Tags">
        <div>
            <xsl:call-template name="tags">
                <xsl:with-param name="tags" select="@Tags" />
            </xsl:call-template>
        </div>
    </xsl:if>
    <div>
        - <a href="../users/{@OwnerUserId}.html">
            <xsl:value-of select="@OwnerDisplayName" />
        </a>
        (<xsl:value-of select="substring-before(@CreationDate, 'T')" />)
    </div>
</xsl:template>

<xsl:template name="tags">
    <xsl:param name="tags" />
    <xsl:if test="$tags">
        <span><xsl:value-of select="substring-before(substring($tags, 2), '&gt;')" /></span>
        <xsl:if test="contains(substring($tags, 2), '&lt;')">, </xsl:if>
        <xsl:call-template name="tags">
            <xsl:with-param name="tags" select="substring-after($tags, '&gt;')" />
        </xsl:call-template>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
