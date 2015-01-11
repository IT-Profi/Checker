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

let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-parameter('group', '')
let $step := request:get-parameter('step', '')
let $ruleset-type := request:get-parameter('type', 'unknown')
let $ruleset-file := 
    if ($ruleset-type="GLOBAL") then concat($ct-home-data, "/", "step.xml")
    else if ($ruleset-type="GROUP") then concat($ct-home-data, "/", $group, "/", "step.xml")
    else concat($ct-home-data, "/", $group, "/", "step_", $step, ".xml")
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events">
    <head>
        <style>
        @namespace xf url("http://www.w3.org/2002/xforms");
        
        /* all the attributes of each tab, except the background color */
        body {{
            font-family: Arial, Helvetica, sans-serif;
        }}
        .xfInvalid input {{
        	background-color: pink;
        }}
        
        .xfRequired input {{
        	background-color: #FFFFEE;
        }}
        
        .xfOptional input {{
        	background-color: #FEFEFE;
        }}
        /* instructions for styling the horizontal tabs at the top of the form */
        #horiz-tab-menu {{
            padding-bottom: 1px;
        }}
        #horiz-tab-menu xf|trigger {{
            border-left: gray solid 1px;
            border-top: gray solid 1px;
            border-right: gray solid 1px;
            border-bottom: 0px; /* so the tab blends into the region under the tab */
            font-weight: bold;
            font-size: .9em;
            /* spacing between the tabs */
            margin-right: 9px;
            padding: 3px;
            /* round corners at the top of the tab - does not work on older versions of IE */
            -webkit-border-top-left-radius: 5px;
            -webkit-border-top-right-radius: 5px;
            -moz-border-radius-topleft: 5px;
            -moz-border-radius-topright: 5px;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }}
        /* properties common to all the swapped views */
        #div-1,#div-2,#div-3 {{
             padding: 5px;
             border-left: solid gray 1px;
             border-right: solid gray 1px;
             border-bottom: solid gray 1px;
        }}
        #tab-1, #div-1  {{
            background-color: lightblue;
        }}
        #tab-2, #div-2  {{
            background-color: lightgreen;
        }}
        #tab-3, #div-3  {{
            background-color: #FEFEFE;
        }}
        .url .xfValue  {{
            width: 100ex;
        }}
        .name .xfValue  {{
            width: 25ex;
        }}
        .xml .xfValue  {{
            width: 100ex;
            cols: 50;
        }}
       .widgetContainer {{
            display:block;
        }}
        input {{
            width:100%;
        }}
        </style>        
    </head>
    <menu xmlns="">
        <crosslinks>   
		{
		if ($ruleset-type!="global") then
		  <crosslink url="../../ruleset/edit.html" title="Global rulesets"/>
		else ()
		}            
        </crosslinks>
	</menu>        
    <body>
        <xf:model id="ConfigModel">
            <xf:instance xmlns="" id="group">
                {doc($ruleset-file)}
            </xf:instance>
            <xf:instance xmlns="" id="copy">
                <copy>
                    <checkset>
    					<index/>
	   				    <move-up/>
					    <move-down/>
					</checkset>
                    <check>
    					<index/>
	   				    <move-up/>
					    <move-down/>
					</check>
                    <cs:group enabled="false" filter="" id="none" type="VALIDATE" title="New">
                        <cs:checks>
                            <cs:check comment="" filter="" current-enabled="false" master-enabled="false" message="" name="New" type="WARNING"/>
                        </cs:checks>
                    </cs:group>
				</copy>
            </xf:instance>
            <xf:submission id="save" method="post" action="edit_response.html" instance="group" replace="none">
                <xf:action ev:event="xforms-submit-done">
					<xf:message>Successfully saved</xf:message>
				</xf:action>            
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

            <xf:bind nodeset="instance('group')/cs:groups/cs:group/@id" type="xs:ID"/>
            <xf:bind nodeset="instance('group')/cs:groups/cs:group/cs:checks/cs:check/@type" constraint="if (../../../@type='CLEANUP') then (. = ('REMOVE','REPLACE')) else (.=('CRITICAL','ERROR','WARNING','INFO'))"/>
            <!-- <xf:bind nodeset="/@id" type="string" constraint="string-length(.) &gt; 2" required="true()"/> -->
            <!--
            <xf:bind nodeset="instance('group')/cs:current/cs:connections/cs:connection/xs:cml" type="xs:any"/>
            <xf:bind nodeset="instance('group')/cs:master/cs:connections/cs:connection/xs:cml" type="xs:any"/>
            <xf:bind nodeset="instance('group')/cs:current/cs:connections/cs:connection/cs:soap/cs:request" type="xs:any"/>
            <xf:bind nodeset="instance('group')/cs:master/cs:connections/cs:connection/cs:soap/cs:request" type="xs:any"/>
            -->
            <xf:bind nodeset="instance('group')/cs:groups/cs:group/@enabled" type="xs:boolean"/>
            <xf:bind nodeset="instance('group')/cs:groups/cs:group/cs:checks/cs:check/@master-enabled" type="xs:boolean"/>
            <xf:bind nodeset="instance('group')/cs:groups/cs:group/cs:checks/cs:check/@current-enabled" type="xs:boolean"/>
            <xf:bind nodeset="instance('group')/cs:groups/cs:group/cs:checks/cs:check/@name" type="xs:string"/>
            <xf:bind nodeset="instance('group')/cs:groups/cs:group/cs:checks/cs:check/@message" type="xs:string" readonly="not(../@type=('REPLACE','CRITICAL','ERROR','WARNING','INFO'))"/>

            <xf:bind id="step-move-up" nodeset="instance('copy')/step/move-up" readonly="index('repeatStep') = 1"/> 
			<xf:bind id="step-move-down" nodeset="instance('copy')/step/move-down" readonly="index('repeatStep') = count(instance('group')/cs:groups/cs:group)"/>
            <xf:bind id="check-move-up" nodeset="instance('copy')/check/move-up" readonly="index('repeatCheck') = 1"/> 
			<xf:bind id="check-move-down" nodeset="instance('copy')/check/move-down" readonly="index('repeatCheck') = instance('group')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check"/>

        </xf:model>
        
  		<xf:submit submission="save">
			<xf:label>Save</xf:label>
		</xf:submit>

        <br />
        <br />       
            <div id="div-1">
                <h3>List of Rulesets</h3>
                <table class="tableform">
                    <thead>
                        <tr>
                            <th>#</th>
                            <!--
                            <th>Active</th>
                            -->
                            <th>ID</th>
                            <th>Type</th>
                            <th>Title</th>
                            <th>Filter</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody xf:repeat-nodeset="instance('group')/cs:groups/cs:group" id="repeatStep">
                        <tr>
                            <td>
                                <xf:output value="count(preceding-sibling::cs:group)+1"/>
                            </td>
                            <td>
                                 <a href="#">
                                    <xf:output ref="@id">
                                        <xf:alert>Invalid Identifier (min. 3 max. 50 char)</xf:alert>
                                        <xf:error>Invalid Identifier </xf:error>
                                    </xf:output>
                                </a>
                            </td>
                            <!--
                            <td>
                                <xf:input ref="@enabled"/>
                            </td>
                            -->
                            <td>
                                <xf:select1 ref="@type">
                                    <xf:alert>Please check if this type of action is allowed for this type or ruleset</xf:alert>
                                    <xf:item>
                                        <xf:label>Validate</xf:label>
                                        <xf:value>VALIDATE</xf:value>
                                    </xf:item>
                                    <xf:item>
                                        <xf:label>Cleanup</xf:label>
                                        <xf:value>CLEANUP</xf:value>
                                    </xf:item>
                                </xf:select1>
                            </td>
                            <td>
                                <xf:input ref="@title" style="width:30em;"/>
                            </td>
                            <td>
                                <xf:input ref="@filter" style="width:20em;"/>
                            </td>
                            <td>
                                <xf:input ref="@notes" style="width:60em;"/>
                            </td>
                        </tr>
                    </tbody>  
                    <tfoot>
                        <tr>
                            <td colspan="5">
                            </td>
                        </tr>
                    </tfoot>
                </table>
                <xf:trigger>
                    <xf:label>Add Group</xf:label>
                    <xf:action ev:event="DOMActivate">
                        <xf:setvalue ref="instance('copy')/cs:group/@id" value="translate(concat('{lower-case($ruleset-type)}', '_', substring(current-date(),1,10), generate-id()),'-','')"/>
                        <xf:insert nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')]" position="after" origin="instance('copy')/cs:group"/>
                    </xf:action>
                </xf:trigger>
                <xf:trigger>
                    <xf:label>Delete Group</xf:label>
                    <xf:action ev:event="DOMActivate">
                        <xf:delete at="index('repeatStep')" nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')]" if="count(instance('group')/cs:groups/cs:group) &gt; 1"/>
                    </xf:action>
                </xf:trigger>   
                <xf:trigger appearance="full" bind="step-move-up">
                    <xf:label>Move Up</xf:label>
                    <xf:action ev:event="DOMActivate">
                        <xf:setvalue ref="instance('copy')/step/index" value="index('repeatStep')"/>
                        <xf:insert nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')-1]" position="before" origin="instance('group')/cs:groups/cs:group[index('repeatStep')]"/>
                        <xf:setindex repeat="repeatstep" index="instance('copy')/step/index -1"/>
                        <xf:delete at="index('repeatStep')+2" nodeset="instance('group')/cs:groups/cs:group"/>
                    </xf:action>
                </xf:trigger>
                <xf:trigger appearance="full" bind="step-move-down">
                    <xf:label>Move Down</xf:label>
                    <xf:action ev:event="DOMActivate">
                        <xf:setvalue ref="instance('copy')/step/index" value="index('repeatStep')"/>
                        <xf:insert nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')+1]" position="after" origin="instance('group')/cs:groups/cs:group[index('repeatStep')]"/>
                        <xf:setindex repeat="repeatStep" index="instance('copy')/step/index +1"/>
                        <xf:delete at="index('repeatStep')-1" nodeset="instance('group')/cs:groups/cs:group"/>
                    </xf:action>
                </xf:trigger>
            </div>
        <br />
        <h3>Regarding Rules (of selected Ruleset):</h3>
        <table class="tableform">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Current (Live data)</th>
                    <th>Reference (Master data)</th>
                    <th>Name</th>
                    <th>XPath</th>
                    <th>
                        <xf:group ref="instance('group')/cs:groups/cs:group[index('repeatStep')]/@type[.='CLEANUP']">
                            <xf:output value="'Value'"/>
                        </xf:group>
                        <xf:group ref="instance('group')/cs:groups/cs:group[index('repeatStep')]/@type[.='VALIDATE']">
                            <xf:output value="'Message'"/>
                        </xf:group>
                    </th>
                    <th>Comment</th>
                    <th>Type</th>
                </tr>
            </thead>
            <tbody xf:repeat-nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check" id="repeatCheck">
                <tr>
                    <td>
                        <xf:output value="count(preceding-sibling::cs:check)+1"/>
                    </td>
                    <td>
                       <xf:input ref="@current-enabled"/>
                    </td>
                    <td>
                       <xf:input ref="@master-enabled"/>
                    </td>                        
                    <td>
                        <xf:input ref="@name" class="name"/>
                    </td>
                    <td>
                        <div style="float:left; font-size:120%;">//</div>
                        <div style="float:right">
                          <xf:input ref="@filter" class="url"/>
                        </div>
                    </td>
                    <td>
                        <xf:textarea ref="@message"/>
                    </td>
                    <td>
                        <xf:textarea ref="@comment"/>
                    </td>                    	
                    <td>
                        <xf:select1 ref="@type">
                            <xf:item>
                                <xf:label>remove</xf:label>
                                <xf:value>REMOVE</xf:value>
                            </xf:item>
                            <xf:item>
                                <xf:label>replace</xf:label>
                                <xf:value>REPLACE</xf:value>
                            </xf:item>
                            <xf:item>
                                <xf:label>info</xf:label>
                                <xf:value>INFO</xf:value>
                            </xf:item>
                            <xf:item>
                                <xf:label>warning</xf:label>
                                <xf:value>WARNING</xf:value>
                            </xf:item>
                            <xf:item>
                                <xf:label>error</xf:label>
                                <xf:value>ERROR</xf:value>
                            </xf:item>
                            <xf:item>
                                <xf:label>critical</xf:label>
                                <xf:value>CRITICAL</xf:value>
                            </xf:item>
                        </xf:select1>
                    </td>
                 </tr>
            </tbody>
            <!--
            <tfoot>
                <tr>
                    <td colspan="6">
                   </td>
                </tr>
            </tfoot>
            <-->
        </table>
        
        <div class="tfoot">
                         <xf:trigger>
                            <xf:label>Add Check</xf:label>
                            <xf:action ev:event="DOMActivate">
                                <xf:insert nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]" position="after" origin="instance('copy')/cs:group/cs:checks/cs:check"/>
                                <!-- set default values -->
                                <!-- <xf:setvalue ref="instance('group')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]/@forMaster" value="false()"/> -->
                            </xf:action>
                        </xf:trigger>
                        <xf:trigger>
                            <xf:label>Delete Check</xf:label>
                            <xf:action ev:event="DOMActivate">
                            	<xf:delete at="index('repeatCheck')" nodeset="instance('group')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]" if="count(instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check) &gt; 1" />                            	
                            </xf:action>
                        </xf:trigger>
                        <xf:trigger appearance="full" bind="check-move-up">
                            <xf:label>Move Up</xf:label>
                            <xf:action ev:event="DOMActivate">
                            	<xf:setvalue ref="instance('copy')/check/index" value="index('repeatCheck')"/>
                                <xf:insert nodeset="instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')-1]" position="before" origin="instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]"/>
                            	<xf:setindex repeat="repeatCheck" index="instance('copy')/check/index -1"/>
                            	<xf:delete at="index('repeatCheck')+2" nodeset="instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check"/>
                            </xf:action>
                        </xf:trigger>
                        <xf:trigger appearance="full" bind="check-move-down">
                            <xf:label>Move Down</xf:label>
                            <xf:action ev:event="DOMActivate">
                            	<xf:setvalue ref="instance('copy')/check/index" value="index('repeatCheck')"/>
                            	<xf:insert nodeset="instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')+1]" position="after" origin="instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]"/>
                                <xf:setindex repeat="repeatCheck" index="instance('copy')/check/index +1"/>
                            	<xf:delete at="index('repeatCheck')-1" nodeset="instance('group')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check"/>
                            </xf:action>
                        </xf:trigger>
        </div>
    </body>
</html>