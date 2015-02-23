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
let $step := doc(concat($ct-home-data,'/',$group,'/step.xml'))
let $tab := request:get-parameter('tab','')
let $ruleset-type := 'group'
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:cs="http://checker.bintellix.de/checkset/">
    <head>
        <link rel="stylesheet" type="text/css" href="{$ct-home-web}/base/checker_tab-menu.css"/>  
        <script type="text/javascript">        
            window.addEventListener('keydown', function(event) {{
                if (event.ctrlKey || event.metaKey) {{
                    switch (String.fromCharCode(event.which).toLowerCase()) {{
                    case 's':
                        event.preventDefault();
                        document.getElementById("Save-value").click();            
                        // alert('ctrl-s');
                        break;
                    case 'r':
                        event.preventDefault();
                        var links = document.evaluate('//a[text()="Run checkset"]/@href', document, null, XPathResult.ANY_TYPE, null );
                        var thisLink = links.iterateNext();
                        while (thisLink) {{
                            window.open(thisLink.textContent, '_blank');
                            thisLink = links.iterateNext();
                        }}
            
                        //alert('ctrl-r');
                        break;
                    }}
                }}
            }});
        </script>        
        <xf:model schema="{$ct-home-web}/base/checker.xsd">
            <xf:instance xmlns="" id="step">
                {$step}
            </xf:instance>

            <xf:instance xmlns="" id="template">
                {doc(concat($ct-home-data,'/step_group_template.xml'))}
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

            <xf:bind ref="instance('step')/cs:namespaces[@type='GROUP']/cs:namespace/@prefix" type="xs:ID" required="true()"/>
            <xf:bind ref="instance('step')/cs:namespaces[@type='GROUP']/cs:namespace/@uri" type="xs:anyURI" required="true()"/> 
            
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/@id" type="xs:ID"/>
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/cs:checks/cs:check/@type" constraint="if (../../../@type='CLEANUP') then (. = ('REMOVE','REPLACE')) else (.=('CRITICAL','ERROR','WARNING','INFO'))"/>
            <!-- <xf:bind nodeset="/@id" type="string" constraint="string-length(.) &gt; 2" required="true()"/> -->
            <!--
            <xf:bind nodeset="instance('group')/cs:current/cs:connections/cs:connection/xs:cml" type="xs:any"/>
            <xf:bind nodeset="instance('group')/cs:master/cs:connections/cs:connection/xs:cml" type="xs:any"/>
            <xf:bind nodeset="instance('group')/cs:current/cs:connections/cs:connection/cs:soap/cs:request" type="xs:any"/>
            <xf:bind nodeset="instance('group')/cs:master/cs:connections/cs:connection/cs:soap/cs:request" type="xs:any"/>
            -->
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/@enabled" type="xs:boolean"/>
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/cs:checks/cs:check/@master-enabled" type="xs:boolean"/>
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/cs:checks/cs:check/@current-enabled" type="xs:boolean"/>
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/cs:checks/cs:check/@name" type="xs:string"/>
            <xf:bind nodeset="instance('step')/cs:groups/cs:group/cs:checks/cs:check/@message" type="xs:string" readonly="not(../@type=('REPLACE','CRITICAL','ERROR','WARNING','INFO'))"/>

            <xf:bind id="step-move-up" nodeset="instance('copy')/step/move-up" readonly="index('repeatStep') = 1"/> 
			<xf:bind id="step-move-down" nodeset="instance('copy')/step/move-down" readonly="index('repeatStep') = count(instance('step')/cs:groups/cs:group)"/>
            <xf:bind id="check-move-up" nodeset="instance('copy')/check/move-up" readonly="index('repeatCheck') = 1"/> 
			<xf:bind id="check-move-down" nodeset="instance('copy')/check/move-down" readonly="index('repeatCheck') = instance('step')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check"/>
            
            <xf:submission id="save" method="post" action="edit_response.html" replace="all" instance="step">
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
        </xf:model>
    </head>
    <menu xmlns="">
        <crosslinks>
            <crosslink url="ruleset/edit.html" title="Global rulesets"/>
            <crosslink url="step/overview.html" title="Step overview"/>
        </crosslinks>
    </menu>    
    <body>
    	<subtitle>Group Edit</subtitle>
        <xf:submit submission="save" id="Save">
            <xf:label>Save</xf:label>
        </xf:submit>
        <br/>
        <br/>
        <div class="horiz-tab-menu">
            <xf:trigger id="t-case-3" appearance="minimal">
                <xf:label>Namespaces</xf:label>
                <xf:toggle case="case-3" ev:event="DOMActivate"/>
            </xf:trigger>        
            <xf:trigger id="t-case-1" appearance="minimal">
                <xf:label>Variables</xf:label>
                <xf:toggle case="case-1" ev:event="DOMActivate"/>
            </xf:trigger>
            <xf:trigger id="t-case-4" appearance="minimal">
                <xf:label>Compare</xf:label>
                <xf:toggle case="case-4" ev:event="DOMActivate"/>
            </xf:trigger>        
            <xf:trigger id="t-case-2" appearance="minimal">
                <xf:label>Rulesets</xf:label>
                <xf:toggle case="case-2" ev:event="DOMActivate"/>
            </xf:trigger>        
            <xf:switch>
                <xf:case id="case-1">
                    {if ($tab='variables') then attribute {'selected'} {'true'} else ()}
                    <div id="div-1">
                        <div class="headline">
                            <b>Variables</b>
                        </div>
                        <table class="tableform">
                            <thead>
                                <tr>
                                    <th>Description</th>
                                    <th>Name</th>
                                    <th>Value list</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody xf:repeat-nodeset="instance('step')/cs:variables[@type='GROUP']/cs:variable" id="repeatVariables">
                                <tr>
                                    <td><xf:input ref="@description"/></td>
                                    <td><xf:input ref="@name"/></td>
                                    <td>
                                        <xf:repeat ref="cs:values/cs:value">
                                            <xf:input ref="@value">
                                                <xf:label>Value</xf:label>
                                            </xf:input>                                        
                                            <xf:input ref="@description">
                                                <xf:label>Description</xf:label>
                                            </xf:input>
                                            <xf:trigger>
                                                <xf:label>Delete</xf:label>
                                                <xf:action ev:event="DOMActivate">
                                                    <xf:delete nodeset="."/>
                                                </xf:action>
                                            </xf:trigger>
                                        </xf:repeat>
                                        <xf:trigger>
                                            <xf:label>Add Value</xf:label>
                                            <xf:action ev:event="DOMActivate">
                                                <xf:insert context="instance('step')/cs:variables[@type='GROUP']/cs:variable[index('repeatVariables')]/cs:values" nodeset="cs:value" origin="(instance('template')/cs:variables[@type='GROUP']/cs:variable/cs:values/cs:value)[1]"/>
                                            </xf:action>
                                        </xf:trigger>
                                    </td>
                                    <td>
                                        <xf:trigger>
                                            <xf:label>Delete</xf:label>
                                            <xf:action ev:event="DOMActivate">
                                                <xf:delete nodeset="instance('step')/cs:variables[@type='GROUP']/cs:variable" at="index('repeatVariables')"/>
                                            </xf:action>
                                        </xf:trigger>
                                    </td>
                                </tr>                                
                            </tbody>
                            <tfoot>
                                <!-- tfoot is currently not used -->
                            </tfoot>
                        </table>
                        <tr>
                            <td colspan="3">
                                <xf:trigger>
                                    <xf:label>Add Variable</xf:label>
                                    <xf:action ev:event="DOMActivate">
                                        <xf:insert context="instance('step')/cs:variables[@type='GROUP']" nodeset="cs:variable" origin="(instance('template')/cs:variables[@type='GROUP']/cs:variable)[1]"/>
                                    </xf:action>
                                </xf:trigger>
                            </td>
                        </tr>                        
                    </div>
                </xf:case>
                <xf:case id="case-2">
                    {if ($tab='rulesets') then attribute {'selected'} {'true'} else ()}                
                    <div id="div-2">
                        <div class="headline">
                            <b>Rulesets</b>
                        </div>
                        <div class="rulesets">
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
                                <tbody xf:repeat-nodeset="instance('step')/cs:groups/cs:group" id="repeatStep">
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
                                    <xf:insert nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')]" position="after" origin="instance('copy')/cs:group"/>
                                </xf:action>
                            </xf:trigger>
                            <xf:trigger>
                                <xf:label>Delete Group</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:delete at="index('repeatStep')" nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')]" if="count(instance('step')/cs:groups/cs:group) &gt; 1"/>
                                </xf:action>
                            </xf:trigger>   
                            <xf:trigger appearance="full" bind="step-move-up">
                                <xf:label>Move Up</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:setvalue ref="instance('copy')/step/index" value="index('repeatStep')"/>
                                    <xf:insert nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')-1]" position="before" origin="instance('step')/cs:groups/cs:group[index('repeatStep')]"/>
                                    <xf:setindex repeat="repeatstep" index="instance('copy')/step/index -1"/>
                                    <xf:delete at="index('repeatStep')+2" nodeset="instance('step')/cs:groups/cs:group"/>
                                </xf:action>
                            </xf:trigger>
                            <xf:trigger appearance="full" bind="step-move-down">
                                <xf:label>Move Down</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:setvalue ref="instance('copy')/step/index" value="index('repeatStep')"/>
                                    <xf:insert nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')+1]" position="after" origin="instance('step')/cs:groups/cs:group[index('repeatStep')]"/>
                                    <xf:setindex repeat="repeatStep" index="instance('copy')/step/index +1"/>
                                    <xf:delete at="index('repeatStep')-1" nodeset="instance('step')/cs:groups/cs:group"/>
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
                                        <xf:group ref="instance('step')/cs:groups/cs:group[index('repeatStep')]/@type[.='CLEANUP']">
                                            <xf:output value="'Value'"/>
                                        </xf:group>
                                        <xf:group ref="instance('step')/cs:groups/cs:group[index('repeatStep')]/@type[.='VALIDATE']">
                                            <xf:output value="'Message'"/>
                                        </xf:group>
                                    </th>
                                    <th>Comment</th>
                                    <th>Type</th>
                                </tr>
                            </thead>
                            <tbody xf:repeat-nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check" id="repeatCheck">
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
                                    <xf:insert nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]" position="after" origin="instance('copy')/cs:group/cs:checks/cs:check"/>
                                    <!-- set default values -->
                                    <!-- <xf:setvalue ref="instance('step')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]/@forMaster" value="false()"/> -->
                                </xf:action>
                            </xf:trigger>
                            <xf:trigger>
                                <xf:label>Delete Check</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:delete at="index('repeatCheck')" nodeset="instance('step')/cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]" if="count(instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check) &gt; 1" />                            	
                                </xf:action>
                            </xf:trigger>
                            <xf:trigger appearance="full" bind="check-move-up">
                                <xf:label>Move Up</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:setvalue ref="instance('copy')/check/index" value="index('repeatCheck')"/>
                                    <xf:insert nodeset="instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')-1]" position="before" origin="instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]"/>
                                    <xf:setindex repeat="repeatCheck" index="instance('copy')/check/index -1"/>
                                    <xf:delete at="index('repeatCheck')+2" nodeset="instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check"/>
                                </xf:action>
                            </xf:trigger>
                            <xf:trigger appearance="full" bind="check-move-down">
                                <xf:label>Move Down</xf:label>
                                <xf:action ev:event="DOMActivate">
                                    <xf:setvalue ref="instance('copy')/check/index" value="index('repeatCheck')"/>
                                    <xf:insert nodeset="instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')+1]" position="after" origin="instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check[index('repeatCheck')]"/>
                                    <xf:setindex repeat="repeatCheck" index="instance('copy')/check/index +1"/>
                                    <xf:delete at="index('repeatCheck')-1" nodeset="instance('step')//cs:groups/cs:group[index('repeatStep')]/cs:checks/cs:check"/>
                                </xf:action>
                            </xf:trigger>
                        </div>             
                    </div>                   
                </xf:case>
                <xf:case id="case-3">
                    {if ($tab=('','namespaces')) then attribute {'selected'} {'true'} else ()}               
                    <div id="div-3">
                        <div class="headline">
                            <b>Namespaces</b>
                        </div>
                        <table class="tableform">
                            <thead>
                                <tr>
                                    <th>Prefix</th>
                                    <th>URI</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody xf:repeat-nodeset="instance('step')/cs:namespaces[@type='GROUP']/cs:namespace" id="repeatNamespaces">
                                <tr>
                                    <td><xf:input ref="@prefix"/></td>
                                    <td><xf:input ref="@uri"/></td>
                                    <td>
                                        <xf:trigger>
                                            <xf:label>Delete</xf:label>
                                            <xf:action ev:event="DOMActivate">
                                                <xf:delete nodeset="instance('step')/cs:namespaces[@type='GROUP']/cs:namespace" at="index('repeatNamespaces')"/>
                                            </xf:action>
                                        </xf:trigger>                                    
                                    </td>
                                </tr>                                
                            </tbody>
                            <tfoot>
                                <!-- tfoot is currently not used -->
                            </tfoot>
                        </table>
                        <tr>
                            <td colspan="3">
                                <xf:trigger>
                                    <xf:label>Add Variable</xf:label>
                                    <xf:action ev:event="DOMActivate">
                                        <xf:insert context="instance('step')/cs:namespaces[@type='GROUP']" nodeset="cs:namespace" origin="(instance('template')/cs:namespaces[@type='GROUP']/cs:namespace)[1]"/>
                                    </xf:action>
                                </xf:trigger>
                            </td>
                        </tr>                        
                    </div>
                </xf:case>                
                <xf:case id="case-4">
                    {if ($tab='compare') then attribute {'selected'} {'true'} else ()}
                    <div id="div-4">
                        <div class="headline">
                            <b>Compare</b>
                        </div>
                        <table class="tableform">
                            <thead>
                                <tr>
                                    <th>Element name</th>                                    
                                    <th>Matches XPath</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody xf:repeat-nodeset="instance('step')/cs:checksets/cs:config/cs:ignore-orders/cs:ignore-order" id="repeatIgnoreOrders">
                                <tr>
                                    <td><xf:input ref="@element"/></td>
                                    <td>
                                        <xf:repeat ref="cs:match">
                                            <xf:input ref="@xpath">
                                                <xf:label>XPath</xf:label>
                                            </xf:input>                                        
                                            <xf:trigger>
                                                <xf:label>Delete</xf:label>
                                                <xf:action ev:event="DOMActivate">
                                                    <xf:delete nodeset="."/>
                                                </xf:action>
                                            </xf:trigger>
                                        </xf:repeat>
                                        <xf:trigger>
                                            <xf:label>Add Order</xf:label>
                                            <xf:action ev:event="DOMActivate">
                                                <xf:insert context="instance('step')/cs:checksets/cs:config/cs:ignore-orders/cs:ignore-order[index('repeatIgnoreOrders')]" nodeset="cs:match" origin="(instance('step')/cs:checksets/cs:config/cs:ignore-orders/cs:ignore-order[1]/cs:match)[1]"/>
                                            </xf:action>
                                        </xf:trigger>
                                    </td>
                                    <td>
                                        <xf:trigger>
                                            <xf:label>Delete</xf:label>
                                            <xf:action ev:event="DOMActivate">
                                                <xf:delete nodeset="instance('step')/cs:checksets/cs:config/cs:ignore-orders/cs:ignore-order" at="index('repeatIgnoreOrders')"/>
                                            </xf:action>
                                        </xf:trigger>
                                    </td>
                                </tr>                                
                            </tbody>
                            <tfoot>
                                <!-- tfoot is currently not used -->
                            </tfoot>
                        </table>
                        <tr>
                            <td colspan="3">
                                <xf:trigger>
                                    <xf:label>Add Variable</xf:label>
                                    <xf:action ev:event="DOMActivate">
                                        <xf:insert context="instance('step')/cs:variables[@type='GROUP']" nodeset="cs:variable" origin="(instance('template')/cs:variables[@type='GROUP']/cs:variable)[1]"/>
                                    </xf:action>
                                </xf:trigger>
                            </td>
                        </tr>                        
                    </div>
                </xf:case>                
            </xf:switch>
        </div>        
    </body>
</html>