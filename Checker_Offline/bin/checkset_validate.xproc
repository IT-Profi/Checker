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
(c) 2010-2014 by InterSecurity GmbH &amp; Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
-->
<p:declare-step name="validate" type="bc:validate"
    xmlns:bc="http://checker.bintellix.de/" 
    xmlns:er="http://compare.intersecurity.net/error-report/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:cs="http://fs.bmw.com/checkset" 
    version="1.0">
    <p:input port="source" primary="true"/>
    <p:output port="result" sequence="true" primary="true">
        <p:pipe port="result" step="ValidateResult"/>
    </p:output>
    
    <p:option name="type" required="true"/>
    <p:option name="debug" required="true"/>
    <p:option name="url" required="true"/>
    
    <p:identity name="Document"/>
    
    <p:documentation>XML-Schema validation</p:documentation>
    <p:try name="try">
        <p:group>
            <p:output port="result" primary="true">
                <p:inline>
                    <result>Document is XML schmema valid.</result>
                </p:inline>
            </p:output>
            <p:output port="report" primary="false">
                <p:empty/>
            </p:output>
            <p:documentation>Load XML-Schema</p:documentation>
            <p:load name="Schema">
                <p:with-option name="href" select="$url"/>
            </p:load>
            <p:documentation>validate XML</p:documentation>
            <!--<p:unwrap match="ns4:SFFinanceProductResponse/Header"/>-->
            <p:validate-with-xml-schema name="Validated" assert-valid="true" use-location-hints="true">
                <p:input port="source">
                    <p:pipe port="result" step="Document"/>
                </p:input>
                <p:input port="schema">
                    <p:pipe port="result" step="Schema"/>
                </p:input>
            </p:validate-with-xml-schema>
            <p:sink/>
        </p:group>
        <p:catch name="catch">
            <p:documentation> Catch Exception </p:documentation>
            <p:output port="result" primary="true">
                <p:inline>
                    <er:error>The document is not XML schema valid</er:error>
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
        </p:catch>
    </p:try>
    
    <p:pack wrapper="validate" name="ValidateResult">
        <p:input port="source">
            <p:pipe step="try" port="result"/>
        </p:input>
        <p:input port="alternate">
            <p:pipe step="try" port="report"/>
        </p:input>
    </p:pack>

    <p:choose>
        <p:when test="$debug != 0">
            <p:store>
                <p:with-option name="href" select="concat('../work/checkset_validate_', $type, '.xml')"/>
            </p:store>
        </p:when>
        <p:otherwise>
            <p:sink name="discarding-debugging-output"/>
        </p:otherwise>
    </p:choose>
    
</p:declare-step>