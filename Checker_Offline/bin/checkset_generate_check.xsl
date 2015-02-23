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
(c) 2010-2014 by InterSecurity GmbH & Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:xxx="http://compare.intersecurity.net/dummy/" xmlns:err="http://compare.intersecurity.net/error-report/" exclude-result-prefixes="xsl" version="2.0">
    <xsl:param name="Cleanup" select="false()"/>
    <xsl:param name="type" select="'master'"/> <!-- current or master -->
    <xsl:param name="mode" select="'change'"/> <!-- 'change' or 'list' -->
    <xsl:output omit-xml-declaration="yes" indent="no"/>
    <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="xxx"/>
    <xsl:variable name="NamespaceList" select="/cs:step/cs:namespaces"/>
    <xsl:template match="/">
        <xxx:stylesheet xmlns:er="http://compare.intersecurity.net/error-report/" version="2.0">
            <xsl:for-each select="$NamespaceList/cs:namespace">
                <xsl:namespace name="{@prefix}" select="@uri"/>
            </xsl:for-each>
            <xxx:template match="/">
                <xsl:choose>
                    <xsl:when test="$mode='list'">
                        <cs:changes type="VALIDATE">
                            <xxx:apply-templates/>
                        </cs:changes>
                    </xsl:when>
                    <xsl:otherwise>
                        <result>
                            <xxx:apply-templates/>
                        </result>
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
                                    <xxx:when test="$Node/name() != 'cs:step'">
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
    <xsl:template match="cs:check[@enabled=false()]" priority="2">
        <!-- not used -->
    </xsl:template>
    
    <!-- <cs:use-group enabled="true" filter="/fpr:SFFinanceProductResponse" ref-id="global_20140819w0aab3b2b2" title="Sanity Checks FP" type="VALIDATE"/> -->
    <!-- <cs:check comment="" filter="Parameter[@parameterId='VehicleModelName']/ParameterDescriptions/ParameterDescription[parameterName != '{{CfgModel}}']" current-enabled="true" master-enabled="true" message="The VehicleModelName should use the variable name CfgModel to resolve the real name within the client." name="VehicleModelName" type="WARNING"/> -->
    <xsl:template match="cs:check[not(@enabled=false()) and ../../@type='VALIDATE' and ((@master-enabled='true' and $type='master') or (@current-enabled='true' and $type='current'))]" priority="1">
        <xxx:template>
            <xsl:attribute name="match">
                <xsl:choose>
                    <xsl:when test="contains(@filter, '[')">
                        <xsl:value-of select="@filter"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>*[{</xsl:text>
                        <xsl:value-of select="replace(replace(@filter,'\{','{{'),'\}','}}')"/>
                        <xsl:text>}]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xxx:if>
                <xsl:attribute name="test">
                    <xsl:choose>
                        <xsl:when test="string-length(../../../@filter) &gt; 0">
                            <xsl:value-of select="../../../@filter"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>true()</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="@type='INFO'">
                        <xsl:choose>
                            <xsl:when test="$mode='list'">
                                <cs:change type="INFO" note="{@comment}">
                                    <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                                </cs:change>
                            </xsl:when>
                            <xsl:otherwise>
                                <err:info fpId="{{ancestor::FinanceProduct/@productId}}" financeProduct="{{ancestor::FinanceProduct/@internalSFProductName}}-{{ancestor::FinanceProduct/@productVersion}}" paramId="{{@parameterId}}" groupName="{../../../@name}" checkName="{@name}">
                                    <xxx:value-of select="'{@message}'"/>
                                </err:info>
                                <xxx:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@type='WARNING'">
                        <xsl:choose>
                            <xsl:when test="$mode='list'">
                                <cs:change type="WARNING" note="{@comment}">
                                    <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                                </cs:change>
                            </xsl:when>
                            <xsl:otherwise>
                                <err:warning fpId="{{ancestor::FinanceProduct/@productId}}" financeProduct="{{ancestor::FinanceProduct/@internalSFProductName}}-{{ancestor::FinanceProduct/@productVersion}}" paramId="{{@parameterId}}" groupName="{../../../@name}" checkName="{@name}">
                                    <xxx:value-of select="'{@message}'"/>
                                </err:warning>
                                <xxx:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@type='ERROR'">
                        <xsl:choose>
                            <xsl:when test="$mode='list'">
                                <cs:change type="ERROR" note="{@comment}">
                                    <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                                </cs:change>
                            </xsl:when>
                            <xsl:otherwise>
                                <err:error fpId="{{ancestor::FinanceProduct/@productId}}" financeProduct="{{ancestor::FinanceProduct/@internalSFProductName}}-{{ancestor::FinanceProduct/@productVersion}}" paramId="{{@parameterId}}" groupName="{../../../@name}" checkName="{@name}">
                                    <xxx:value-of select="'{@message}'"/>
                                </err:error>
                                <xxx:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@type='CRITICAL'">
                        <xsl:choose>
                            <xsl:when test="$mode='list'">
                                <cs:change type="CRITICAL" note="{@comment}">
                                    <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                                </cs:change>
                            </xsl:when>
                            <xsl:otherwise>
                                <err:critical fpId="{{ancestor::FinanceProduct/@productId}}" financeProduct="{{ancestor::FinanceProduct/@internalSFProductName}}-{{ancestor::FinanceProduct/@productVersion}}" paramId="{{@parameterId}}" groupName="{../../../@name}" checkName="{@name}">
                                    <xxx:value-of select="'{@message}'"/>
                                </err:critical>
                                <xxx:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$mode='list'">
                                <cs:change type="OTHER" note="{@comment}">
                                    <xxx:attribute name="xpath" select="cs:getXPath(.)"/>
                                </cs:change>
                            </xsl:when>
                            <xsl:otherwise>
                                <err:note fpId="{{ancestor::FinanceProduct/@productId}}" financeProduct="{{ancestor::FinanceProduct/@internalSFProductName}}-{{ancestor::FinanceProduct/@productVersion}}" paramId="{{@parameterId}}" groupName="{../../../@name}" checkName="{@name}">
                                    <xxx:value-of select="'{@message}'"/>
                                </err:note>
                                <xxx:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xxx:if>
            <xxx:apply-templates/>
        </xxx:template>
    </xsl:template>
    <xsl:template match="node()|@*">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- ### XML Path ### -->
    <xsl:function name="cs:getXPath" as="xs:string">
        <xsl:param name="Node"/>
        <xsl:variable name="XPath">
            <xsl:call-template name="XPath">
                <xsl:with-param name="Node" select="$Node"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$XPath"/>
    </xsl:function>
    <xsl:variable name="Quotation">'</xsl:variable>
    <xsl:template name="XPath">
        <xsl:param name="Node"/>
        <xsl:choose>
            <xsl:when test="$Node instance of document-node()"/>
            <xsl:when test="$Node instance of attribute()">
                <xsl:choose>
                    <xsl:when test="$Node/name() != 'cs:step'">
                        <xsl:call-template name="XPath">
                            <xsl:with-param name="Node" select="$Node/.."/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="concat('[@',$Node/name(), '=',$Quotation,$Node,$Quotation,']')"/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="$Node instance of element()">
                <xsl:call-template name="XPath">
                    <xsl:with-param name="Node" select="$Node/.."/>
                </xsl:call-template>
                <xsl:value-of select="concat('/',$Node/name())"/>
                <xsl:variable name="CountPreSiblings" select="count($Node/preceding-sibling::*[name()=name($Node)])"/>
                <xsl:if test="$CountPreSiblings">
                    <xsl:value-of select="concat('[', $CountPreSiblings +1, ']')"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$Node instance of text()">
                <xsl:call-template name="XPath">
                    <xsl:with-param name="Node" select="$Node/.."/>
                </xsl:call-template>
                <xsl:text>[text()='</xsl:text>
                <xsl:value-of select="$Node"/>
                <xsl:text>']</xsl:text>
            </xsl:when>
            <xsl:when test="$Node instance of comment()">
                <xsl:text>[comment()='</xsl:text>
                <xsl:value-of select="cs:escapeString($Node)"/>
                <xsl:text>']</xsl:text>
            </xsl:when>
            <xsl:when test="$Node instance of processing-instruction()">
                <xsl:text>[processing-instruction()='</xsl:text>
                <xsl:value-of select="cs:escapeString($Node)"/>
                <xsl:text>']</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Invalid type</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:function name="cs:escapeString">
        <xsl:param name="String" as="xs:string"/>
        <xsl:value-of select="$String"/>
    </xsl:function>
</xsl:stylesheet>