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
let $group := request:get-parameter('group','')[1]
let $group_new := request:get-parameter('group_new','NewGroup')
let $move := request:get-parameter('move','no')
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
    <head>
        <xf:model schema="{$ct-home-web}/base/checker.xsd">
            <xf:instance xmlns="" id="request">
                <data>
                    <group>{$group}</group>
					<group_new>{$group_new}</group_new>
                </data>
            </xf:instance>
            <xf:submission id="copy" method="get" action="copy_response.html" replace="all" instance="request">
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
            <xf:submission id="move" method="get" action="copy_response.html?move=yes" replace="all" instance="request">
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

			<xf:bind nodeset="instance('request')/group" type="cs:LimitedParameterIdentifierType" required="true()"/>
			<xf:bind nodeset="instance('request')/group_new" type="cs:LimitedParameterIdentifierType" required="true()"/>

        </xf:model>
    </head>
    <body>
		<subtitle>Original</subtitle>
        <xf:output ref="group" incremental="true">
            <xf:label>Group: </xf:label>
        </xf:output>
        <br/>

        <subtitle>New</subtitle>
        <xf:input ref="group_new" incremental="true">
            <xf:label>Group: </xf:label>
             <xf:alert>Format has to be: [A-Z|a-z][0-9|A-Z|a-z|_]{{1-40}}</xf:alert>
        </xf:input>
        <br/>
        <br/>
		{ 
	      if ($move = 'yes') then
    	    <xf:submit submission="move">
                <xf:label>Move</xf:label>
            </xf:submit>
         else
            <xf:submit submission="copy">
                <xf:label>Copy</xf:label>
            </xf:submit>
		}
    </body>
</html>