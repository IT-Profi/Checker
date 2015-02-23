xquery version "3.0";

(:
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
(c) 2010-2015 by InterSecurity GmbH &amp; Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
:)

let $ct-home-web := request:get-attribute('ct-home-web')
let $group := request:get-attribute('group')
let $step_new := request:get-parameter('step_new','NewStep')
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:ct="http://compare.bintellix.de">
    <head>
        <xf:model schema="{$ct-home-web}/base/checker.xsd">
            <xf:instance xmlns="" id="request">
                <data xmlns="">
					<step_new>{$step_new}</step_new>
                </data>
            </xf:instance>
            <xf:submission id="create" method="get" action="create_response.html" replace="all" instance="request">
				<xf:action ev:event="xforms-submit-error">
					<xf:message>An error occurred.
						<xf:output value="event('error-type')">
							<xf:label>Error type</xf:label>
						</xf:output>
						<xf:output value="event('resource-uri')">
							<xf:label>Resource URI</xf:label>
						</xf:output>
						<xf:output value="event('response-status-code')">
							<xf:label>Status Code</xf:label>
						</xf:output>
						<xf:output value="event('response-reason-phrase')">
							<xf:label>Reason</xf:label>
						</xf:output>
						<xf:output value="event('response-headers')">
							<xf:label>Headers</xf:label>
						</xf:output>
						<xf:output value="event('response-body')">
							<xf:label>Body</xf:label>
						</xf:output>
					</xf:message>
				</xf:action>
			</xf:submission>

			<xf:bind nodeset="instance('request')/step_new" type="cs:LimitedParameterIdentifierType" required="true()"/>

        </xf:model>
    </head>
    <body>
        <xf:group appearance="full">
            <xf:label>Create new Step</xf:label>
            <xf:input ref="step_new" incremental="true">
                <xf:label>Step name: </xf:label>
                <xf:hint>NewStepName</xf:hint>
                <xf:alert>Format has to be: [A-Za-z][A-Za-z0-9_]{{1,99}}</xf:alert>
            </xf:input>
        </xf:group>
        <xf:group>        
            <xf:submit submission="create">
                <xf:label>Create</xf:label>
            </xf:submit>
        </xf:group>
    </body>
</html>