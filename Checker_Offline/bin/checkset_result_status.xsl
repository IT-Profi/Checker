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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:diff="http://compare.intersecurity.net/diff/" xmlns:er="http://compare.intersecurity.net/error-report/" exclude-result-prefixes="#all" version="2.0">
    <xsl:param name="CurrentSchemaDisabled" select="'no'"/>
    <xsl:param name="CurrentValidateDisabled" select="'no'"/>
    <xsl:param name="CurrentCompareDisabled" select="'no'"/>
    <xsl:param name="MasterSchemaDisabled" select="'no'"/>
    <xsl:param name="MasterValidateDisabled" select="'no'"/>
    <xsl:param name="MasterCompareDisabled" select="'no'"/>
    <xsl:param name="MasterDisabled" select="'no'"/>
    <xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="no"/>
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- nothing to do: /cs:run/cs:result/cs:current/cs:document -->
    <!-- nothing to do: /cs:run/cs:result/cs:master/cs:document -->
    <xsl:template match="/cs:run/cs:result/cs:current/cs:schema/@status">
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="$CurrentSchemaDisabled='yes'">
                    <xsl:text>disabled</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../cs:data//c:errors[string-length(.) = 0] or ../cs:data/cs:error or ..//c:error">
                            <xsl:text>failed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>fine</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="/cs:run/cs:result/cs:master/cs:schema/@status">
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="$MasterSchemaDisabled='yes'">
                    <xsl:text>disabled</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../cs:data//c:errors[string-length(.) = 0] or ../cs:data/cs:error or ..//c:error">
                            <xsl:text>failed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>fine</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="/cs:run/cs:result/cs:current/cs:validate/@status">
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="$CurrentValidateDisabled='yes'">
                    <xsl:text>disabled</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../cs:data//er:critical or ../cs:data//er:error or ..//c:error">
                            <xsl:text>failed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>fine</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="/cs:run/cs:result/cs:master/cs:validate/@status">
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="$MasterValidateDisabled='yes' or $MasterDisabled='yes'">
                    <xsl:text>disabled</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../cs:data//er:critical or ../cs:data//er:error or ..//c:error">
                            <xsl:text>failed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>fine</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="/cs:run/cs:result/cs:current/cs:compare/@status">
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="$CurrentCompareDisabled='yes' or $MasterDisabled='yes'">
                    <xsl:text>disabled</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../cs:data//@diff:*[local-name()!='moved'] or ../cs:data//diff:* or ../cs:data//er:critical or ../cs:data//er:error or ..//c:error">
                            <xsl:text>failed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>fine</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="/cs:run/cs:result/cs:master/cs:compare/@status">
        <xsl:attribute name="status">
            <xsl:choose>
                <xsl:when test="$MasterCompareDisabled='yes' or $MasterDisabled='yes'">
                    <xsl:text>disabled</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="../cs:data//@diff:*[local-name()!='moved'] or ../cs:data//diff:* or ../cs:data//er:critical or ../cs:data//er:error or ..//c:error">
                            <xsl:text>failed</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>fine</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="node()|@*" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>