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
    
    <p:option name="filename" select="''"/>
    <p:option name="logdir" select="'../work/'"/>
    <p:option name="debug" required="false" select="1"/>
    <p:option name="format" select="'report'"/>

    
    <p:option name="MasterDisabled" select="'no'"/>
    <p:option name="MasterValidateDisabled" select="'no'"/>
    <p:option name="MasterCheckDisabled" select="'no'"/>
    <p:option name="MasterCompareDisabled" select="'no'"/>
    
<!--    <p:serialization media-type="application/xml" method="xml" port="result"/>     -->
    <p:serialization port="result" media-type="text/plain" method="text" /> 

    <p:documentation>Load Result Document</p:documentation>
    <p:load name="Result">
        <p:with-option name="href" select="$filename"/>
    </p:load>
    
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
                        href="checkset_result_report.xsl"
                    />
                </p:input>
                <p:input port="parameters">
                    <p:empty/>
                </p:input>
            </p:xslt>
        </p:when>
        <p:when test="$format='status'">
            <p:choose>
                <p:when test="//@status[not(.=('fine','disabled'))]">
                    <p:xpath-context>
                        <p:pipe port="result" step="Result"/>  
                    </p:xpath-context>

                    <p:error xmlns:my="http://www.example.org/error"
                        name="bad-document" code="unk12">
                        <p:input port="source">
                            <p:inline>
                                <c:data content-type="text/plain">Checkset failed.</c:data>
                            </p:inline>
                        </p:input>
                    </p:error>                    
                </p:when>
                <p:otherwise>
                    <p:identity>
                        <p:input port="source">
                            <p:inline>
                                <c:data content-type="text/plain">Checkset worked fine.</c:data>
                            </p:inline>
                        </p:input>
                    </p:identity>
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
</p:declare-step>
