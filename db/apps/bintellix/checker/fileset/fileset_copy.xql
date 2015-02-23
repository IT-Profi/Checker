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
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $group_new := request:get-parameter('group_new',$group)
let $fileset := request:get-attribute('fileset')
let $fileset_new := request:get-parameter('fileset_new','NewFileset')
let $move := request:get-attribute('move')
return
if (not(matches($fileset_new,'[A-Za-z][A-Za-z0-9_]{1,99}'))) then
    <error>Invalid fileset name '{$fileset_new}'.</error>
else
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
    <head>
        <xf:model schema="{$ct-home-web}/base/checker.xsd">
            <xf:instance xmlns="" id="request">
                <request>
                    <group>{$group}</group>
                    <group_new>{$group_new}</group_new>
                    <fileset>{$fileset}</fileset>
					<fileset_new>{$fileset_new}</fileset_new>
                </request>
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
            <xf:submission id="move" method="get" action="move_response.html" replace="all" instance="request">
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

			<xf:bind nodeset="instance('request')/group" type="cs:LimitedParameterIdentifierType" required="true()" readonly="true()"/>
			<xf:bind nodeset="instance('request')/group_new" type="cs:LimitedParameterIdentifierType" required="true()"/>
			<xf:bind nodeset="instance('request')/fileset" type="cs:LimitedParameterIdentifierType" required="true()" readonly="true()"/>
			<xf:bind nodeset="instance('request')/fileset_new" type="cs:LimitedParameterIdentifierType" required="true()"/>

        </xf:model>
    </head>
    <body>
        <xf:group appearance="full">
            <xf:label>Source</xf:label>
            <xf:input ref="group" incremental="true">
                <xf:label>Group name: </xf:label>
            </xf:input>
            <xf:input ref="fileset" incremental="true">
                <xf:label>Fileset name: </xf:label>
            </xf:input>
        </xf:group>

        <xf:group appearance="full">
            <xf:label>Destination</xf:label>
            <xf:select1 ref="group_new" appearance="small" selection="closed">
                <xf:label>Group name: </xf:label>
                { for $i in xmldb:get-child-collections($ct-home-data) 
                    order by lower-case($i) 
                    return
                    <xf:item>
                        <xf:label>{$i}</xf:label>
                        <xf:value>{$i}</xf:value>
                    </xf:item>                    
                }                
            </xf:select1>            
            <xf:input ref="fileset_new" appearance="small" selection="closed">
                <xf:label>Fileset name: </xf:label>
                <xf:hint>The name of the new fileset</xf:hint>
                <xf:alert>Format has to be: [A-Z|a-z][0-9|A-Z|a-z|_]{{1-40}}</xf:alert>
            </xf:input>
        </xf:group>
        <xf:group>
		{ 
	      if ($move = 'yes') then
    	    <xf:submit submission="move">
                <xf:label>Move Fileset</xf:label>
            </xf:submit>
         else
            <xf:submit submission="copy">
                <xf:label>Copy Fileset</xf:label>
            </xf:submit>
		}
		</xf:group>
    </body>
</html>