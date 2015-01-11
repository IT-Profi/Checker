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
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xml" version="2.0"><xsl:output encoding="UTF-8" method="text" omit-xml-declaration="yes"/><xsl:strip-space elements="*"/><xsl:variable name="BR" select="'&#xD;&#xA;'"/><xsl:variable name="SPACE" select="'   '"/><xsl:param name="SeparateAttributes" select="true()"/><xsl:template match="/"><xsl:apply-templates/></xsl:template><xsl:template match="@*"><xsl:variable name="row" select="count(ancestor::*)"/><xsl:choose><xsl:when test="$SeparateAttributes"><xsl:text> </xsl:text><xsl:value-of select="$BR"/><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each></xsl:when><xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise></xsl:choose><xsl:value-of select="name()"/><xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text></xsl:template><xsl:template match="*"><xsl:variable name="row" select="count(ancestor::*)"/><xsl:choose><xsl:when test="text()"><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:apply-templates select="@*"><xsl:sort select="name()" data-type="text"/></xsl:apply-templates>
                
                <!-- namespaces --><xsl:call-template name="Namespaces"><xsl:with-param name="Element" select="."/><xsl:with-param name="Row" select="$row"/></xsl:call-template><xsl:text>&gt;</xsl:text><xsl:apply-templates select="text()"/><xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;</xsl:text></xsl:when><xsl:when test="node()"><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:apply-templates select="@*"><xsl:sort select="name()" data-type="text"/></xsl:apply-templates>
                
                <!-- namespaces --><xsl:call-template name="Namespaces"><xsl:with-param name="Element" select="."/><xsl:with-param name="Row" select="$row"/></xsl:call-template><xsl:text>&gt;</xsl:text><xsl:value-of select="$BR"/><xsl:apply-templates><xsl:sort select="@lang" data-type="text"/><xsl:sort select="@language" data-type="text"/><xsl:sort select="@languageCode" data-type="text"/></xsl:apply-templates><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;</xsl:text></xsl:when><xsl:otherwise><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:apply-templates select="@*"/><xsl:text>/&gt;</xsl:text></xsl:otherwise></xsl:choose><xsl:value-of select="$BR"/></xsl:template><xsl:template match="text()"><xsl:value-of select="replace(replace(replace(normalize-space(.), '&lt;', '&amp;lt;'), '&gt;', '&amp;gt;'),'&amp;', '&amp;amp;')"/></xsl:template><xsl:template match="processing-instruction()"><xsl:variable name="row" select="count(ancestor::*)"/><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text>&lt;?</xsl:text><xsl:value-of select="."/><xsl:text>?&gt;</xsl:text><xsl:value-of select="$BR"/></xsl:template><xsl:template match="comment()"><xsl:variable name="row" select="count(ancestor::*)"/><xsl:for-each select="1 to $row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text>&lt;?</xsl:text><xsl:value-of select="."/><xsl:text>?&gt;</xsl:text><xsl:value-of select="$BR"/></xsl:template><xsl:template match="node()" priority="-1"><xsl:text>&lt;!--</xsl:text><xsl:text>ERROR: Invalid Element</xsl:text><xsl:value-of select="name(.)"/><xsl:text>--&gt;</xsl:text></xsl:template><xsl:template name="Namespaces"><xsl:param name="Element" required="yes"/><xsl:param name="Row" required="yes" as="item()"/>
        <!-- namespaces --><xsl:if test="count($Element/ancestor::*) = 0"><xsl:for-each select="in-scope-prefixes(.)"><xsl:value-of select="$BR"/><xsl:text> </xsl:text><xsl:for-each select="1 to $Row"><xsl:value-of select="$SPACE"/></xsl:for-each><xsl:text> xmlns:</xsl:text><xsl:value-of select="."/><xsl:text>="</xsl:text><xsl:value-of select="namespace-uri-for-prefix(string(.),$Element)"/><xsl:text>"</xsl:text></xsl:for-each></xsl:if>
        <!--
            <xsl:for-each select="namespace::*[not(. = ancestor::*/namespace::*) or count(ancestor::*)=0]">
                <xsl:value-of select="concat(.,'')"/>
            </xsl:for-each>
        --></xsl:template></xsl:stylesheet>