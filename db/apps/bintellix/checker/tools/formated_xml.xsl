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
--><xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0"><xsl:output method="xhtml" omit-xml-declaration="no" indent="no"/><xsl:strip-space elements="*"/><xsl:template match="/"><html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"/><style type="text/css">
                    html {
                        padding:0;
                        margin:0;
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
                    span.processing-instruction {
                        color: #909;
                    }
                    
                    span.REMOVE,
                    span.REMOVE span {
                        color: #ccc !important;
                    }
                    span.REPLACE,
                    span.REPLACE span {
                    color: #930;
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
                </style></head><body><div><xsl:variable name="change-list"><cs:changes><cs:change xpath="/cs:step/cs:identity/cs:step-id" type="REMOVE" value="Text1" note="not neeeded"/><cs:change xpath="/cs:step/cs:identity/cs:step-group/text()" type="REPLACE" value="NewText" note="Updated Text"/><cs:change xpath="/cs:step/cs:identity/cs:step-order[1]" type="REPLACE" value="&lt;NewElement&gt;" note="My description"/><cs:change xpath="/cs:step/cs:run/@timestamp" type="REPLACE" value="" note="attribute"/></cs:changes></xsl:variable><xsl:apply-templates><xsl:with-param name="change-list" select="$change-list"/></xsl:apply-templates></div></body></html></xsl:template><xsl:template match="processing-instruction()"><span class="processing-instruction"><xsl:text>&lt;?</xsl:text><xsl:value-of select="."/><xsl:text>?&lt;</xsl:text></span></xsl:template><xsl:template match="*" priority="-1"><xsl:param name="column" select="0"/><xsl:param name="type" select="''"/><xsl:param name="parent" select="''"/><xsl:param name="change-list"/><xsl:variable name="name" select="name()"/><xsl:variable name="path" select="concat($parent,'/',name(),if (position() != 1 and preceding-sibling::*[name()=$name]) then concat('[',count(preceding-sibling::*[name()=$name]),']') else '')"/>
        
        <!-- debug:
        [<xsl:value-of select="$path"/>        
        <xsl:if test="$change-list/cs:changes/cs:change/@xpath=$path">
            Treffer
        </xsl:if>
        <xsl:value-of select="$change-list/cs:changes/cs:change[1]/@xpath = $path"/>
        ]
        --><xsl:variable name="mode" select="$change-list/cs:changes/cs:change[@xpath=$path]/@type/data()"/><xsl:choose><xsl:when test="$mode='normal'"><div class="inline" style="width:{1*15}px">&#160;</div></xsl:when><xsl:when test="$mode=('REPLACE','REMOVE')"><xsl:variable name="defects" select="1"/><a style="text-decoration: none;" id="diff_{$defects}" name="diff_{$defects}" href="#diff_{$defects+1}"><div style="width:{1*15}px" class="diff changed inline">&#160;</div></a></xsl:when><xsl:when test="$mode='ORDER'"><xsl:variable name="defects" select="1"/><a style="text-decoration: none;" id="moved_{$defects}" name="moved{$defects}" href="#moved_{$defects+1}"><div style="width:{1*15}px" class="diff moved inline">&#160;</div></a></xsl:when><xsl:otherwise>
                <!-- no prefix --></xsl:otherwise></xsl:choose><xsl:if test="$column != 0"><div class="inline" style="width:{$column *10}px">&#160;</div></xsl:if><span class="{$mode}"><span class="tag">&lt;</span><span class="element"><xsl:value-of select="name()"/></span><xsl:apply-templates select="@*"><xsl:with-param name="parent" select="$path"/><xsl:with-param name="change-list" select="$change-list"/></xsl:apply-templates><xsl:choose>
                <!-- subnodes --><xsl:when test="*"><span class="tag">&gt;</span><br/><xsl:apply-templates><xsl:with-param name="column" select="$column +1"/><xsl:with-param name="type" select="$type"/><xsl:with-param name="parent" select="$path"/><xsl:with-param name="change-list" select="$change-list"/></xsl:apply-templates><xsl:if test="$mode=('normal','REPLACE','REMOVE')"><div class="inline" style="width:{1*15}px">&#160;</div></xsl:if><xsl:if test="$column != 0"><div class="inline" style="width:{$column *10}px">&#160;</div></xsl:if><span class="tag">&lt;/</span><span class="element"><xsl:value-of select="name()"/></span><span class="tag">&gt;</span></xsl:when>
                <!-- text only --><xsl:when test="text()"><span class="tag">&gt;</span><xsl:apply-templates select="text()"><xsl:with-param name="parent" select="$path"/><xsl:with-param name="change-list" select="$change-list"/></xsl:apply-templates><span class="tag">&lt;/</span><span class="element"><xsl:value-of select="name()"/></span><span class="tag">&gt;</span></xsl:when>
                <!-- single closing --><xsl:otherwise><span class="tag">/&gt;</span></xsl:otherwise></xsl:choose></span><br/></xsl:template><xsl:template match="@*"><xsl:param name="parent" required="yes"/><xsl:param name="change-list" required="yes"/><xsl:variable name="path" select="concat($parent,'/@',name())"/><xsl:variable name="mode" select="$change-list/cs:changes/cs:change[@xpath=$path]/@type"/><span class="{$mode}"><xsl:text>&#160;&#160;</xsl:text><xsl:value-of select="name()"/><xsl:text>="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text></span></xsl:template><xsl:template match="text()" priority="-1"><xsl:param name="parent" required="yes"/><xsl:param name="change-list" required="yes"/><xsl:variable name="path" select="concat($parent,'/text()')"/><xsl:variable name="mode" select="$change-list/cs:changes/cs:change[@xpath=$path]/@type"/>
        <!-- debug: [<xsl:value-of select="$path"/>,<xsl:value-of select="$mode"/>] --><span class="{$mode}"><xsl:value-of select="."/></span></xsl:template>
    <!--
    <xsl:template match="node()|@*" priority="-2">
        <xsl:param name="parent" select="''"/>
        <xsl:param name="change-list"/>
        <xsl:apply-templates select="node()|@*">
            <xsl:with-param name="parent" select="$parent"/>
            <xsl:with-param name="change-list" select="$change-list"/>
        </xsl:apply-templates>
    </xsl:template>
    -->
    <!--
    <xsl:template match="node()|@*" priority="-1">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>
    --></xsl:stylesheet>