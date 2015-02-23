xquery version "3.0";
declare namespace cs="http://checker.bintellix.de/checkset/";
declare namespace xf="http://www.w3.org/2002/xforms";
declare namespace ev="http://www.w3.org/2001/xml-events";
declare namespace xdb="http://exist-db.org/xquery/xmldb";
declare namespace bc="http://checker.bintellix.de/";

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

declare function local:editRulesets($type as xs:string) as node()*
{
    <div xmlns="http://www.w3.org/1999/xhtml">
        <div>
            <table class="tableform">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Active</th>
                        <th style="width:15em">ID</th>
                        <th style="width:5em">Type</th>
                        <th style="width:30em">Title</th>
                        <th style="width:20em">Filter</th>
                        <th style="width:50em">Notes</th>
                    </tr>
                </thead>
                <tbody xf:repeat-nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group" id="repeatCheckset">
                    <tr>
                        <td>
                            <xf:output value="count(preceding-sibling::cs:use-group)+1"/>
                        </td>
                        <td>
                            <xf:input ref="@enabled"/>
                        </td>
                        <td> 
                            <xf:output ref="@ref-id">
                                <xf:alert>Invalid Identifier (min. 3 max. 50 char)</xf:alert>
                                <xf:error>Invalid Identifier </xf:error>
                            </xf:output>
                        </td>
                        <td>
                            <xf:select1 ref="@type">
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
                            <xf:input ref="@title"/>
                        </td>
                        <td>
                            <xf:input ref="@filter"/>
                        </td>
                        <td>
                            <xf:input ref="@notes"/>
                        </td>
                    </tr>
                </tbody>  
                <tfoot>
                    <tr>
                        <td colspan="5">
                            <!-- tfoot is currently not used -->
                        </td>
                    </tr>
                </tfoot>
            </table>
            <xf:trigger>
                <xf:label>Remove Ruleset</xf:label>
                <xf:action ev:event="DOMActivate">
                    <xf:delete at="index('repeatCheckset')" nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group[index('repeatCheckset')]" if="count(instance('step')/cs:checkset/cs:usage/cs:use-group) &gt; 1"/>
                </xf:action>
            </xf:trigger>   
            <xf:trigger appearance="full" bind="checkset-move-up">
                <xf:label>Move Up</xf:label>
                <xf:action ev:event="DOMActivate">
                    <xf:setvalue ref="instance('copy')/checkset/index" value="index('repeatCheckset')"/>
                    <xf:insert nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group[index('repeatCheckset')-1]" position="before" origin="instance('step')/cs:checkset/cs:usage/cs:use-group[index('repeatCheckset')]"/>
                    <xf:setindex repeat="repeatCheckset" index="instance('copy')/checkset/index -1"/>
                    <xf:delete at="index('repeatCheckset')+2" nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group"/>
                </xf:action>
            </xf:trigger>
            <xf:trigger appearance="full" bind="checkset-move-down">
                <xf:label>Move Down</xf:label>
                <xf:action ev:event="DOMActivate">
                    <xf:setvalue ref="instance('copy')/checkset/index" value="index('repeatCheckset')"/>
                    <xf:insert nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group[index('repeatCheckset')+1]" position="after" origin="instance('step')/cs:checkset/cs:usage/cs:use-group[index('repeatCheckset')]"/>
                    <xf:setindex repeat="repeatCheckset" index="instance('copy')/checkset/index +1"/>
                    <xf:delete at="index('repeatCheckset')-1" nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group"/>
                </xf:action>
            </xf:trigger>
        </div>
        <br/>
        <hr/>
        <br/>
        <div>
            <b>Additional <a href="../../../ruleset/edit.html" target="_blank">Global Rulesets</a>:</b>
            <br/>
            <br/>
            <div>
                <table class="tableform">
                    <thead>
                        <tr>
                            <th style="width:15em">ID</th>
                            <th style="width:5em">Type</th>
                            <th style="width:30em">Title</th>
                            <th style="width:20em">Filter</th>
                            <th style="width:50em">Notes</th>
                        </tr>
                    </thead>
                    <tbody xf:repeat-nodeset="instance('global-checksets')/cs:usage/cs:use-group[not(@ref-id = instance('step')/cs:checkset/cs:usage/cs:use-group/@ref-id)]" id="global-checksets">
                        <tr>
                            <td><xf:output ref="@ref-id"/></td>
                            <td>
                                <xf:select1 ref="@type">
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
                            <td><xf:output ref="@title"/></td>
                            <td><xf:output ref="@filter"/></td>
                            <td><xf:output ref="@notes"/></td>
                        </tr>                                
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="4">
                                <!-- tfoot is not working -->
                            </td>
                        </tr>                                
                    </tfoot>
                </table>
                <xf:trigger>
                    <xf:label>Use Ruleset for Checkset</xf:label>
                    <xf:action ev:event="DOMActivate">
                        <xf:insert nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group" at="index('repeatCheckset')" position="after" origin="instance('global-checksets')/cs:usage/cs:use-group[not(@ref-id = instance('step')/cs:checkset/cs:usage/cs:use-group/@ref-id)][index('global-checksets')]"/>
                        <!-- <xf:delete nodeset="instance('global-checksets')/cs:usage/cs:use-group" at="index('global-checksets')"/> -->
                    </xf:action>
                </xf:trigger>

            </div>
        </div>
        <br/>
        <hr/>
        <br/>                    
        <div>
            <b>Additional <a href="../../ruleset/edit.html" target="_blank">Group specific Rulesets</a>:</b>
            <br/>
            <br/>
            <div>
                <table class="tableform">
                    <thead>
                        <tr>
                            <th style="width:15em">ID</th>
                            <th style="width:5em">Type</th>
                            <th style="width:30em">Title</th>
                            <th style="width:20em">Filter</th>
                            <th style="width:50em">Notes</th>
                        </tr>
                    </thead>
                    <tbody xf:repeat-nodeset="instance('group-checksets')/cs:usage/cs:use-group[not(@ref-id = instance('step')/cs:checkset/cs:usage/cs:use-group/@ref-id)]" id="group-checksets">
                        <tr>
                            <td><xf:output ref="@ref-id"/></td>
                            <td>
                                <xf:select1 ref="@type">
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
                            <td><xf:output ref="@title"/></td>
                            <td><xf:output ref="@filter"/></td>
                            <td><xf:output ref="@notes"/></td>
                        </tr>                                
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="4">
                                <!-- tfoot is currently not used -->
                            </td>
                        </tr>                                
                    </tfoot>
                </table>
                <xf:trigger>
                    <xf:label>Use Ruleset for Checkset</xf:label>
                    <xf:action ev:event="DOMActivate">
                        <xf:insert nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group" at="index('repeatCheckset')" position="after" origin="instance('group-checksets')/cs:usage/cs:use-group[not(@ref-id = instance('step')/cs:checkset/cs:usage/cs:use-group/@ref-id)][index('group-checksets')]"/>
                        <!-- <xf:delete nodeset="instance('group-checksets')/cs:usage/cs:use-group" at="index('group-checksets')"/> -->
                    </xf:action>
                </xf:trigger>
            </div>
        </div>
    </div>
};

let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $step := request:get-attribute('step')
let $local-checkset := concat($ct-home-data, '/', $group, "/", "step_", $step, ".xml")
let $group-checkset := concat($ct-home-data, '/', $group, "/", "step.xml")
let $global-checkset := concat($ct-home-data, '/', "step.xml")
let $variables := doc($global-checkset)/cs:checkset-group/cs:variables[@type='GLOBAL']/cs:variable | doc($group-checkset)/cs:checkset-group/cs:variables[@type='GROUP']/cs:variable
let $variables-local := doc($local-checkset)/cs:step/cs:checkset/cs:variables/*
let $config := doc(concat($ct-home-db,'/../checker_config.xml'))
let $filename-pattern := $config/bc:config/bc:set/bc:filename-pattern/text()

return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:cs="http://checker.bintellix.de/checkset/" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <head>
        <link rel="stylesheet" type="text/css" href="{$ct-home-web}/base/checker_tab-menu.css"/>
        <style>   
        .xfFullGroup .xfControl .xfValue {{
            /* width: 100%; */
        }}        
        
        .url .xfValue  {{
            width: 100ex;
        }}
        .name .xfValue  {{
            width: 50ex;
        }}
        .xml .xfValue  {{
            width: 100%;
            cols: 150;
        }}
        .xfControl {{
            display:inline-block;
            zoom:1; /* IE 7 Hack starts here*/
            *display:inline;
            margin: 0 1ex 0 0;
        }}
        .inline {{
            float:left;
        }}
        .inline .xfControl {{
            display:inline-block;
        }}
        textarea {{
            width: 500px;
        }}
        button.xfValue {{
            /* width:15ex; */
        }}
       .widgetContainer {{
            display:block;
        }}
        input {{
            width:100%;
        }}        
        </style> 
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
    </head>
    <menu xmlns="">
        <crosslinks>
            <crosslink url="../../step/{$step}/run.html" title="Run checkset" external="yes"/>
            <crosslink url="../../step/{$step}/{replace(replace($filename-pattern,'\{\$group\}',$group),'\{\$step\}',$step)}" title="Download as XML" external="yes"/>
            <crosslink url="../../ruleset/edit.html" title="Group specific rulesets" external="yes"/>
            <crosslink url="../../../ruleset/edit.html" title="Global rulesets" external="yes"/>
            <crosslink url="../../step/{$step}services.html" title="Services" external="yes"/>
        </crosslinks>
    </menu>
    <body>
        <xf:model id="ConfigModel" schema="{$ct-home-web}/base/checker.xsd">
            <xf:instance xmlns="" id="step">
                <cs:step xmlns:cs="http://checker.bintellix.de/checkset/" version="1">
                    {doc($local-checkset)/cs:step/cs:identity}
                    <cs:checkset xmlns:cs="http://checker.bintellix.de/checkset/" version="1">
                        <cs:variables type="LOCAL">
                            {
                            for $variable-name in distinct-values($variables/@name)
                            return
                                let $variable := $variables[@name=$variable-name][1]
                                return
                                    <cs:variable description="{$variable/@description}" 
                                                 selected="{if ($variables-local[@name=$variable/@name]) then data($variables-local[@name=$variable/@name]/@selected) else $variable/@selected}"
                                                 name="{$variable/@name}"/>
                            }
                        </cs:variables>
                    
                        {doc($local-checkset)/cs:step/cs:checkset/*[not(local-name()= 'variables' and namespace-uri()='http://checker.bintellix.de/checkset/')]}
                    </cs:checkset>
                </cs:step>                    
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
                    <cs:use-group enabled="false" filter="" ref-id="none" title="New"/>
				</copy>
            </xf:instance>

            <xf:instance xmlns="" id="global-checksets">
                <data>
                    <cs:usage>
                        {for $step in doc($global-checkset)/cs:checkset-group/cs:groups/cs:group
                         return
                            <cs:use-group enabled="true" filter="{string($step/@filter)}" ref-id="{string($step/@id)}" type="{string($step/@type)}" title="{string($step/@title)}" notes="{string($step/@notes)}"/>
                        }
                    </cs:usage>
                </data>
            </xf:instance>

            <xf:instance xmlns="" id="group-checksets">
                <data>
                    <cs:usage>
                        {for $step in doc($group-checkset)/cs:checkset-group/cs:groups/cs:group
                         return
                            <cs:use-group enabled="true" filter="{string($step/@filter)}" ref-id="{string($step/@id)}" type="{string($step/@type)}" title="{string($step/@title)}" notes="{string($step/@notes)}"/>
                        }
                    </cs:usage>
                </data>
            </xf:instance>

            <xf:instance xmlns="" id="message">
                <message>
                    <current>
                        <document readonly="true"/>
                        <rest>
                            <url/>
                            <request type="XML">
                                <url>http://</url>
                                <data>&lt;empty/&gt;</data>
                            </request>
                        </rest>
                        <soap>
                            <url/>
                            <request type="XML">
                                <url>http://</url>
                                <data>&lt;empty/&gt;</data>
                            </request>
                        </soap>
                    </current>
                    <master>
                        <document readonly="true"/>
                        <rest>
                            <url/>
                            <request type="XML">
                                <url>http://</url>
                                <data>&lt;empty/&gt;</data>
                            </request>
                        </rest>
                        <soap>
                            <url/>
                            <request type="XML">
                                <url>http://</url>
                                <data>&lt;empty/&gt;</data>
                            </request>
                        </soap>
                    </master>                    
				</message>
            </xf:instance>
            <xf:instance xmlns="" id="variables">
                <variables>{$variables}</variables>
            </xf:instance>

            <xf:instance id="serialize">
                <output:serialization-parameters xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
                    <output:omit-xml-declaration value="yes"/>
                    <output:indent value="yes"/>
                </output:serialization-parameters>
            </xf:instance>

            <xf:instance id="runsets">
                <data xmlns="">
                    <cs:runsets>
                    { 
                        let $runsets := for $i in distinct-values(data(collection(concat($ct-home-data,'/',$group))//cs:runset/@id)[not(.=doc($local-checkset)/cs:step/cs:checkset/cs:runsets/cs:runset/@id)]) order by lower-case($i) return $i
                        for $runset at $pos in $runsets
                        return
                            <cs:runset id="{$runset}" active="yes"/>
                    }
                    </cs:runsets>
                    <new>
                        <cs:runset id="" active="yes"/>
                    </new>
                    <selected>
                        <available/>
                        <used/>
                    </selected>
                </data>
            </xf:instance>
            
            <!--
            <xf:bind ref="instance('message')/current/document" 
                     type="xs:string"
                     calculate="replace(replace(instance('step')/cs:checkset/cs:current/cs:document/cs:data,
                                                                '&amp;lt;','&lt;'),
                                                                '&amp;gt;','&gt;')"
                     ev:event="xforms-recalculate"/>

            <xf:bind ref="instance('message')/master/document" 
                     type="xs:string"
                     calculate="replace(replace(instance('step')/cs:checkset/cs:master/cs:document/cs:data,
                                                                '&amp;lt;','&lt;'),
                                                                '&amp;gt;','&gt;')"
                     ev:event="xforms-recalculate"/>
            -->
            <xf:bind ref="instance('message')/current/soap/url" 
                     type="xs:anyURI"
                     relevant="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type='SOAP'"
                     calculate="replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:url,
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected),
                                                                '&amp;amp;','&amp;')"
                     ev:event="xforms-recalculate"/>

            <xf:bind ref="instance('message')/master/soap/url" 
                     type="xs:anyURI"
                     relevant="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type='SOAP'"
                     calculate="replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:url,
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected),
                                                                '&amp;amp;','&amp;')"
                                                                
                     ev:event="xforms-recalculate"/>

            <xf:bind ref="instance('message')/current/soap/request/data" 
                     type="xs:string"
                     relevant="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type='SOAP'"
                     calculate="replace(replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/cs:data,
                                                                '&amp;lt;','&lt;'),
                                                                '&amp;gt;','&gt;'),
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected)"
                     ev:event="xforms-recalculate"/>

            <xf:bind ref="instance('message')/master/soap/request/data" 
                     type="xs:string"
                     relevant="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type='REST'"
                     calculate="replace(replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/cs:data,
                                                                '&amp;lt;','&lt;'),
                                                                '&amp;gt;','&gt;'),
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected)"
                     ev:event="xforms-recalculate"/>
 
            <xf:bind ref="instance('message')/current/rest/url" 
                     type="xs:anyURI"
                     relevant="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type='REST'"
                     calculate="replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:url,
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected),
                                                                '&amp;amp;','&amp;')"
                     ev:event="xforms-recalculate"/>

           <xf:bind ref="instance('message')/master/rest/url" 
                     type="xs:anyURI"
                     relevant="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type='REST'"
                     calculate="replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:url,
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected),
                                                                '&amp;amp;','&amp;')"
                     ev:event="xforms-recalculate"/>

            <xf:bind ref="instance('message')/current/rest/request/data" 
                     type="xs:string"
                     relevant="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type='REST'"
                     calculate="replace(replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/cs:data,
                                                                '&amp;lt;','&lt;'),
                                                                '&amp;gt;','&gt;'),
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected)"
                     ev:event="xforms-recalculate"/>

            <xf:bind ref="instance('message')/master/rest/request/data" 
                     type="xs:string"
                     relevant="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type='REST'"
                     calculate="replace(replace(replace(replace(replace(replace(replace(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/cs:data,
                                                                '&amp;lt;','&lt;'),
                                                                '&amp;gt;','&gt;'),
                                                                '\{{\$current_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='current_ws']/@selected),
                                                                '\{{\$master_ws\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='master_ws']/@selected),
                                                                '\{{\$senderid\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='senderid']/@selected),
                                                                '\{{\$brand\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='brand']/@selected),
                                                                '\{{\$market_configurator\}}',instance('step')/cs:checkset/cs:variables/cs:variable[@name='market_configurator']/@selected)"
                     ev:event="xforms-recalculate"/>

 
            <xf:submission id="save" method="post" action="edit_save.html" instance="step" replace="none">
            	<xf:action ev:event="xforms-submit-done">
					<xf:message>Successfully saved</xf:message>
				</xf:action>
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
            
            <xf:submission id="load-current-rest" instance="step" replace="text" targetref="/cs:step/cs:checkset/cs:current/cs:document/cs:data" mediatype="text/xml" indent="yes" encoding="utf-8"
                action="{{instance('message')/current/rest/url}}" validate="false">
                <xf:method value="lower-case(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:type/text())"/>
                <xf:action ev:event="xforms-submit-done">
                    <xf:setvalue ref="instance('message')/current/document/@readonly" value="'true'" />
                </xf:action>                 
                <xf:action ev:event="xforms-submit-error">
                    <xf:setvalue ref="instance('message')/current/document/@readonly" value="'true'" />
                    <xf:message>An error occurred:
                        Error Type: 
                        <xf:output value="event('error-type')">
                            <xf:label>Error type</xf:label>
                        </xf:output>
                        Resource URI:
                        <xf:output value="event('resource-uri')">
                            <xf:label>Resource URI</xf:label>
                        </xf:output>
                        Status Code:
                        <xf:output value="event('response-status-code')">
                            <xf:label>Status Code</xf:label>
                        </xf:output>
                        Reason:
                        <xf:output value="event('response-reason-phrase')">
                            <xf:label>Reason</xf:label>
                        </xf:output>
                        Headers:
                        <xf:output value="event('response-headers')">
                            <xf:label>Headers</xf:label>
                        </xf:output>
                        Body:
                        <xf:output value="event('response-body')">
                            <xf:label>Body</xf:label>
                        </xf:output>
                    </xf:message>
                </xf:action>
            </xf:submission>
            
            <xf:submission id="load-master-rest" instance="step" replace="text" targetref="/cs:step/cs:checkset/cs:master/cs:document/cs:data" mediatype="text/xml" indent="yes" encoding="utf-8"
                action="{{instance('message')/master/rest/url}}" validate="false">
                <xf:method value="lower-case(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:type/text())"/>                
                <xf:action ev:event="xforms-submit-done">
                    <xf:setvalue ref="instance('message')/master/document/@readonly" value="'true'" />
                </xf:action>                 
                <xf:action ev:event="xforms-submit-error">
                    <xf:setvalue ref="instance('message')/master/document/@readonly" value="'true'" />
                    <xf:message>An error occurred:
                        Error Type: 
                        <xf:output value="event('error-type')">
                            <xf:label>Error type</xf:label>
                        </xf:output>
                        Resource URI:
                        <xf:output value="event('resource-uri')">
                            <xf:label>Resource URI</xf:label>
                        </xf:output>
                        Status Code:
                        <xf:output value="event('response-status-code')">
                            <xf:label>Status Code</xf:label>
                        </xf:output>
                        Reason:
                        <xf:output value="event('response-reason-phrase')">
                            <xf:label>Reason</xf:label>
                        </xf:output>
                        Headers:
                        <xf:output value="event('response-headers')">
                            <xf:label>Headers</xf:label>
                        </xf:output>
                        Body:
                        <xf:output value="event('response-body')">
                            <xf:label>Body</xf:label>
                        </xf:output>
                    </xf:message>
                </xf:action>
            </xf:submission>
                                    
            <xf:submission id="load-current-soap" method="post" instance="step" replace="text" targetref="/cs:step/cs:checkset/cs:master/cs:document/cs:data" mediatype="text/xml" encoding="utf-8"
                action="{{instance('message')/current/soap/url}}">
                <xf:setvalue ev:event="xforms-submit-serialize" ref="event('submission-body')" value="if (instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/@type='XML') then instance('message')/current/soap/request/data else doc('http://smuc4313.europe.bmw.corp:8090/exist/apps/digital/configurator/cz/bmw/4/global-test?type=SFCalculationRequest&amp;lang=cs&amp;id=Credit&amp;calc=1')"/>
                <xf:header>
                    <xf:name>SOAPAction</xf:name>
                    <xf:value>'http://www.bintellix.com/compare/test/soap'</xf:value>
                </xf:header>
                <xf:action ev:event="xforms-binding-exception">
                    <xf:message>An binding problem occured</xf:message>
                </xf:action>
               <xf:action ev:event="xforms-submit-done">
                    <xf:setvalue ref="instance('message')/current/document/@readonly" value="'true'" />
                </xf:action>
                <xf:action ev:event="xforms-submit-error">
                    <xf:setvalue ref="instance('message')/current/document/@readonly" value="'true'" />                
                    <xf:message>An error occurred:
                        Error Type: 
                        <xf:output value="event('error-type')">
                            <xf:label>Error type</xf:label>
                        </xf:output>
                        Resource URI:
                        <xf:output value="event('resource-uri')">
                            <xf:label>Resource URI</xf:label>
                        </xf:output>
                        Status Code:
                        <xf:output value="event('response-status-code')">
                            <xf:label>Status Code</xf:label>
                        </xf:output>
                        Reason:
                        <xf:output value="event('response-reason-phrase')">
                            <xf:label>Reason</xf:label>
                        </xf:output>
                        Headers:
                        <xf:output value="event('response-headers')">
                            <xf:label>Headers</xf:label>
                        </xf:output>
                        Body:
                        <xf:output value="event('response-body')">
                            <xf:label>Body</xf:label>
                        </xf:output>
                    </xf:message>
                </xf:action>
            </xf:submission>

            <xf:submission id="load-master-soap" method="post" instance="step" replace="text" targetref="/cs:step/cs:checkset/cs:master/cs:document/cs:data" mediatype="text/xml" encoding="utf-8" 
                action="{{instance('message')/master/soap/url}}">
                <xf:setvalue ev:event="xforms-submit-serialize" ref="event('submission-body')" value="if (instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/@type='XML') then instance('message')/current/soap/request/data else ()"/>
                <xf:header>
                    <xf:name>SOAPAction</xf:name>
                    <xf:value>'http://www.bintellix.com/compare/test/soap'</xf:value>
                </xf:header>
                <xf:action ev:event="xforms-binding-exception">
                    <xf:message>An binding problem occured</xf:message>
                </xf:action>
               <xf:action ev:event="xforms-submit-done">
                    <xf:setvalue ref="instance('message')/master/document/@readonly" value="'true'" />
                </xf:action>
                <xf:action ev:event="xforms-submit-error">
                    <xf:setvalue ref="instance('message')/master/document/@readonly" value="'true'" />
                    <xf:message>An error occurred:
                        Error Type: 
                        <xf:output value="event('error-type')">
                            <xf:label>Error type</xf:label>
                        </xf:output>
                        Resource URI:
                        <xf:output value="event('resource-uri')">
                            <xf:label>Resource URI</xf:label>
                        </xf:output>
                        Status Code:
                        <xf:output value="event('response-status-code')">
                            <xf:label>Status Code</xf:label>
                        </xf:output>
                        Reason:
                        <xf:output value="event('response-reason-phrase')">
                            <xf:label>Reason</xf:label>
                        </xf:output>
                        Headers:
                        <xf:output value="event('response-headers')">
                            <xf:label>Headers</xf:label>
                        </xf:output>
                        Body:
                        <xf:output value="event('response-body')">
                            <xf:label>Body</xf:label>
                        </xf:output>
                    </xf:message>
                </xf:action>
            </xf:submission>
            
            <xf:submission id="load-current-file" method="get" replace="all" mediatype="text/xml"
                action="{{replace(translate(instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:file/cs:url, '\', '/'),' ','%20')}}"
                ref="instance('soap')/current/request/data/*">
                <xf:action ev:event="xforms-submit-error">
                    <xf:setvalue ref="instance('message')/current/document/@readonly" value="'true'" />
                    <xf:message>An error occurred:
                        Error Type: 
                        <xf:output value="event('error-type')">
                            <xf:label>Error type</xf:label>
                        </xf:output>
                        Resource URI:
                        <xf:output value="event('resource-uri')">
                            <xf:label>Resource URI</xf:label>
                        </xf:output>
                        Status Code:
                        <xf:output value="event('response-status-code')">
                            <xf:label>Status Code</xf:label>
                        </xf:output>
                        Reason:
                        <xf:output value="event('response-reason-phrase')">
                            <xf:label>Reason</xf:label>
                        </xf:output>
                        Headers:
                        <xf:output value="event('response-headers')">
                            <xf:label>Headers</xf:label>
                        </xf:output>
                        Body:
                        <xf:output value="event('response-body')">
                            <xf:label>Body</xf:label>
                        </xf:output>
                    </xf:message>
                </xf:action>
            </xf:submission>

            <xf:submission id="load-master-file" method="get" replace="all" mediatype="text/xml"
                action="{{replace(translate(instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:file/cs:url, '\', '/'),' ','%20')}}"
                ref="instance('soap')/master/request/data/*">
                <xf:action ev:event="xforms-submit-error">
                    <xf:setvalue ref="instance('message')/master/document/@readonly" value="'true'" />
                    <xf:message>An error occurred:
                        Error Type: 
                        <xf:output value="event('error-type')">
                            <xf:label>Error type</xf:label>
                        </xf:output>
                        Resource URI:
                        <xf:output value="event('resource-uri')">
                            <xf:label>Resource URI</xf:label>
                        </xf:output>
                        Status Code:
                        <xf:output value="event('response-status-code')">
                            <xf:label>Status Code</xf:label>
                        </xf:output>
                        Reason:
                        <xf:output value="event('response-reason-phrase')">
                            <xf:label>Reason</xf:label>
                        </xf:output>
                        Headers:
                        <xf:output value="event('response-headers')">
                            <xf:label>Headers</xf:label>
                        </xf:output>
                        Body:
                        <xf:output value="event('response-body')">
                            <xf:label>Body</xf:label>
                        </xf:output>
                    </xf:message>
                </xf:action>
            </xf:submission>

            <xf:bind nodeset="instance('step')/cs:step/cs:step-order" type="xs:positiveInteger"/>
            <xf:bind nodeset="instance('step')/cs:step/cs:notes" type="xs:string" required="true()"/>
            

            <xf:bind nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group/@id" type="xs:ID"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group/@type" readonly="true()"/>

            <!-- <xf:bind nodeset="/@id" type="string" constraint="string-length(.) &gt; 2" required="true()"/> -->
            <!--
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/xs:cml" type="xs:any"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/xs:cml" type="xs:any"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/cs:data" type="xs:any"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/cs:data" type="xs:any"/>
            -->
            <xf:bind nodeset="instance('step')/cs:checkset/cs:usage/cs:use-group/@enabled" type="xs:boolean"/>

            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:document/cs:data" readonly="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type!='XML' and instance('message')/current/document/@readonly='true'" enabled="true"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:file"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:file/cs:url" calculate="normalize-space(.)" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:url" calculate="normalize-space(.)" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:action" calculate="normalize-space(.)" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/@type" type="cs:RequestTypeType" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/cs:url" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/cs:data"  required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:url" calculate="normalize-space(.)" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:type" calculate="normalize-space(.)" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/@type" type="cs:RequestTypeType" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/cs:url" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/cs:data" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:xml"/>

            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:document/cs:data" readonly="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type!='XML' and instance('message')/master/document/@readonly='true'" enabled="true"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:file"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:file/cs:url" calculate="normalize-space(.)" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:url" calculate="normalize-space(.)" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:action" calculate="normalize-space(.)" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/type" type="cs:RequestTypeType" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/cs:url" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/cs:data" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:url" calculate="normalize-space(.)" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:type" calculate="normalize-space(.)" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/@type" type="cs:RequestTypeType" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/cs:url" type="cs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/cs:data" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:xml"/>

            <!-- <xf:setvalue ev:event="xforms-model-construct-done" ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:file/cs:url" value="normalize-space(.)"/> --> 
            
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:document/cs:validate/cs:schema/@active" type="xs:boolean" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:document/cs:validate/cs:schema/cs:url" type="xs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:validate/cs:schema/@active" type="xs:boolean" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:validate/cs:schema/cs:url" type="xs:anyURI" required="true()"/>

            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:document/cs:validate/cs:schema/@active" type="xs:boolean" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:document/cs:validate/cs:schema/cs:url" type="xs:anyURI" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:validate/cs:schema/@active" type="xs:boolean" required="true()"/>
            <xf:bind nodeset="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:validate/cs:schema/cs:url" type="xs:anyURI" required="true()"/>
            
            <xf:bind id="checkset-move-up" nodeset="instance('copy')/checkset/move-up" readonly="index('repeatCheckset') = 1"/> 
			<xf:bind id="checkset-move-down" nodeset="instance('copy')/checkset/move-down" readonly="index('repeatCheckset') = count(instance('step')/cs:checkset/cs:usage/cs:use-group)"/>
            <xf:bind id="check-move-up" nodeset="instance('copy')/check/move-up" readonly="index('repeatCheck') = 1"/> 
			<xf:bind id="check-move-down" nodeset="instance('copy')/check/move-down" readonly="index('repeatCheck') = instance('step')/cs:checkset/cs:usage/cs:use-group[index('repeatCheckset')]/cs:checks/cs:check"/>

            <xf:bind nodeset="instance('group-checksets')/cs:usage/cs:use-group/@type" readonly="true()"/>
            <xf:bind nodeset="instance('global-checksets')/cs:usage/cs:use-group/@type" readonly="true()"/>
            
        </xf:model>  
		
		<div>
		  <div style="float:left;">
		    <div style="float:left; vertical-align:top;">
                <xf:submit submission="save" id="Save">
                    <xf:label>Save</xf:label>
                </xf:submit>
                </div>
                <div class="Status">Invalid data</div>
                <span>&#160;&#160;</span>
                <div class="step-info" style="float:left;">
                    <xf:textarea ref="instance('step')/cs:identity/cs:notes">
                        <xf:label>Notes</xf:label>
                    </xf:textarea>
                    <xf:input ref="instance('step')/cs:identity/cs:step-order">
                        <xf:label>Order</xf:label>
                    </xf:input>
                </div>
           </div>
       </div>
        <br style="clear:both"/>       
        <br />  
        
        <div class="horiz-tab-menu">
            <xf:trigger id="t-case-1" appearance="minimal">
                <xf:label>Current</xf:label>
                <xf:toggle case="case-1" ev:event="DOMActivate"/>
                <!--
                <xf:load show="embed" targetid="xforms">
                    <xf:resource value="'InputText.xhtml#xforms'"/>
                </xf:load>
                -->                
            </xf:trigger>
            <xf:trigger id="t-case-2" appearance="minimal">
                <xf:label>Reference</xf:label>
                <xf:toggle case="case-2" ev:event="DOMActivate"/>
            </xf:trigger>
            <xf:trigger id="t-case-3" appearance="minimal">
                <xf:label>Rulesets</xf:label>
                <xf:toggle case="case-3" ev:event="DOMActivate"/>
            </xf:trigger>
            <xf:trigger id="t-case-4" appearance="minimal">
                <xf:label>Runsets</xf:label>
                <xf:toggle case="case-4" ev:event="DOMActivate"/>
            </xf:trigger>
            <xf:trigger id="t-case-5" appearance="minimal">
                <xf:label>Variables</xf:label>
                <xf:toggle case="case-5" ev:event="DOMActivate"/>
            </xf:trigger>
        </div>
        
        <xf:switch>
            <xf:case id="case-1" selected="true">
                <div id="div-1"> <!-- $('div input:has(.xfRequiredEmpty)').addClass('xfInvalidCase');" -->
                    <div class="headline">
                        <b>Current  (Live data) &#8211; </b>
                        <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@name"/>
                    </div>
                    <div class="horiz-tab-menu">
                        <xf:trigger id="t-case-1-2" appearance="minimal">
                            <xf:label>Document Origin</xf:label>
                            <xf:toggle case="case-1-2" ev:event="DOMActivate"/>
                        </xf:trigger>
                        <xf:trigger id="t-case-1-1" appearance="minimal">
                            <xf:label>Used Document (for check)</xf:label>
                            <xf:toggle case="case-1-1" ev:event="DOMActivate"/>
                            <!-- <xf:setvalue ref="instance('navigation')/actual" value="'1'"/> -->
                        </xf:trigger>
                    </div>
                    <div class="tab-elements">
                        <xf:switch>
                            <xf:case id="case-1-1">
                                <xf:label>Used Document</xf:label>
                                <div class="caseContent">
                                    <xf:group appearance="full">
                                        <div class="inline caseContent">
                                            <xf:input ref="instance('step')/cs:checkset/cs:current/cs:document/cs:validate/cs:schema/@active">
                                                <xf:label>Validate Doc</xf:label>
                                            </xf:input>
                                            <xf:group ref="instance('step')/cs:checkset/cs:current/cs:document/cs:validate/cs:schema[@active='true']">
                                                <xf:input ref="instance('step')/cs:checkset/cs:current/cs:document/cs:validate/cs:schema/cs:url" class="url">
                                                    <xf:label>using schema URL:</xf:label>
                                                    <xf:hint>http://www.example/schema.xsd</xf:hint>
                                                </xf:input>
                                            </xf:group>
                                        </div>
                                    </xf:group>
                      
                                    <xf:group appearance="full">
                                        <div class="inline">
                                            <xf:textarea ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" class="xml" rows="40" cols="150" mediatype="application/xml">
                                                <xf:label>Document:</xf:label>
                                            </xf:textarea>                                           
                                          
                                            <!-- <xf:textarea ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="serialize(., instance('serialize')" mediatype="text/plain"/> -->
                                            <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='SOAP']"> 
                                                <xf:output  value="'Document static (plain XML)'"/>
                                            </xf:group>
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='FILE']">
                                                <xf:label>Update Document (from File)</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-current-file"/>
                                            </xf:trigger>
                                                                                        
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='SOAP']">
                                                <xf:label>Update Document (via SOAP)</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-current-soap"/>
                                            </xf:trigger>
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='REST']">
                                                <xf:label>Update Document (via REST)</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-current-rest"/>
                                            </xf:trigger>
    
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[not(@type='XML')]">
                                                <xf:label>Clean document cache</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'true'" />                                              
                                            </xf:trigger>                                 
                                        </div>                                        
                                    </xf:group>
                                </div>
                            </xf:case>
                            <xf:case id="case-1-2" selected="true">
                                <xf:label>Document Origin</xf:label>
                                <div class="caseContent">
                                    <xf:group appearance="full">
                                        <xf:select1 ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/@type" appearance="simple" incremental="true">
                                            <xf:label>Document origin:</xf:label>
                                            <xf:item>
                                                <xf:label>plain XML</xf:label>
                                                <xf:value>XML</xf:value> 
                                            </xf:item>
                                            <xf:item>
                                                <xf:label>load XML from File</xf:label>
                                                <xf:value>FILE</xf:value>
                                            </xf:item> 
                                            <xf:item>
                                                <xf:label>get XML from SOAP service</xf:label>
                                                <xf:value>SOAP</xf:value>
                                            </xf:item> 
                                            <xf:item>
                                                <xf:label>get XML from REST service</xf:label>
                                                <xf:value>REST</xf:value>
                                            </xf:item>
                                        </xf:select1>
                                    </xf:group>                    
    
                                    <xf:group appearance="full" ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[not(@type='XML')]">
                                        <div class="inline">
                                            <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:validate/cs:schema/@active">
                                                <xf:label>Validate Doc</xf:label>
                                            </xf:input>
                                            <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:validate/cs:schema[@active='true']">
                                                <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:validate/cs:schema/cs:url" class="url">
                                                    <xf:label>using schema URL:</xf:label>
                                                    <xf:hint>http://www.example/schema.xsd</xf:hint>                                                
                                                </xf:input>
                                            </xf:group>
                                        </div>
                                    </xf:group>
    
                                    <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='SOAP']" appearance="full">
                                        <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:url" class="url" incremental="true">
                                            <xf:label>SOAP URL:</xf:label>
                                        </xf:input>
                                        <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:action" class="url" incremental="true">
                                            <xf:label>SOAP Action:</xf:label>
                                        </xf:input>
                                        <xf:select1 ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/@type" appearance="simple" incremental="true">
                                            <xf:label>SOAP Request Type:</xf:label>
                                            <xf:item>
                                                <xf:label>static XML</xf:label>
                                                <xf:value>XML</xf:value> 
                                            </xf:item>
                                            <xf:item>
                                                <xf:label>dynamic XML (using HTTP request)</xf:label>
                                                <xf:value>HTTP</xf:value> 
                                            </xf:item>
                                        </xf:select1>
                                        <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/@type[.='XML']">
                                            <xf:textarea ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/cs:data" class="xml" rows="40" cols="150" incremental="true">
                                                <xf:label>SOAP Request:</xf:label>
                                            </xf:textarea>
                                        </xf:group>
                                        <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/@type[.='HTTP']">
                                            <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:soap/cs:request/cs:url" incremental="true">
                                                <xf:label>HTTP URL to load SOAP Request:</xf:label>
                                            </xf:input>
                                        </xf:group>
                                        <xf:trigger appearance="normal">
                                            <xf:label>Send SOAP Request</xf:label>
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                            <xf:send ev:event="DOMActivate" submission="load-current-soap"/>
                                            <xf:toggle case="case-1-1" ev:event="DOMActivate"/>
                                        </xf:trigger>  
                    	                <xf:output value="replace(instance('soap')/current/url,'&amp;amp;','&amp;')" incremental="true"/>
                                    </xf:group>
                                    <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='REST']" appearance="full">
                                        <xf:select1 ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:type" appearance="simple" incremental="true">
                                            <xf:label>REST Type:</xf:label>
                                            <xf:item>
                                                <xf:label>using GET</xf:label>
                                                <xf:value>GET</xf:value> 
                                            </xf:item>
                                            <xf:item>
                                                <xf:label>using POST</xf:label>
                                                <xf:value>POST</xf:value> 
                                            </xf:item>
                                        </xf:select1>
                                        <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:url" class="url">
                                            <xf:label>REST URL:</xf:label>
                                        </xf:input>
                                                                            
                                        <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:type[.='POST']">
                                            <xf:select1 ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/@type" appearance="simple" incremental="true">
                                                <xf:label>REST Message Type:</xf:label>
                                                <xf:item>
                                                    <xf:label>static XML</xf:label>
                                                    <xf:value>XML</xf:value> 
                                                </xf:item>
                                                <xf:item>
                                                    <xf:label>dynamic XML (using HTTP request)</xf:label>
                                                    <xf:value>HTTP</xf:value> 
                                                </xf:item>
                                            </xf:select1>
                                            <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/@type[.='XML']">
                                                <xf:textarea ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/cs:data" class="xml" rows="40" cols="150" incremental="true">
                                                    <xf:label>REST Message:</xf:label>
                                                </xf:textarea>
                                            </xf:group>
                                            <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/@type[.='HTTP']">
                                                <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:rest/cs:request/cs:url" incremental="true">
                                                    <xf:label>HTTP URL to load REST Message:</xf:label>
                                                </xf:input>
                                            </xf:group>
                                        </xf:group>
                                        
                                        <xf:trigger appearance="normal">
                                            <xf:label>Send REST Request</xf:label>
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                            <xf:send ev:event="DOMActivate" submission="load-current-rest"/>
                                            <xf:toggle case="case-1-1" ev:event="DOMActivate"/>
                                        </xf:trigger>
                                    </xf:group>
                                    <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='FILE']" appearance="full">
                                        <xf:input ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection/cs:file/cs:url" class="url">
                                            <xf:label>File URL:</xf:label>
                                        </xf:input>
                		                <xf:trigger appearance="normal">
                                            <xf:label>Display File</xf:label>
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('message')/current/document/@readonly" value="'false'" />                                              
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" value="''" />
                                            <xf:send ev:event="DOMActivate" submission="load-current-file"/>
                                            <xf:toggle case="case-1-1" ev:event="DOMActivate"/>
                                        </xf:trigger>
                                    </xf:group>
<!--
                                    <xf:group ref="instance('step')/cs:checkset/cs:current/cs:connections/cs:connection[@type='XML']" appearance="full">
                                        <xf:textarea ref="instance('step')/cs:checkset/cs:current/cs:document/cs:data" class="xml" rows="40" cols="150" incremental="true">
                                            <xf:label>XML Document:</xf:label>
                                        </xf:textarea>
                                    </xf:group>
-->
                                </div>
                            </xf:case>
                        </xf:switch>
                    </div>
                </div>
            </xf:case>
            <xf:case id="case-2">
                <div id="div-2">
                    <div class="headline">
                        <b>Reference (Master data) &#8211; </b>
                        <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@name"/>
                    </div>
                    <div class="horiz-tab-menu">
                        <xf:trigger id="t-case-2-2" appearance="minimal">
                            <xf:label>Document Origin</xf:label>
                            <xf:toggle case="case-2-2" ev:event="DOMActivate"/>
                        </xf:trigger>
                        <xf:trigger id="t-case-2-1" appearance="minimal">
                            <xf:label>Used Document (for check)</xf:label>
                            <xf:toggle case="case-2-1" ev:event="DOMActivate"/>
                        </xf:trigger>
                    </div>
                    <div class="tab-elements">
                        <xf:switch>
                            <xf:case id="case-2-1">
                                <xf:label>Used Document</xf:label>                            
                                <div class="caseContent">
                                    <xf:group appearance="full">
                                        <div class="inline">
                                            <xf:input ref="instance('step')/cs:checkset/cs:master/cs:document/cs:validate/cs:schema/@active">
                                                <xf:label>Validate Doc</xf:label>
                                            </xf:input>
                                            <xf:group ref="instance('step')/cs:checkset/cs:master/cs:document/cs:validate/cs:schema[@active='true']">
                                                <xf:input ref="instance('step')/cs:checkset/cs:master/cs:document/cs:validate/cs:schema/cs:url" class="url">
                                                    <xf:label>using schema URL:</xf:label>
                                                    <xf:hint>http://www.example/schema.xsd</xf:hint>                                                
                                                </xf:input>
                                            </xf:group>
                                        </div>
                                    </xf:group>
    
                                    <xf:group appearance="full">
                                        <div class="inline">
                                            <xf:textarea ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" class="xml" rows="40" cols="150">
                                                <xf:label>Document:</xf:label>
                                            </xf:textarea>
                                            <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='XML']"> 
                                                <xf:output  value="'Document static (plain XML)'"/>
                                            </xf:group>
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='FILE']">
                                                <xf:label>Load Document (from file)</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-master-file"/>
                                            </xf:trigger>
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='SOAP']">
                                                <xf:label>Update Document (via SOAP)</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-master-soap"/>
                                            </xf:trigger>
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='REST']">
                                                <xf:label>Update Document (via REST)</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-master-rest"/>
                                            </xf:trigger>
                                            <xf:trigger ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[not(@type='XML')]">
                                                <xf:label>Clean document cache</xf:label>
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                                <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                                <xf:send ev:event="DOMActivate" submission="load-master-xml"/>
                                            </xf:trigger>
                                        </div>
                                    </xf:group>
                                </div>
                            </xf:case>                            
                            <xf:case id="case-2-2" selected="true">
                                <xf:label>Document Origin</xf:label>
                                <div class="caseContent">
                                    <xf:group appearance="full">
                                        <xf:select1 ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/@type" appearance="simple" incremental="true">
                                            <xf:label>Document origin:</xf:label>
                                            <xf:item>
                                                <xf:label>plain XML</xf:label>
                                                <xf:value>XML</xf:value> 
                                            </xf:item>
                                            <xf:item>
                                                <xf:label>load XML from File</xf:label>
                                                <xf:value>FILE</xf:value>
                                            </xf:item> 
                                             <xf:item>
                                                <xf:label>get XML from SOAP service</xf:label>
                                                <xf:value>SOAP</xf:value>
                                            </xf:item> 
                                            <xf:item>
                                                <xf:label>get XML from REST service</xf:label>
                                                <xf:value>REST</xf:value>
                                            </xf:item>
                                        </xf:select1>
                                    </xf:group>
                                    
                                    <xf:group appearance="full" ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[not(@type='XML')]">
                                        <div class="inline">
                                            <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:validate/cs:schema/@active">
                                                <xf:label>Validate request</xf:label>
                                            </xf:input>
                                            <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:validate/cs:schema[@active='true']">
                                                <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:validate/cs:schema/cs:url" class="url">
                                                    <xf:label>using schema URL:</xf:label>
                                                    <xf:hint>http://www.example/schema.xsd</xf:hint>                                            
                                                </xf:input>
                                            </xf:group>
                                        </div>
                                    </xf:group>
                                    
                                    <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='SOAP']" appearance="full">
                                        <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:url" class="url" incremental="true">
                                            <xf:label>SOAP URL:</xf:label>
                                        </xf:input>
                                        <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:action" class="url" incremental="true">
                                            <xf:label>SOAP Action:</xf:label>
                                        </xf:input>
                                        <xf:select1 ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/@type" appearance="simple" incremental="true">
                                            <xf:label>SOAP Request Type:</xf:label>
                                            <xf:item>
                                                <xf:label>static XML</xf:label>
                                                <xf:value>XML</xf:value> 
                                            </xf:item>
                                            <xf:item>
                                                <xf:label>dynamic XML (using HTTP request)</xf:label>
                                                <xf:value>HTTP</xf:value> 
                                            </xf:item>
                                        </xf:select1>
                                        <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/@type[.='XML']">
                                            <xf:textarea ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/cs:data" class="xml" rows="40" cols="150" incremental="true">
                                                <xf:label>SOAP Request:</xf:label>
                                            </xf:textarea>
                                        </xf:group>
                                        <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/@type[.='HTTP']">
                                            <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:soap/cs:request/cs:url" incremental="true">
                                                <xf:label>HTTP URL to load SOAP Request:</xf:label>
                                            </xf:input>
                                        </xf:group>
                                        <xf:trigger appearance="normal">
                                            <xf:label>Send SOAP Request</xf:label>
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                            <xf:send ev:event="DOMActivate" submission="load-master-soap"/>
                                            <xf:toggle case="case-2-1" ev:event="DOMActivate"/>
                                        </xf:trigger>
                		                <xf:output value="replace(instance('soap')/master/url,'&amp;amp;','&amp;')" incremental="true"/>
                                    </xf:group>
                                    <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='REST']" appearance="full">
                                        <xf:select1 ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:type" appearance="simple" incremental="true">
                                            <xf:label>REST Type:</xf:label>
                                            <xf:item>
                                                <xf:label>using GET</xf:label>
                                                <xf:value>GET</xf:value> 
                                            </xf:item>
                                            <xf:item>
                                                <xf:label>using POST</xf:label>
                                                <xf:value>POST</xf:value> 
                                            </xf:item>
                                        </xf:select1>
                                        <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:url" class="url">
                                            <xf:label>REST URL:</xf:label>
                                        </xf:input>
                                        <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:type[.='POST']">
                                            <xf:select1 ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/@type" appearance="simple" incremental="true">
                                                <xf:label>REST Message Type:</xf:label>
                                                <xf:item>
                                                    <xf:label>static XML</xf:label>
                                                    <xf:value>XML</xf:value> 
                                                </xf:item>
                                                <xf:item>
                                                    <xf:label>dynamic XML (using HTTP request)</xf:label>
                                                    <xf:value>HTTP</xf:value> 
                                                </xf:item>
                                            </xf:select1>
                                            <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/@type[.='XML']">
                                                <xf:textarea ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/cs:data" class="xml" rows="40" cols="150" incremental="true">
                                                    <xf:label>REST Message:</xf:label>
                                                </xf:textarea>
                                            </xf:group>
                                            <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/@type[.='HTTP']">
                                                <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:rest/cs:request/cs:url" incremental="true">
                                                    <xf:label>HTTP URL to load REST Message:</xf:label>
                                                </xf:input>
                                            </xf:group>
                                        </xf:group>
                                        <xf:trigger appearance="normal">
                                            <xf:label>Send REST Request</xf:label>
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                            <xf:send ev:event="DOMActivate" submission="load-master-rest"/>
                                            <xf:toggle case="case-2-1" ev:event="DOMActivate"/>
                                        </xf:trigger>
                                    </xf:group>
                                    <xf:group ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection[@type='FILE']" appearance="full">
                                        <xf:input ref="instance('step')/cs:checkset/cs:master/cs:connections/cs:connection/cs:file/cs:url" class="url">
                                            <xf:label>File URL:</xf:label>
                                        </xf:input>
                                        <xf:trigger appearance="normal">
                                            <xf:label>Display File</xf:label>
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('message')/master/document/@readonly" value="'false'" />                                              
                                            <xf:setvalue ev:event="DOMActivate" ref="instance('step')/cs:checkset/cs:master/cs:document/cs:data" value="''" />
                                            <xf:send ev:event="DOMActivate" submission="load-master-file"/>
                                            <xf:toggle case="case-2-1" ev:event="DOMActivate"/>
                                        </xf:trigger>                       
                                    </xf:group>
                                </div>
                            </xf:case>
                        </xf:switch>
                    </div>
                </div>
            </xf:case>
            <xf:case id="case-3">
                <div id="div-3">
                    <div class="headline">
                        <b>Mapped Rulesets</b>
                    </div>
                    <br/>
                    <br/>
                    {local:editRulesets('')}
                </div>
            </xf:case>
            <xf:case id="case-4">
                <div id="div-4">
                    <subtitle>Mapped Rulesets</subtitle>
                    <table>
                        <tr>
                            <th>Available</th>
                            <th>Action</th>
                            <th>Used</th>
                        </tr>
                        <tr>
                            <td>
                                <xf:select1 id="runsets_availabe" ref="instance('runsets')/selected/available" selection="closed" appearance="compact" incremental="true" >
                                   <xf:itemset nodeset="instance('runsets')/cs:runsets/cs:runset">
                                     <xf:label ref="@id"/>
                                     <xf:value ref="@id"/>
                                   </xf:itemset>
                                </xf:select1>
                            </td>
                            <td style="display:inline-block">                    
                                <xf:trigger>
                                    <xf:label>
                                        <xf:output value="concat('◄&#160;',instance('runsets')/selected/used)"/>
                                    </xf:label>
                                    <xf:action ev:event="DOMActivate" if="instance('runsets')/selected/used != ''">
                                        <xf:insert origin="instance('step')/cs:checkset/cs:runsets/cs:runset[@id=instance('runsets')/selected/used]" context="instance('runsets')/cs:runsets" nodeset="cs:runset"/>
                                        <xf:delete ref="instance('step')/cs:checkset/cs:runsets/cs:runset[@id=instance('runsets')/selected/used]"/>
                                        <xf:setvalue ref="instance('runsets')/selected/used/text()" value="''"/>
                                    </xf:action>
                                </xf:trigger>
                                <br/>
                                <xf:trigger>
                                    <xf:label>
                                        <xf:output value="concat(instance('runsets')/selected/available,'&#160;►')"/>
                                    </xf:label>
                                    <xf:action ev:event="DOMActivate" if="instance('runsets')/selected/available != ''">
                                        <xf:insert origin="instance('runsets')/cs:runsets/cs:runset[@id=instance('runsets')/selected/available]" context="instance('step')/cs:checkset/cs:runsets" nodeset="cs:runset"/>
                                        <xf:delete ref="instance('runsets')/cs:runsets/cs:runset[@id=instance('runsets')/selected/available]"/>
                                        <xf:setvalue ref="instance('runsets')/selected/available/text()" value="''"/>
                                    </xf:action>
                                </xf:trigger>
                                <br/>
                                <xf:input ref="instance('runsets')/new/cs:runset/@id"/>
                                <xf:trigger if="instance('runsets')/new/cs:runset/@id != ''">
                                    <xf:label>Add</xf:label>
                                    <xf:action ev:event="DOMActivate">
                                        <xf:insert origin="instance('runsets')/new/cs:runset" context="instance('step')/cs:checkset/cs:runsets" nodeset="cs:runset"/>
                                        <xf:setvalue ref="instance('runsets')/new/cs:runset/@id" value="''"/>
                                    </xf:action>
                                </xf:trigger>
                            </td>
                            <td>
                                <xf:select1 id="runsets_used" ref="instance('runsets')/selected/used" selection="closed" appearance="compact" incremental="true" >
                                   <xf:itemset nodeset="instance('step')/cs:checkset/cs:runsets/cs:runset">
                                     <xf:label ref="@id"/>
                                     <xf:value ref="@id"/>
                                   </xf:itemset>
                                </xf:select1>
                            </td>
                        </tr>
                    </table>
                </div>
            </xf:case>
            <xf:case id="case-5">
                <div id="div-5">
                    <div class="headline">
                        <b>Used Variables</b>
                    </div>
                    <div id="Variables">
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Selection</th>
                                    <th>Value</th>
                                </tr>
                            </thead>                        
                            <tbody>
                                { for $variable in $variables
                                    return
                                    <tr>
                                        <td>{data($variable/@name)}</td>
                                        <td>                        
                                            <xf:select1 ref="instance('step')/cs:checkset/cs:variables/cs:variable[@name='{$variable/@name}']/@selected" incremental="true">
                                                { for $value in $variable/cs:values/cs:value
                                                    return
                                                    <xf:item>
                                                        <xf:label>{data($value/@description)}</xf:label>
                                                        <xf:value>{data($value/@value)}</xf:value>
                                                    </xf:item>    
                                                }
                                            </xf:select1>
                                        </td>
                                        <td>
                                            <xf:output ref="instance('step')/cs:checkset/cs:variables/cs:variable[@name='{$variable/@name}']/@selected" style="color:#999"/>
                                        </td>
                                    </tr>                        
                                }
                            </tbody>
                        </table>
                    </div>
                    <br style="clear:both;"/>
                </div>
            </xf:case>            
        </xf:switch>
    </body>
</html>