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
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:diff="http://compare.intersecurity.net/diff/" xmlns:er="http://compare.intersecurity.net/error-report/" exclude-result-prefixes="c diff cs er" version="2.0">
    <xsl:output encoding="UTF-8" method="xhtml" omit-xml-declaration="no" indent="no"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Error Report - <xsl:value-of select="cs:step/cs:identity/cs:step-group"/> / <xsl:value-of select="cs:step/cs:identity/cs:step-id"/>
                </title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <style type="text/css">
                    .info,
                    .fine,
                    .info a {
                    color: green;
                    }
                    .warning,
                    .warning a {
                    color: darkorange;
                    }
                    .warning span.element,
                    .warning span.attribute {
                    color: orange;
                    }
                    .error,
                    .error a {
                    color: red;
                    }
                    .critical,
                    .critical a {
                    color: red;
                    }
                    .note {
                    color: magenta;
                    }
                    span.tag {
                    color: blue;
                    }
                    span.tag2 {
                    color: blue;
                    }
                    span.element {
                    color: #444;
                    }
                    span.attribute {
                    color: #444;
                    }
                    div.moved {
                    background-color: yellow;
                    }
                    div.changed {
                    background-color: darkorange;
                    }
                    .inline {
                    display:inline-block;
                    zoom:1; /* IE 7 Hack starts here*/
                    *display:inline;
                    }
                    .clear:after {
                    content: "";
                    display: table;
                    clear: both;
                    }
                </style>
                <script>
                    function ShowDetails(Identity)
                    {
                        document.getElementById(Identity + '_more').style.display='block';
                        document.getElementById(Identity + '_less').style.display='none';
                    }                    
                    function HideDetails(Identity)
                    {
                        document.getElementById(Identity + '_more').style.display='none';
                        document.getElementById(Identity + '_less').style.display='block';
                    }                    
                </script>
            </head>
            <body>
                <h3>
                    <xsl:text>Run Report</xsl:text>
                </h3>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="cs:current/cs:document | cs:master/cs:document">
        <!-- nothing to do -->
    </xsl:template>
    <xsl:template match="execution">
        <div class="error">An error occured on starting the checkset:</div>
        <div>Commandline:</div>
        <div style="color:blue;">
            <xsl:value-of select="commandline"/>
        </div>
        <br/>
        <div>Console output:</div>
        <div style="color:blue;">
            <xsl:for-each select="stdout/line">
                <div>
                    <xsl:value-of select="."/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="cs:run/cs:result">
        <b class="clear">
            <div style="width:10em; float:left;">Group: </div>
            <xsl:value-of select="../../cs:identity/cs:step-group"/>
            <br/>
            <div style="width:10em; float:left;">Checkset: </div>
            <xsl:value-of select="../../cs:identity/cs:step-id"/>
            <br/>
            <div style="width:10em; float:left;">Date: </div>
            <xsl:value-of select="format-dateTime(../@timestamp,'[Y0001]-[M01]-[D01] [H01]:[m01] [FNn]')"/>
        </b>
        <hr/>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="cs:result/cs:current">
        <h3>Current document</h3>
        <xsl:apply-templates/>
        <hr/>
    </xsl:template>
    <xsl:template match="cs:result/cs:master">
        <h3>Master document</h3>
        <xsl:apply-templates/>
        <hr/>
    </xsl:template>
    <xsl:template match="cs:result/cs:current/cs:schema | cs:result/cs:master/cs:schema">
        <b>Schema Validation</b>
        <xsl:text> - </xsl:text>
        <xsl:choose>
            <xsl:when test="not(@status=('success','fine'))">
                <span class="critical">failed</span>
                <div id="validate{../name()}_less">
                    <a href="javascript:ShowDetails('validate{../name()}');">Details anzeigen</a>
                </div>
                <div id="validate{../name()}_more" style="display:none">
                    <a href="javascript:HideDetails('validate{../name()}');">Details ausblenden</a>
                    <br/>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <b>
                    <span class="fine">fine</span>
                    <xsl:text>&#160;</xsl:text>
                </b>
            </xsl:otherwise>
        </xsl:choose>
        <br/>
    </xsl:template>
    <xsl:template match="cs:result/cs:current/cs:schema/cs:data | cs:result/cs:master/cs:schema/cs:data">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="cs:result/cs:current/cs:validate | cs:result/cs:master/cs:validate">
        <b>Ruleset Check</b>
        <xsl:text> - </xsl:text>
        <xsl:choose>
            <xsl:when test="@status='fine'">
                <b>
                    <span class="fine">fine</span>
                </b>
            </xsl:when>
            <xsl:otherwise>
                <b>
                    <span class="warning">failed</span>
                </b>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#160;</xsl:text>
        <span id="current-check{../name()}_less">
            <a href="javascript:ShowDetails('current-check{../name()}');">Details anzeigen</a>
        </span>
        <span id="current-check{../name()}_more" style="display:none">
            <a href="javascript:HideDetails('current-check{../name()}');">Details ausblenden</a>
            <br/>
            <div class="error diff changed">
                <a style="text-decoration: none; width:100%" href="#diff_0">Error</a>
            </div>
            <br/>
            <xsl:apply-templates select="cs:data" mode="style"/>
        </span>
        <br/>
    </xsl:template>
    <xsl:template match="cs:result/cs:current/cs:validate/cs:data | cs:result/cs:master/cs:validate/cs:data"/>
    <xsl:template match="cs:result/cs:current/cs:compare | cs:result/cs:master/cs:compare">
        <b>Result Compare</b>
        <xsl:text> - </xsl:text>
        <xsl:apply-templates select="cs:data" mode="report"/>
    </xsl:template>
    <xsl:template match="cs:result/cs:current/cs:compare/cs:data | cs:result/cs:master/cs:compare/cs:data"/>
    <xsl:template match="cs:result/cs:current/cs:compare/cs:data | cs:result/cs:master/cs:compare/cs:data" mode="report">
        <xsl:choose>
            <xsl:when test=".//@diff:*[local-name()!='moved'] or .//diff:* or er:error">
                <span class="error">
                    <b>
                        <span class="warning">failed</span>
                    </b>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <b>
                    <span class="fine">fine</span>
                </b>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#160;</xsl:text>
        <span id="{../../name()}-compare_less">
            <a href="javascript:ShowDetails('{../../name()}-compare');">Details anzeigen</a>
        </span>
        <xsl:variable name="Warnings" select="count(.//@diff:moved)"/>
        <span id="{../../name()}-compare_more" style="display:none">
            <a href="javascript:HideDetails('{../../name()}-compare');">Details ausblenden</a>
            <br/>
            <div class="error diff changed">
                <a style="text-decoration:none;color:black;" href="#diff_0">
                    <xsl:text>Changed or new values</xsl:text>
                </a>
            </div>
            <div class="warning diff moved" style="color:black">
                <a style="text-decoration:none;color:black;" href="#moved_0">
                    <xsl:text>Only the position moved</xsl:text>
                </a>
            </div>
            <xsl:apply-templates mode="style"/>
            <hr/>
        </span>
        <span>&#160;</span>
        <span>
            <xsl:text>(</xsl:text>
            <div class="warning inline">
                <xsl:value-of select="$Warnings"/>
                <xsl:text> moved</xsl:text>
            </div>
            <xsl:text>, </xsl:text>
            <div class="error inline">
                <xsl:value-of select="count(.//@diff:* | .//diff:*) - $Warnings"/>
                <xsl:text> changed</xsl:text>
            </div>
            <xsl:text>)</xsl:text>
        </span>
        <br/>
    </xsl:template>
    <xsl:template match="c:errors">
        <xsl:text>Error Details: </xsl:text>
        <br/>
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="c:error">
        <li>
            <xsl:for-each select="@*">
                <xsl:text>&#160;&#160;</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>=</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>&#160;&#160;</xsl:text>
            </xsl:for-each>
            <xsl:value-of select="."/>
        </li>
    </xsl:template>
    <xsl:template match="er:critical" mode="style">
        <span class="diff note">
            <xsl:value-of select="text()"/>
        </span>
        <br/>
    </xsl:template>
    <xsl:template match="er:error" mode="style">
        <span class="diff critical">
            <xsl:value-of select="text()"/>
        </span>
        <br/>
    </xsl:template>
    <xsl:template match="er:warning" mode="style">
        <span class="diff warning">
            <xsl:value-of select="text()"/>
        </span>
        <br/>
    </xsl:template>
    <xsl:template match="er:info" mode="style">
        <span class="diff info">
            <xsl:value-of select="text()"/>
        </span>
        <br/>
    </xsl:template>
    <!-- <xsl:template match="diff:changed[string-length(../text())>0]" mode="style" priority="1"/> -->
    <xsl:template match="diff:changed" mode="style" priority="0">
        <!--
        <span class="note">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="replace(., '^\s*(.+?)\s*$', '$1')"/>
            <xsl:text>]</xsl:text>
        </span>
    -->
    </xsl:template>
    <xsl:template match="diff:removed" mode="style" priority="0">
        <span class="note">
            <xsl:text>[]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="@diff:added[.='element']" mode="style">
        <span class="diff note">
            <xsl:text>[new]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="@diff:changed[.='text']" mode="style">
        <!-- nothing to do -->
    </xsl:template>
    <xsl:template match="@diff:changed" mode="style">
        <span class="diff warning">
            <xsl:text>&#160;</xsl:text>
            <span class="attribute">
                <xsl:value-of select="name()"/>
            </span>
            <span class="tag2">="</span>
            <xsl:value-of select="."/>
            <span class="tag2">"</span>
            <xsl:text>[Changed='</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>']</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="@diff:moved" mode="style">
        <span class="diff note">
            <xsl:text>[moved: </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="@diff:*" mode="style">
        <xsl:choose>
            <xsl:when test="starts-with(.,'changed: ')">
                <xsl:text>&#160;</xsl:text>
                <span class="attribute">
                    <xsl:value-of select="local-name()"/>
                </span>
                <span class="tag2">="</span>
                <span class="warning">
                    <xsl:variable name="Name" select="local-name()"/>
                    <xsl:value-of select="../@*[name()=$Name]"/>
                </span>
                <span class="note">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="substring-after(., 'changed: ')"/>
                    <xsl:text>]</xsl:text>
                </span>
                <span class="tag2">"</span>
            </xsl:when>
            <xsl:otherwise>
                <span class="warning">
                    <xsl:text>&#160;</xsl:text>
                    <span class="attribute">
                        <xsl:value-of select="local-name()"/>
                    </span>
                    <span class="tag2">="</span>
                    <xsl:value-of select="."/>
                    <span class="tag2">"</span>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@*" priority="-1" mode="style">
        <xsl:param name="row" select="1"/>
        <xsl:if test="not(../@diff:*[local-name()=local-name(current())])">
<!--
            <br/>
            <xsl:for-each select="1 to $row">
                <xsl:text>   </xsl:text>
            </xsl:for-each>            
-->
            <xsl:text>&#160;</xsl:text>
            <span class="attribute">
                <xsl:value-of select="name()"/>
            </span>
            <span class="tag2">="</span>
            <xsl:value-of select="."/>
            <span class="tag2">"</span>
        </xsl:if>
    </xsl:template>
    <xsl:template match="*" priority="-1" mode="style">
        <xsl:param name="row" select="0"/>
        <xsl:param name="new" select="false()"/>
        <xsl:choose>
            <xsl:when test="@diff:*[local-name()!='moved'] | diff:* | er:*">
                <xsl:variable name="defects" select="count(preceding::*[@diff:* | diff:* | er:*]) + count(ancestor::*[@diff:* | diff:* | er:*]) - count(preceding::*[@diff:moved]) - count(ancestor::*[@diff:moved]) -2"/>
                <a style="text-decoration: none;" id="diff_{$defects}" name="diff_{$defects}" href="#diff_{$defects+1}">
                    <div style="width:{1*15}px" class="diff changed inline">&#160;</div>
                </a>
            </xsl:when>
            <xsl:when test="@diff:moved">
                <xsl:variable name="defects" select="count(preceding::*[@diff:moved]) + count(ancestor::*[@diff:moved])"/>
                <a style="text-decoration: none;" id="moved_{$defects}" name="moved{$defects}" href="#moved_{$defects+1}">
                    <div style="width:{1*15}px" class="diff moved inline">&#160;</div>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <div class="inline" style="width:{1*15}px">&#160;</div>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="node()">
                <div class="inline" style="width:{$row *10}px">&#160;</div>
                <xsl:choose>
                    <xsl:when test="$new or @diff:added">
                        <span class="warning">
                            <span class="tag">&lt;</span>
                            <span class="element">
                                <xsl:value-of select="name()"/>
                            </span>
                            <xsl:apply-templates select="@*" mode="style">
                                <xsl:with-param name="row" select="$row +1"/>
                                <xsl:with-param name="new" select="true()"/>
                            </xsl:apply-templates>
                            <span class="tag">&gt;</span>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="tag">&lt;</span>
                        <span class="element">
                            <xsl:value-of select="name()"/>
                        </span>
                        <xsl:apply-templates select="@*" mode="style">
                            <xsl:with-param name="row" select="$row +1"/>
                            <xsl:with-param name="new" select="false()"/>
                        </xsl:apply-templates>
                        <span class="tag">&gt;</span>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="*[not(local-name()='changed' and namespace-uri()='http://compare.intersecurity.net/diff/')]">
                        <br class="node"/>
                        <xsl:apply-templates mode="style">
                            <xsl:with-param name="row" select="$row +1"/>
                            <xsl:with-param name="new" select="$new or @diff:added"/>
                        </xsl:apply-templates>
                        <div class="inline" style="width:{1*15}px">&#160;</div>
                        <div class="inline" style="width:{$row *10}px">&#160;</div>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="style">
                            <xsl:with-param name="row" select="$row +1"/>
                            <xsl:with-param name="new" select="$new or @diff:added"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="$new or @diff:added">
                        <span class="warning">
                            <span class="tag">&lt;/</span>
                            <span class="element">
                                <xsl:value-of select="name()"/>
                            </span>
                            <span class="tag">&gt;</span>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="tag">&lt;/</span>
                        <span class="element">
                            <xsl:value-of select="name()"/>
                        </span>
                        <span class="tag">&gt;</span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <div class="inline" style="width:{$row *10}px">&#160;</div>
                <xsl:choose>
                    <xsl:when test="$new or @diff:added">
                        <span class="warning">
                            <span class="tag">&lt;</span>
                            <span class="element">
                                <xsl:value-of select="name()"/>
                            </span>
                            <xsl:apply-templates select="@*" mode="style">
                                <xsl:with-param name="row" select="$row +1"/>
                                <xsl:with-param name="new" select="true()"/>
                            </xsl:apply-templates>
                            <span class="tag">/&gt;</span>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="tag">&lt;</span>
                        <span class="element">
                            <xsl:value-of select="name()"/>
                        </span>
                        <xsl:apply-templates select="@*" mode="style">
                            <xsl:with-param name="row" select="$row +1"/>
                            <xsl:with-param name="new" select="false()"/>
                        </xsl:apply-templates>
                        <span class="tag">/&gt;</span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <br/>
    </xsl:template>
    <xsl:template match="text()" priority="-1" mode="style">
        <xsl:if test="preceding-sibling::* or following-sibling::*">
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::*)=0 and count(following-sibling::*[namespace-uri()!='http://compare.intersecurity.net/diff/'])=0">
                    <!-- nothing to do as inline -->
                </xsl:when>
                <xsl:when test="(following-sibling::diff:changed)[1] or (following-sibling::diff:removed)[1]">
                    <xsl:variable name="defects" select="count(preceding::*[@diff:moved]) + count(ancestor::*[@diff:moved])"/>
                    <a style="text-decoration: none;" id="changed_{$defects}" name="changed{$defects}" href="#changed_{$defects+1}">
                        <div style="width:{1*15}px" class="diff changed inline">&#160;</div>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <div class="inline" style="width:{1*15}px">&#160;</div>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="(following-sibling::diff:changed)[1] or (following-sibling::diff:removed)[1]">
                <span class="warning">
                    <xsl:value-of select="replace(.,' ','&#160;')"/>
                </span>
                <xsl:text> </xsl:text>
                <span class="note">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="replace((following-sibling::diff:changed)[1],' ','&#160;')"/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="../@diff:changed[.='text']">
                <span class="warning">
                    <xsl:value-of select="."/>
                </span>
                <span class="note">
                    <xsl:text>[changed]</xsl:text>
                </span>
            </xsl:when>
            <xsl:when test="ancestor-or-self::*/@diff:added[.='element']">
                <span class="warning">
                    <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="preceding-sibling::* or following-sibling::*">
            <br/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="node()|@*" priority="-2" mode="style">
        <xsl:param name="row" select="0"/>
        <xsl:param name="new" select="false()"/>
        <xsl:apply-templates select="node()|@*" mode="style">
            <xsl:with-param name="row" select="$row"/>
            <xsl:with-param name="new" select="$new"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="node()|@*" priority="-1">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>