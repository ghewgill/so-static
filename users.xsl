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

<xsl:template match="//row">
    <html>
        <head>
            <title><xsl:value-of select="@DisplayName" /></title>
        </head>
        <body>
            <h1>
                <xsl:choose>
                    <xsl:when test="string-length(@DisplayName) != 0">
                        <xsl:value-of select="@DisplayName" />
                    </xsl:when>
                    <xsl:otherwise>
                        unknown
                    </xsl:otherwise>
                </xsl:choose>
            </h1>
            <div>
                Reputation: <xsl:value-of select="@Reputation" />
            </div>
            <xsl:if test="@WebsiteUrl">
                <div>
                    Website: <a href="{@WebsiteUrl}"><xsl:value-of select="@WebsiteUrl" /></a>
                </div>
            </xsl:if>
            <xsl:if test="@Location">
                <div>
                    Location: <xsl:value-of select="@Location" />
                </div>
            </xsl:if>
            <!--div>
                Topics:
                <xsl:for-each select="document('badges.xml')/badges/row[@UserId = ./@Id]
            </div-->
            <p>
                <xsl:value-of select="@AboutMe" disable-output-escaping="yes" />
            </p>
        </body>
    </html>
</xsl:template>

</xsl:stylesheet>
