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
<p:declare-step name="Compare" type="bc:compare" 
    xmlns:bc="http://checker.bintellix.de/" 
    xmlns:er="http://compare.intersecurity.net/error-report/" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    version="1.0">
    <p:input port="checkset" primary="true"/>
    <p:input port="current"/>
    <p:input port="master"/>
    <p:output port="result" sequence="true" primary="true"/>
        
    <p:option name="debug" required="true"/>
    
    <p:documentation>Compare Documents</p:documentation>
    <p:group name="compare">
        <p:output port="result" primary="true">
            <p:pipe step="XMLDiffLog" port="result"/>
            <!-- Report -->
        </p:output>
        <p:documentation>Compare Files</p:documentation>
        
        <p:documentation>Generate Compare @ Checkset</p:documentation>
        <p:xslt name="Compare_Generated">
            <p:input port="source">
                <p:pipe port="checkset" step="Compare"/>
            </p:input>
            <p:input port="stylesheet">
                <p:document href="checkset_generate_compare.xsl"/>
            </p:input>
            <p:input port="parameters">
                <p:empty/>
            </p:input>
        </p:xslt>
        <p:choose>
            <p:when test="$debug != 0">
                <p:store>
                    <p:with-option name="href" select="'../work/checkset_compare.xsl'"/>
                </p:store>
            </p:when>
            <p:otherwise>
                <p:sink name="discarding-debugging-output"/>
            </p:otherwise>
        </p:choose>
        
        <p:wrap name="CurrentCurrent" match="/" wrapper="current">
            <p:input port="source">
                <p:pipe port="current" step="Compare"/>
            </p:input>        
        </p:wrap>         
        
        <p:wrap name="MasterMaster" match="/" wrapper="master">
            <p:input port="source">
                <p:pipe port="master" step="Compare"/>
            </p:input>
        </p:wrap>        
        
        <p:pack wrapper="diff" name="Compare_Request">
            <p:input port="source">
                <p:pipe port="result" step="CurrentCurrent"/>
            </p:input>
            <p:input port="alternate">
                <p:pipe port="result" step="MasterMaster"/>
            </p:input>
        </p:pack>
        <p:choose>
            <p:when test="$debug != 0">
                <p:store>
                    <p:with-option name="href" select="'../work/checkset_compare_request.xml'"/>
                </p:store>
            </p:when>
            <p:otherwise>
                <p:sink name="discarding-debugging-output"/>
            </p:otherwise>
        </p:choose>        
        <p:xslt name="XMLDiff">
            <p:input port="source">
                <p:pipe port="result" step="Compare_Request"/>
            </p:input>
            <p:input port="stylesheet">
                <p:pipe port="result" step="Compare_Generated"/>
            </p:input>
            <p:input port="parameters">
                <p:empty/>
            </p:input>
        </p:xslt>
        <p:choose>
            <p:when test="$debug != 0">
                <p:store>
                    <p:with-option name="href" select="'../work/checkset_compare_result.xml'"/>
                </p:store>
            </p:when>
            <p:otherwise>
                <p:sink name="discarding-debugging-output"/>
            </p:otherwise>
        </p:choose>
        <p:identity name="XMLDiffLog">
            <p:input port="source">
                <p:pipe port="result" step="XMLDiff"/>
            </p:input>
        </p:identity>
    </p:group> 
    
</p:declare-step>