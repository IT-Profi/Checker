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
<p:declare-step name="Cleanup" type="bc:cleanup" 
    xmlns:bc="http://checker.bintellix.de/" 
    xmlns:er="http://compare.intersecurity.net/error-report/" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:cs="http://fs.bmw.com/checkset" 
    version="1.0">
    <p:input port="checkset" primary="true"/>
    <p:input port="document"/>
    <p:output port="result" sequence="true" primary="true"/>
    
    <p:option name="type" required="true"/>
    <p:option name="debug" required="true"/>
        
    <p:documentation>Cleanup Document</p:documentation>
    <p:try name="ChecksetPrefil">
        <p:group>
            <p:output port="result" primary="true"/>
            <p:output port="report">
                <p:empty/>
            </p:output>

            <p:documentation>Generate Clenup @ Checkset</p:documentation>
            <p:xslt name="Checkset_Prefill">
                <p:with-param name="type" select="$type"/>
                <p:input port="stylesheet">
                    <p:document href="checkset_generate_cleanup.xsl"/>
                </p:input>
            </p:xslt>

            <p:choose>
                <p:when test="$debug != 0">
                    <p:store>
                        <p:with-option name="href" select="concat('../work/checkset_cleanup_', $type, '.xsl')"/>
                    </p:store>
                </p:when>
                <p:otherwise>
                    <p:sink name="discarding-debugging-output"/>
                </p:otherwise>
            </p:choose>
            
            <p:documentation>Run Cleanup @ Checkset</p:documentation>
            <p:xslt name="Checkset_Cleanup">
                <p:input port="source">
                    <p:pipe port="document" step="Cleanup"/>
                </p:input>
                <p:input port="stylesheet">
                    <p:pipe port="result" step="Checkset_Prefill"/>
                </p:input>
                <p:input port="parameters">
                    <p:empty/>
                </p:input>
            </p:xslt>
            
        </p:group>
        <p:catch name="catch">
            <p:documentation> Catch Exception </p:documentation>
            <p:output port="result" primary="true">
                <p:inline>
                    <er:error>Checkset cleanup - the XPath checks are wrong.</er:error>
                </p:inline>
            </p:output>
            <p:output port="report">
                <p:pipe step="copy-errors" port="result"/>
            </p:output>
            <p:identity name="copy-errors">
                <p:input port="source">
                    <p:pipe step="catch" port="error"/>
                </p:input>
            </p:identity>
            <p:store>
                <p:with-option name="href" select="concat('../work/checkset_cleanup_', $type, '_error.txt')"/>
            </p:store>
            
        </p:catch>
    </p:try>
    
    <p:choose>
        <p:when test="$debug != 0">
            <p:store>
                <p:with-option name="href" select="concat('../work/checkset_cleanup_', $type, '.xml')"/>
            </p:store>
        </p:when>
        <p:otherwise>
            <p:sink name="discarding-debugging-output"/>
        </p:otherwise>
    </p:choose>

    <p:identity>
        <p:input port="source">
            <p:pipe port="result" step="ChecksetPrefil"/>
        </p:input>
    </p:identity> 
    
</p:declare-step>