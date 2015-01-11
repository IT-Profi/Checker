xquery version "3.0";
module namespace run="http://checker.bintellix.de/";

declare namespace cs="http://checker.bintellix.de/checkset/";
declare namespace bc="http://checker.bintellix.de/";

import module namespace process="http://exist-db.org/xquery/process" at "java:org.exist.xquery.modules.process.ProcessModule";

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


declare function local:join-variables($variables as node(), $quoting-symbol as xs:string?)
{
  for $variable in $variables/cs:variable
    return
        concat($quoting-symbol,$variable/@name,'=',$variable/@selected,$quoting-symbol)
};

declare function run:run($group as xs:string, $step as xs:string, $cmd-path as xs:string, $cmd-file as xs:string, $uri as xs:anyURI, $ct-home-web as xs:string, $ct-home-db as xs:string, $ct-home-data as xs:string, $debug as xs:integer)
{
let $options := 
<option>
    <workingDir>{$cmd-path}</workingDir>
    <environment>
        <env name="group" value="{$group}"/>
        <env name="step" value="{$step}"/>
    </environment>
    <stdin>
        <line>line</line>
    </stdin>
</option>

let $xslt_exec_result :=
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="execution[exitCode != 0]">        
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="line">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="node()|@*" priority="-1">
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>
</xsl:stylesheet>

let $step-file-global := concat($ct-home-data,'/step.xml')
let $step-file-group := concat($ct-home-data,'/',$group,'/step.xml')
let $step-file-local := concat($ct-home-data,'/',$group,'/step_',$step,'.xml')
let $quoting-symbol := doc(concat($ct-home-db,'/../checker_config.xml'))/bc:config/bc:cmd/bc:quoting-symbol/text()

let $parameter-list := local:join-variables(
    <cs:variables>
        <cs:variable name="root" selected="{concat($uri,$ct-home-web,'/')}"/>
        <cs:variable name="group" selected="{$group}"/>
        <cs:variable name="step" selected="{$step}"/>
        <cs:variable name="format" selected="xml"/>
        <cs:variable name="debug" selected="{$debug}"/>
    </cs:variables>, $quoting-symbol)

let $step_global := doc($step-file-global)
let $step_group := doc($step-file-group)
let $step_local := doc($step-file-local)
let $variables := (local:join-variables($step_local/cs:step/cs:checkset/cs:variables, $quoting-symbol)) 
                  (: local:join-variables($step_global/cs:checkset-group/cs:variables, $quoting-symbol),
                   local:join-variables($step_group/cs:checkset-group/cs:variables, $quoting-symbol)
                   :)

let $parameter := if (empty($variables)) then string-join($parameter-list,';')
                  else concat(string-join($parameter-list,';'),';',string-join($variables,';'))
let $result :=
    try {
        process:execute((concat($cmd-path,if (contains($cmd-path,'\')) then '\' else '/',$cmd-file), fn:tokenize($parameter,';')), $options)
    }
    catch * {
        <error>Execution failed: <br/>Code: {$err:code}<br/>  Description: {$err:description}<br/> Value: {$err:value}</error>
    }

let $result2 := transform:transform($result, $xslt_exec_result, ())
let $result := 
    <cs:step xmlns:cs="http://checker.bintellix.de/checkset/" version="1">
        {$step_local/cs:step/cs:identity}
        {if ($result/@exitCode !=0 or not(starts-with($result2, '<'))) then 
            <cs:run timestamp="{current-dateTime()}">
                <cs:result status="error" note="Unknwwn error">{$result}</cs:result>
            </cs:run>
         else
            let $result := util:parse($result2)
            return
                if ($result/cs:run/cs:result) then
                    let $parameters := <parameters>
                            <param name="CurrentValidateDisabled" value="'no'"/>
                            <param name="CurrentCheckDisabled" value="'no'"/>
                            <param name="CurrentCompareDisabled" value="'no'"/>
                            <param name="MasterValidateDisabled" value="'no'"/>
                            <param name="MasterCheckDisabled" value="'no'"/>
                            <param name="MasterCompareDisabled" value="'no'"/>
                        </parameters>
                    let $xslt_report_status := doc(concat($ct-home-db,'/checkset/checkset_result_status.xsl'))
                    let $status := transform:transform($result, $xslt_report_status, $parameters)
                    return
                        <cs:run timestamp="{$status/@timestamp}">
                            <cs:result status="{if (not($status//cs:current/cs:schema/@status=('fine','disabled')) or 
                                                    not($status//cs:current/cs:cleanup/@status=('fine','disabled')) or 
                                                    not($status//cs:current/cs:validate/@status=('fine','disabled')) or 
                                                    not($status//cs:current/cs:compare/@status=('fine','disabled')) or
                                                    not($status//cs:master/cs:schema/@status=('fine','disabled')) or 
                                                    not($status//cs:master/cs:cleanup/@status=('fine','disabled')) or 
                                                    not($status//cs:master/cs:validate/@status=('fine','disabled')) or 
                                                    not($status//cs:master/cs:compare/@status=('fine','disabled'))
                                                    ) then 'failed' else 'success'}">
                                {$status/cs:result/*}
                            </cs:result>
                        </cs:run>
                else 
                    <cs:run timestamp="{current-dateTime()}">
                        <cs:result status="error" note="Execution error">{$result}</cs:result>
                    </cs:run>
        }
    </cs:step>
let $store := xmldb:store(concat($ct-home-data,'/',$group,'/result'), concat('step_',$step,'.xml'), $result)
return
    $result

};

(:
let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-parameter('group', '')
let $step := request:get-parameter('step', '')
let $cmd-path := request:get-attribute('cmd-path')
let $cmd-file := request:get-attribute('cmd-file')
let $uri := request:get-attribute('uri')

let $result := run:run($group, $step, $cmd-path, $cmd-file, $uri, $ct-home-web, $ct-home-db, $ct-home-data)
return $result
:)
