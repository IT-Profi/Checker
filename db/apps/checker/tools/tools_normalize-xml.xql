xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace bc="http://checker.bintellix.de/";
declare namespace cs="http://checker.bintellix.de/checkset/";

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

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <head>
        <style type="text/css">
        <![CDATA[
            label {
                display: inline-block;
            }
        ]]>
        </style>
        <xf:model id="ConfigModel"> <!-- schema="{$ct-home-web}/base/checker.xsd" -->
            <xf:instance xmlns="" id="config">
                <config xmlns="">
                    <file xsi:type="xs:base64Binary"/>
                </config>
            </xf:instance>
            
            <xf:bind nodeset="instance('config')/abc" type="xs:string" required="true()"/>
 
            <xf:submission id="run" method="post" action="normalize-xml_response.xml" instance="config" replace="all">
                <!--
            	<xf:action ev:event="xforms-submit-done">
					<xf:message>Successfully run</xf:message>
				</xf:action>
				-->
                <xf:action ev:event="xforms-submit-error">
                    <xf:message>An error occurred.
                        Error:
                        <xf:output value="event('error-type')"/>
                        Uri:
                        <xf:output value="event('resource-uri')"/>
                        Status Code:
                        <xf:output value="event('response-status-code')"/>
                        Reason:
                        <xf:output value="event('response-reason-phrase')"/>
                        Headers:
                        <xf:output value="event('response-headers')"/>
                        Body:
                        <xf:output value="event('response-body')"/>
                    </xf:message>
                </xf:action>
            </xf:submission>
        </xf:model>        
    </head>
    <body>
        <subtitle>Select file to normalize</subtitle>
        <div>
            <xf:upload ref="instance('config')/file" mediatype="text/xml">
                <xf:filename>file:///C:/tmp/*.xml</xf:filename>
                <xf:mediatype>text/xml</xf:mediatype>
            </xf:upload>
            <br/>
            <!--
            <xf:output ref="instance('config')/file">
                <xf:label>File: </xf:label>
            </xf:output>
            <br/>
            -->
            <xf:submit submission="run">
                <xf:label>Run</xf:label>
            </xf:submit>
        </div>
    </body>
</html>