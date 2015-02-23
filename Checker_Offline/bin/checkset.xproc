<!-- 
========================================================================
LICENSE AGREEMENT:
This software is distributed WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
========================================================================
This copy of the Compare Tool is licensed under the
Lesser General Public License (LGPL), version 3 ("the License").

See the License for details about distribution rights, 
modification and transformation of it.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
========================================================================
Copyright:
(c) 2010-2014 by InterSecurity GmbH &amp; Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
-->
<p:declare-step name="checkset" version="1.0" 
    xmlns:bc="http://checker.bintellix.de/" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:cs="http://checker.bintellix.de/checkset/"
    xmlns:err="http://www.w3.org/ns/xproc-error"
    xmlns:p="http://www.w3.org/ns/xproc">
    <p:input port="parameters" kind="parameter"/>
    <p:output port="result"/>
    
    <p:option name="group" select="''"/>
    <p:option name="step" select="''"/>
    <p:option name="filename" select="''"/>
    <p:option name="logdir" select="'../work/'"/>
    <p:option name="debug" required="false" select="1"/>
    <p:option name="format" select="'xml'"/>
    <p:option name="root" select="'http://localhost:8080/exist/apps/bintellix/compare/'"/>
    
    <p:option name="current_ws" select="''"/>
    <p:option name="master_ws" select="''"/>
    <p:option name="market_configurator" select="''"/>
    <p:option name="domain" select="''"/>
    <p:option name="market" select="''"/>
    <p:option name="brand" select="''"/>
    <p:option name="senderid" select="''"/>
    
    <p:option name="MasterDisabled" select="'no'"/>
    <p:option name="MasterValidateDisabled" select="'no'"/>
    <p:option name="MasterCheckDisabled" select="'no'"/>
    <p:option name="MasterCompareDisabled" select="'no'"/>
    
    <p:serialization media-type="application/xml" method="xml" port="result"/>
    
    <p:import href="checkset_document.xproc"/>
    <p:import href="checkset_cleanup.xproc"/>
    <p:import href="checkset_check.xproc"/>
    <p:import href="checkset_validate.xproc"/>
    <p:import href="checkset_compare.xproc"/>

    <p:in-scope-names name="vars"/>   
 
    
    <p:documentation>Load Step of type Checkset</p:documentation>
    <p:choose name="ChecksetLoad">
        <p:xpath-context>
            <p:pipe port="parameters" step="checkset"/>
        </p:xpath-context>

        <p:when test="string-length($filename) &gt; 0">
            <p:output port="result" primary="true"/>
            <p:load name="Checkset1">
                <p:with-option name="href" select="$filename"/>
            </p:load>
        </p:when>
        <p:when test="string-length($group) &gt; 0 and string-length($step) &gt; 0">
            <p:output port="result" primary="true"/>
            <p:load name="Checkset2">
                <p:with-option name="href" select="concat($root, $group,'/step/',$step,'/step_',$step, '.xml')"/>
            </p:load>
        </p:when>
        <p:otherwise>
            <p:output port="result" primary="true"/>
            <p:identity>
                <p:input port="source">
                    <p:inline>
                        <error>Error: Either a 'filename' or ('group' and 'step') have to be given as parameter.</error>        
                    </p:inline>                
                </p:input>
            </p:identity>
        </p:otherwise>
    </p:choose>
    
    <p:xslt name="Checkset">
        <p:with-param name="market_configurator" select="$market_configurator"/>
        <p:with-param name="current_ws" select="$current_ws"/>
        <p:with-param name="master_ws" select="$master_ws"/>
        <p:with-param name="domain" select="$domain"/>
        <p:with-param name="market" select="$market"/>
        <p:with-param name="brand" select="$brand"/>
        <p:with-param name="senderid" select="$senderid"/>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                    <xsl:param name="market_configurator" select="''"/>
                    <xsl:param name="current_ws" select="''"/>
                    <xsl:param name="master_ws" select="''"/>
                    <xsl:param name="domain" select="''"/>
                    <xsl:param name="market" select="''"/>
                    <xsl:param name="brand" select="''"/>
                    <xsl:param name="senderid" select="''"/>
                    
                    <xsl:template match="/">
                        <xsl:apply-templates/>
                    </xsl:template>
                    
                    <xsl:template match="text()">
                        <xsl:value-of select="replace(replace(replace(replace(replace(replace(replace(replace(replace(.,'\{\$domain\}',$domain),'\{\$market_configurator\}',$market_configurator),'\{\$current_ws\}',$current_ws),'\{\$master_ws\}',$master_ws),'\{\$market\}',lower-case($market)),'\{\$MARKET\}',upper-case($market)),'\{\$brand\}',lower-case($brand)),'\{\$BRAND\}',upper-case($brand)),'\{\$senderid\}',$senderid)"/>    
                    </xsl:template>
                    
                    <xsl:template match="node()|@*" priority="-1">
                        <xsl:copy>
                            <xsl:apply-templates select="node()|@*"/>
                        </xsl:copy>
                    </xsl:template>
                </xsl:stylesheet>                
            </p:inline>
        </p:input>
    </p:xslt>     
    
    <p:choose>
        <p:when test="$debug != 0">
            <p:store>
                <p:with-option name="href" select="concat($logdir, 'checkset.xml')"/>
            </p:store>
        </p:when>
        <p:otherwise>
            <p:sink name="discarding-debugging-output"/>
        </p:otherwise>
    </p:choose>

    <p:documentation>Create Result Document</p:documentation>
    <p:xslt name="ResultBase">
        <p:with-param name="group" select="$market_configurator"/>
        <p:with-param name="step" select="$current_ws"/>
        <p:with-param name="filename" select="$filename"/>
        <p:with-param name="MasterDisabled" select="$MasterDisabled"/>
        <p:with-param name="MasterValidateDisabled" select="$MasterValidateDisabled"/>
        <p:with-param name="MasterCompareDisabled" select="$MasterCompareDisabled"/>
        
        <p:input port="source">
            <p:pipe port="result" step="Checkset"/>
        </p:input>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                    <xsl:param name="group" required="yes"/>
                    <xsl:param name="step" select="''"/>
                    <xsl:param name="filename" select="''"/>
                    <xsl:param name="MasterDisabled" required="yes"/>
                    <xsl:param name="MasterValidateDisabled" required="yes"/>
                    <xsl:param name="MasterCompareDisabled" required="yes"/>
                    <xsl:template match="/">
                        <cs:run timestamp="{current-dateTime()}" xmlns:cs="http://checker.bintellix.de/checkset/">
                            <xsl:copy-of select="/cs:step/cs:identity"/>
                            <cs:result>
                                <cs:current>
                                    <cs:document>
                                        <cs:data/>
                                    </cs:document>
                                    <cs:schema status="error">
                                        <cs:data/>
                                    </cs:schema>
                                    <cs:cleanup status="fine">
                                        <cs:data/>
                                    </cs:cleanup>                                
                                    <cs:validate status="error">
                                        <cs:data/>
                                    </cs:validate>
                                    <xsl:choose>
                                        <xsl:when test="$MasterDisabled='yes'">
                                            <cs:compare status="disabled">
                                                <cs:data/>
                                            </cs:compare>                                           
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <cs:compare status="error">
                                                <cs:data/>
                                            </cs:compare>                                            
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </cs:current>
                                <cs:master>
                                    <cs:document>
                                        <cs:data/>
                                    </cs:document>
                                    <xsl:choose>
                                        <xsl:when test="$MasterDisabled='yes'">
                                            <cs:schema status="disabled">
                                                <cs:data/>
                                            </cs:schema>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <cs:schema status="error">
                                                <cs:data/>
                                            </cs:schema>
                                        </xsl:otherwise>
                                    </xsl:choose>                                
                                    <cs:cleanup status="fine">
                                        <cs:data/>
                                    </cs:cleanup>
                                    <xsl:choose>
                                        <xsl:when test="$MasterDisabled='yes' or $MasterValidateDisabled='yes'">
                                            <cs:validate status="disabled">
                                                <cs:data/>
                                            </cs:validate>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <cs:validate status="error">
                                                <cs:data/>
                                            </cs:validate>
                                        </xsl:otherwise>
                                    </xsl:choose>                                
                                    <xsl:choose>
                                        <xsl:when test="$MasterDisabled='yes' or $MasterCompareDisabled='yes'">
                                            <cs:compare status="disabled">
                                                <cs:data/>
                                            </cs:compare>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <cs:compare status="error">
                                                <cs:data/>
                                            </cs:compare>
                                        </xsl:otherwise>
                                    </xsl:choose>                                
                                </cs:master>                                
                            </cs:result>
                        </cs:run>
                    </xsl:template>    
                    <xsl:template match="node()|@*" priority="-1"/>
                </xsl:stylesheet>                
            </p:inline>
        </p:input>
    </p:xslt>
    
    <!-- Current Document -->
    <p:documentation>Load Current Document</p:documentation>
    <bc:doc name="Current_Document">
        <p:input port="source">
            <p:pipe port="result" step="Checkset"/>
        </p:input>
        <p:with-option name="type" select="'current'"/>
        <p:with-option name="debug" select="$debug"/>
    </bc:doc>
    <p:wrap match="/" name="XCurrent_Document" wrapper="cs:data"/>
        
    <p:replace match="/cs:run/cs:result/cs:current/cs:document/cs:data" name="Result1">
        <p:input port="source">
            <p:pipe port="result" step="ResultBase"/>
        </p:input>
        <p:input port="replacement">
            <p:pipe port="result" step="XCurrent_Document"/>
        </p:input>
    </p:replace>
    
    <!-- Cleanup Document -->
    <p:documentation>Cleanup Current Document</p:documentation>
    <bc:cleanup name="Current_Cleanup">
        <p:input port="checkset">
            <p:pipe port="result" step="Checkset"/>
        </p:input>
        <p:input port="document">
            <p:pipe port="result" step="Current_Document"/>
        </p:input>
        <p:with-option name="type" select="'current'"/>
        <p:with-option name="debug" select="$debug"/>
    </bc:cleanup>
 
    <!-- Validate Document -->
    <p:documentation>Check Current Document</p:documentation>
    <bc:check name="Current_Check">
        <p:input port="checkset">
            <p:pipe port="result" step="Checkset"/>
        </p:input>
        <p:input port="document">
            <p:pipe port="result" step="Current_Cleanup"/>
        </p:input>
        <p:with-option name="type" select="'current'"/>
        <p:with-option name="debug" select="$debug"/>
    </bc:check>
    <p:wrap match="/" name="XCurrent_Check" wrapper="cs:data"/>

    <p:replace match="/cs:run/cs:result/cs:current/cs:validate/cs:data" name="Result2">
        <p:input port="source">
            <p:pipe port="result" step="Result1"/>
        </p:input>
        <p:input port="replacement">
            <p:pipe port="result" step="XCurrent_Check"/>
        </p:input>
    </p:replace>
    
    
    <p:documentation>Schema check Current Document</p:documentation>
    <p:choose name="Current_Validate_1">
        <p:xpath-context>
            <p:pipe port="result" step="Checkset"/>
        </p:xpath-context>
        <p:when
            test="/cs:step/cs:checkset/cs:current/cs:document/cs:validate/cs:schema/@active='true'">
            <bc:validate>
                <p:input port="source">
                    <p:pipe port="result" step="Current_Document"/>
                </p:input>
                <p:with-option name="type" select="'current'"/>
                <p:with-option name="debug" select="$debug"/>
                <p:with-option name="url"
                    select="/cs:step/cs:checkset/cs:current/cs:document/cs:validate/cs:schema/cs:url/text()">
                    <p:pipe port="result" step="Checkset"/>
                </p:with-option>
            </bc:validate>
        </p:when>
        <p:otherwise>
            <p:identity>
                <p:input port="source">
                    <p:inline>
                        <validate>
                            <cs:info>No validation requested.</cs:info>
                        </validate>
                    </p:inline>
                </p:input>
            </p:identity>
        </p:otherwise>
    </p:choose>   
    <p:wrap match="/" name="XCurrent_Validate" wrapper="cs:data"/>
    
    <p:replace match="/cs:run/cs:result/cs:current/cs:schema/cs:data" name="Result3">
        <p:input port="source">
            <p:pipe port="result" step="Result2"/>
        </p:input>
        <p:input port="replacement">
            <p:pipe port="result" step="XCurrent_Validate"/>
        </p:input>
    </p:replace>
    
    
    <p:choose name="ResultFinal">
        <p:when test="$MasterDisabled='yes'">
            <p:identity/>
        </p:when>
        <p:otherwise>
            <p:documentation>Load Master Document</p:documentation>
            <bc:doc name="Master_Document">
                <p:input port="source">
                    <p:pipe port="result" step="Checkset"/>
                </p:input>
                <p:with-option name="type" select="'master'"/>
                <p:with-option name="debug" select="$debug"/>
            </bc:doc>
            <p:wrap match="/" name="XMaster_Document" wrapper="cs:data"/>
            
            <p:replace match="/cs:run/cs:result/cs:master/cs:document/cs:data" name="Result4">
                <p:input port="source">
                    <p:pipe port="result" step="Result3"/>
                </p:input>
                <p:input port="replacement">
                    <p:pipe port="result" step="XMaster_Document"/>
                </p:input>
            </p:replace>
            
            <p:documentation>Cleanup Master Document</p:documentation>
            <bc:cleanup name="Master_Cleanup">
                <p:input port="checkset">
                    <p:pipe port="result" step="Checkset"/>
                </p:input>
                <p:input port="document">
                    <p:pipe port="result" step="Master_Document"/>
                </p:input>
                <p:with-option name="type" select="'master'"/>
                <p:with-option name="debug" select="$debug"/>
            </bc:cleanup>
            
            <p:documentation>Check Master Document</p:documentation>
            <bc:check name="Master_Check">
                <p:input port="checkset">
                    <p:pipe port="result" step="Checkset"/>
                </p:input>
                <p:input port="document">
                    <p:pipe port="result" step="Master_Cleanup"/>
                </p:input>
                <p:with-option name="type" select="'master'"/>
                <p:with-option name="debug" select="$debug"/>
            </bc:check>
            <p:wrap match="/" name="XMaster_Check" wrapper="cs:data"/>
            
            <p:replace match="/cs:run/cs:result/cs:master/cs:validate/cs:data" name="Result5">
                <p:input port="source">
                    <p:pipe port="result" step="Result4"/>
                </p:input>
                <p:input port="replacement">
                    <p:pipe port="result" step="XMaster_Check"/>
                </p:input>
            </p:replace>
            
            <p:documentation>Validate Master Document</p:documentation>
            <p:choose name="Master_Validate">
                <p:xpath-context>
                    <p:pipe port="result" step="Checkset"/>
                </p:xpath-context>
                <p:when
                    test="/cs:step/cs:checkset/cs:master/cs:document/cs:validate/cs:schema/@active='true'">
                    <bc:validate>
                        <p:input port="source">
                            <p:pipe port="result" step="Master_Document"/>
                        </p:input>
                        <p:with-option name="type" select="'master'"/>
                        <p:with-option name="debug" select="$debug"/>
                        <p:with-option name="url"
                            select="/cs:step/cs:checkset/cs:master/cs:document/cs:validate/cs:schema/cs:url/text()">
                            <p:pipe port="result" step="Checkset"/>
                        </p:with-option>
                    </bc:validate>
                </p:when>
                <p:otherwise>
                    <p:identity>
                        <p:input port="source">
                            <p:inline>
                                <validate>
                                    <info>No validation requested.</info>
                                </validate>
                            </p:inline>
                        </p:input>
                    </p:identity>
                </p:otherwise>
            </p:choose>
            <p:wrap match="/" name="XMaster_Validate" wrapper="cs:data"/>
            
            <p:replace match="/cs:run/cs:result/cs:master/cs:schema/cs:data" name="Result6">
                <p:input port="source">
                    <p:pipe port="result" step="Result5"/>
                </p:input>
                <p:input port="replacement">
                    <p:pipe port="result" step="XMaster_Validate"/>
                </p:input>
            </p:replace>
            
            
            <p:documentation>Compare Current and Master Document</p:documentation>
            <bc:compare name="Compare">
                <p:input port="checkset">
                    <p:pipe port="result" step="Checkset"/>
                </p:input>
                <p:input port="current">
                    <p:pipe port="result" step="Current_Cleanup"/>
                </p:input>
                <p:input port="master">
                    <p:pipe port="result" step="Master_Cleanup"/>
                </p:input>
                <p:with-option name="debug" select="$debug"/>
            </bc:compare>
            
            <p:wrap match="/" name="XCurrent_Compare" wrapper="cs:data">
                <p:input port="source" select="/result/current/*">
                    <p:pipe port="result" step="Compare"/>
                </p:input>
            </p:wrap>
            
            <p:wrap match="/" name="XMaster_Compare" wrapper="cs:data">
                <p:input port="source" select="/result/master/*">
                    <p:pipe port="result" step="Compare"/>
                </p:input>
            </p:wrap>
            
            <p:replace match="/cs:run/cs:result/cs:current/cs:compare/cs:data" name="Result7">
                <p:input port="source">
                    <p:pipe port="result" step="Result6"/>
                </p:input>
                <p:input port="replacement">
                    <p:pipe port="result" step="XCurrent_Compare"/>
                </p:input>
            </p:replace>
            
            <p:replace match="/cs:run/cs:result/cs:master/cs:compare/cs:data" name="Result8">
                <p:input port="source">
                    <p:pipe port="result" step="Result7"/>
                </p:input>
                <p:input port="replacement">
                    <p:pipe port="result" step="XMaster_Compare"/>
                </p:input>
            </p:replace>
        </p:otherwise>
    </p:choose>

    <p:xslt name="error_report">
        <p:with-param name="MasterValidateDisabled" select="$MasterValidateDisabled"/>
        <p:with-param name="MasterCheckDisabled" select="$MasterCheckDisabled"/>
        <p:with-param name="MasterCompareDisabled" select="$MasterCompareDisabled"/>
        
        <p:input port="stylesheet">
            <p:document  href="checkset_result_status.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

<!--       
    <p:choose>
        <p:when test="$debug != 0">
            <p:store>
                <p:with-option name="href" select="'../work/checkset_result.xml'"/>
            </p:store>
        </p:when>
        <p:otherwise>
            <p:sink name="discarding-debugging-output"/>
        </p:otherwise>
    </p:choose>
 
    <p:documentation>Create Error Report</p:documentation>
    <p:choose>
        <p:when test="$format='report'">
            <p:xslt name="error_report">
                <p:with-param name="MasterValidateDisabled" select="$MasterValidateDisabled"/>
                <p:with-param name="MasterCheckDisabled" select="$MasterCheckDisabled"/>
                <p:with-param name="MasterCompareDisabled" select="$MasterCompareDisabled"/>

                <p:input port="source">
                    <p:pipe port="result" step="Result"/>
                </p:input>
                <p:input port="stylesheet">
                    <p:document
                        href="checkset_error_report.xsl"
                    />
                </p:input>
                <p:input port="parameters">
                    <p:empty/>
                </p:input>
            </p:xslt>
        </p:when>
        <p:when test="$format='status'">
            <p:xslt name="error_report">
                <p:with-param name="MasterValidateDisabled" select="$MasterValidateDisabled"/>
                <p:with-param name="MasterCheckDisabled" select="$MasterCheckDisabled"/>
                <p:with-param name="MasterCompareDisabled" select="$MasterCompareDisabled"/>
                
                <p:input port="source">
                    <p:pipe port="result" step="Result"/>
                </p:input>
                <p:input port="stylesheet">
                    <p:document
                        href="checkset_error_status.xsl"
                    />
                </p:input>
                <p:input port="parameters">
                    <p:empty/>
                </p:input>
            </p:xslt>
            <p:choose>
                <p:when test="//status[text()!='fine']">
                    <p:xpath-context>
                        <p:pipe step="error_report" port="result"/>
                    </p:xpath-context>

                    <p:error xmlns:my="http://www.example.org/error"
                        name="bad-document" code="unk12">
                        <p:input port="source">
                            <p:inline>
                                <message>Checkset failed</message>
                            </p:inline>
                        </p:input>
                    </p:error>                    
                </p:when>
                <p:otherwise>
                    <p:identity/>
                </p:otherwise>
            </p:choose>
        </p:when>
        <p:otherwise>
            <p:identity>
                <p:input port="source">
                    <p:pipe port="result" step="Result"/>
                </p:input>                    
            </p:identity>
        </p:otherwise>
    </p:choose>
-->    
</p:declare-step>
