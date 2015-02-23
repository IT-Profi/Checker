<!-- 
========================================================================
LICENSE AGREEMENT:
This software is distributed WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
========================================================================
This copy of Checker (an automated compare tool) is licensed under the
Lesser General Public License (LGPL), version 3 ("the License").

See the License for details about distribution rights, 
modification and transformation of it.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
========================================================================
Copyright:
(c) 2010-2015 by InterSecurity GmbH & Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:xxx="http://compare.intersecurity.net/dummy/" exclude-result-prefixes="xsl" version="2.0">
    <xsl:param name="type" select="'master'"/> <!-- current or master -->
    <xsl:param name="mode" select="'change'"/> <!-- 'change' or 'list' -->
    <xsl:output method="xml" omit-xml-declaration="yes" indent="no"/>
    <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xxx"/>
    <xsl:variable name="NamespaceList" select="/cs:step/cs:namespaces"/>    
    
    <!-- 
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" use-character-maps="a"/>
    <xsl:character-map name="a">
        <xsl:output-character character="<" string="<"/>
        <xsl:output-character character=">" string=">"/>
    </xsl:character-map>
     -->
    <xsl:template match="/">
        <xxx:stylesheet xmlns:er="http://compare.intersecurity.net/error-report/" version="2.0">
            <xsl:for-each select="$NamespaceList/cs:namespace">
                <xsl:namespace name="{@prefix}" select="@uri"/>
            </xsl:for-each>
            <xxx:template match="/">
                <xsl:choose>
                    <xsl:when test="$mode='list'">
                        <cs:changes type="CLEANUP">
                            <xxx:apply-templates/>
                        </cs:changes>
                    </xsl:when>
                    <xsl:otherwise>
                        <xxx:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xxx:template>
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="$mode='list'">
                    <xxx:template match="node()|@*" priority="-1">
                        <xxx:apply-templates select="node()|@*"/>
                    </xxx:template>
                    <xsl:comment> ### XML Path ### </xsl:comment>
                    <xxx:function name="cs:getXPath" as="xs:string">
                        <xxx:param name="Node"/>
                        <xxx:variable name="XPath">
                            <xxx:call-template name="XPath">
                                <xxx:with-param name="Node" select="$Node"/>
                            </xxx:call-template>
                        </xxx:variable>
                        <xxx:value-of select="$XPath"/>
                    </xxx:function>
                    <xxx:variable name="Quotation">'</xxx:variable>
                    <xxx:template name="XPath">
                        <xxx:param name="Node"/>
                        <xxx:choose>
                            <xxx:when test="$Node instance of document-node()"/>
                            <xxx:when test="$Node instance of attribute()">
                                <xxx:choose>
                                    <xxx:when test="$Node[not(local-name()='step' and namespace-uri()='http://checker.bintellix.de/checkset/')]">
                                        <xxx:call-template name="XPath">
                                            <xxx:with-param name="Node" select="$Node/.."/>
                                        </xxx:call-template>
                                    </xxx:when>
                                </xxx:choose>
                                <xxx:value-of select="concat('[@',$Node/name(), '=',$Quotation,$Node,$Quotation,']')"/>
                                <xxx:text>
                                </xxx:text>
                            </xxx:when>
                            <xxx:when test="$Node instance of element()">
                                <xxx:call-template name="XPath">
                                    <xxx:with-param name="Node" select="$Node/.."/>
                                </xxx:call-template>
                                <xxx:value-of select="concat('/',$Node/name())"/>
                                <xxx:variable name="CountPreSiblings" select="count($Node/preceding-sibling::*[name()=name($Node)])"/>
                                <xxx:if test="$CountPreSiblings">
                                    <xxx:value-of select="concat('[', $CountPreSiblings +1, ']')"/>
                                </xxx:if>
                            </xxx:when>
                            <xxx:when test="$Node instance of text()">
                                <xxx:call-template name="XPath">
                                    <xxx:with-param name="Node" select="$Node/.."/>
                                </xxx:call-template>
                                <xxx:text>[text()='</xxx:text>
                                <xxx:value-of select="$Node"/>
                                <xxx:text>']</xxx:text>
                            </xxx:when>
                            <xxx:when test="$Node instance of comment()">
                                <xxx:text>[comment()='</xxx:text>
                                <xxx:value-of select="cs:escapeString($Node)"/>
                                <xxx:text>']</xxx:text>
                            </xxx:when>
                            <xxx:when test="$Node instance of processing-instruction()">
                                <xxx:text>[processing-instruction()='</xxx:text>
                                <xxx:value-of select="cs:escapeString($Node)"/>
                                <xxx:text>']</xxx:text>
                            </xxx:when>
                            <xxx:otherwise>
                                <xxx:text>Invalid type</xxx:text>
                            </xxx:otherwise>
                        </xxx:choose>
                    </xxx:template>
                    <xxx:function name="cs:escapeString">
                        <xxx:param name="String" as="xs:string"/>
                        <xxx:value-of select="$String"/>
                    </xxx:function>
                </xsl:when>
                <xsl:otherwise>
                    <xxx:template match="node()|@*" priority="-1">
                        <xxx:copy>
                            <xxx:apply-templates select="node()|@*"/>
                        </xxx:copy>
                    </xxx:template>
                </xsl:otherwise>
            </xsl:choose>
        </xxx:stylesheet>
    </xsl:template>
    <xsl:template match="cs:group">
        <xsl:if test="../../cs:usage/cs:use-group[@ref-id=current()/@id]/@enabled='true'">
            <xsl:if test="@filter">
                <xsl:apply-templates/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!-- remove -->
    <xsl:template match="cs:check[not(@enabled='false') and @type='REMOVE' and ((@master-enabled='true' and $type='master') or (@current-enabled='true' and $type='current'))]" priority="1">
        <xxx:template priority="{count(preceding::cs:group)*1000+count(preceding-sibling::cs:check)}">
            <xsl:attribute name="match">
                <xsl:value-of select="@filter"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$mode='list'">
                    <cs:change type="REMOVE" note="{@comment}">
                        <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                    </cs:change>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment>
                        <xsl:text> REMOVE </xsl:text>
                        <xsl:value-of select="@comment"/>
                        <xsl:value-of select="@message"/>
                    </xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xxx:template>
    </xsl:template>
    <!-- replace -->
    <xsl:template match="cs:check[not(@enabled='false') and @type='REPLACE' and ((@master-enabled='true' and $type='master') or (@current-enabled='true' and $type='current'))]" priority="1">
        <xxx:template priority="{count(preceding::cs:group)*1000+count(preceding-sibling::cs:check)}">
            <xsl:attribute name="match">
                <xsl:value-of select="@filter"/>
            </xsl:attribute>
            <xsl:variable name="Value">
                <xsl:choose>
                    <xsl:when test="starts-with(@message, '&lt;')">
                        <xsl:call-template name="unescape">
                            <xsl:with-param name="text" select="@message"/>
                        </xsl:call-template>                    
                        <!-- <xsl:value-of select="@message" disable-output-escaping="yes"/> -->
                    </xsl:when>
                    <xsl:when test="starts-with(@message, '{')">
                        <xsl:element name="xsl:value-of">
                            <xsl:attribute name="select">
                                <xsl:value-of select="substring-before(substring-after(@message,'{'),'}')"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="ends-with(@filter, 'text()')">
                        <xsl:value-of select="@message"/>
                    </xsl:when>
                    <xsl:when test="matches(@filter, '@[A-Za-z0-9_]+$','sm')">
                        <xxx:attribute name="{replace(@filter,'^(.*)?@','')}" select="'{@message}'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@message"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$mode='list'">
                    <cs:change type="REPLACE" note="{@comment}">
                        <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                        <xxx:attribute name="value">
                            <xsl:value-of select="$Value"/>
                        </xxx:attribute>
                    </cs:change>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment>
                        <xsl:text> REPLACE </xsl:text>
                        <xsl:value-of select="@comment"/>
                        <xsl:text>- Updated to value:</xsl:text>
                        <xsl:value-of select="@message"/>
                    </xsl:comment>
                    <xsl:value-of select="$Value"/>
                </xsl:otherwise>
            </xsl:choose>
        </xxx:template>
    </xsl:template>
    <xsl:template name="unescape">
        <xsl:param name="text"/>
        <xsl:analyze-string select="$text" regex="(&lt;([A-Za-z][A-Za-z0-9:_-]*)( [A-Za-z][A-Za-z0-9:_-]*=&#34;.*?&#34;)*( [A-Za-z][A-Za-z0-9:_-]*='.*?')*&gt;.*?&lt;/\2&gt;)|(&lt;([A-Za-z][A-Za-z0-9:_-]*)( [A-Za-z][A-Za-z0-9:_-]*=&#34;.*?&#34;)*( [A-Za-z][A-Za-z0-9:_-]*='.*?')*/&gt;)|(&lt;[A-Za-z][A-Za-z0-9:_-]*/&gt;)" flags="sm">
            <xsl:matching-substring>
                <!-- Test data:
                 <cs:checks>
                    <xsl:value-of select="text()">ABC;</xsl:value-of>
                    <xsl:value-of select='text()'>ABC;</xsl:value-of>
                    <xsl:value-of select="text()"/>
                    <xsl:value-of select='text()'/>
                    <xsl:value/>
                    <value/>
                    <grossAmount>ABC</grossAmount>                      
                </cs:checks>
                -->
                <!-- Debug output:
                <xsl:text>[</xsl:text><xsl:value-of select="$text"/>
                <xsl:text> 1:</xsl:text><xsl:value-of select="regex-group(1)"/>
                <xsl:text> 2:</xsl:text><xsl:value-of select="regex-group(2)"/>
                <xsl:text> 3:</xsl:text><xsl:value-of select="regex-group(3)"/>
                <xsl:text> 4:</xsl:text><xsl:value-of select="regex-group(4)"/>
                <xsl:text> 5:</xsl:text><xsl:value-of select="regex-group(5)"/>
                <xsl:text> 6:</xsl:text><xsl:value-of select="regex-group(6)"/>
                <xsl:text> 7:</xsl:text><xsl:value-of select="regex-group(7)"/>
                <xsl:text> 8:</xsl:text><xsl:value-of select="regex-group(8)"/>
                <xsl:text> 9:</xsl:text><xsl:value-of select="regex-group(9)"/>
                <xsl:text> 10:</xsl:text><xsl:value-of select="regex-group(10)"/>
                <xsl:text> 11:</xsl:text><xsl:value-of select="regex-group(11)"/>
                <xsl:text> 12:</xsl:text><xsl:value-of select="regex-group(12)"/>
                <xsl:text> 13:</xsl:text><xsl:value-of select="regex-group(13)"/>
                <xsl:text>]</xsl:text>
                -->
                <xsl:choose>
                    <xsl:when test="regex-group(1)"> <!-- XML tags (maybe with attributes) -->
                        <xsl:variable name="Element" select="regex-group(2)"/>
                        <xsl:element name="{$Element}">
                            <xsl:if test="string-length(regex-group(3)) &gt; 0">
                                <xsl:attribute name="{substring-before(regex-group(3),'=')}" select="substring-before(substring-after(regex-group(3),'=&#34;'),'&#34;')"/>
                            </xsl:if>
                            <xsl:if test="string-length(regex-group(4)) &gt; 0">
                                <xsl:attribute name="{substring-before(regex-group(4),'=')}" select="substring-before(substring-after(regex-group(4),&#34;='&#34;),&#34;'&#34;)"/>
                            </xsl:if>
                            <xsl:call-template name="unescape">
                                <xsl:with-param name="text" select="substring-before(substring-after(., '&gt;'),concat('&lt;/', $Element, '&gt;'))"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="regex-group(5)"> <!-- single closing XML tag (maybe tag with attributes) -->
                        <xsl:variable name="Element" select="regex-group(6)"/>
                        <xsl:element name="{$Element}">
                            <xsl:if test="string-length(regex-group(7)) &gt; 0">
                                <xsl:attribute name="{substring-before(regex-group(7),'=')}" select="substring-before(substring-after(regex-group(7),'=&#34;'),'&#34;')"/>
                            </xsl:if>
                            <xsl:if test="string-length(regex-group(8)) &gt; 0">
                                <xsl:attribute name="{substring-before(regex-group(8),'=')}" select="substring-before(substring-after(regex-group(8),&#34;='&#34;),&#34;'&#34;)"/>
                            </xsl:if>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>UNKNOWN FORMAT</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="node()|@*">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>