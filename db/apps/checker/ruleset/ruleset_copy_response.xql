xquery version "3.0";
declare namespace xdb="http://exist-db.org/xquery/xmldb";
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

let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-data := request:get-attribute('ct-home-ata')
let $type := request:get-parameter('type', '')[1]
let $dest_type := request:get-parameter('dest_type', '')
let $group := request:get-parameter('group', '')[1]
let $dest_group := request:get-parameter('dest_group', '')
let $ruleset-id := request:get-parameter('ruleset', '')
(: let $dest_ruleset-id := request:get-parameter('dest_ruleset', '') :)
let $dest_ruleset-id := $ruleset-id

let $checkset := request:get-parameter('checkset', '')
let $ruleset-file := 
    if ($type="global") then concat($ct-home-data, "/", "step.xml")
    else if ($type="group") then concat($ct-home-data, "/", $group, "/", "step.xml")
    else concat($ct-home-data, "/", $group, "/", "checkset_", $checkset, ".xml")
let $dest_ruleset-file := 
    if ($dest_type="global") then concat($ct-home-data, "/", "step.xml")
    else if ($dest_type="group") then concat($ct-home-data, "/", $group, "/", "step.xml")
    else concat($ct-home-data, "/", $group, "/", "checkset_", $checkset, ".xml")
    
let $ruleset := doc($ruleset-file)/cs:step/cs:checkset/cs:groups/cs:group[@id=$ruleset-id]
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:cs="http://checker.bintellix.de/checkset/">
    <head>
        <title>Ruleset - Copy Feedback</title>
        <link rel="stylesheet" type="text/css" href="{$ct-home-web}/base/checker.css"/>
        <style type="text/css">
        <![CDATA[
            label {
                width: 15ex;
                font-weight: bold;
                display: inline-block;
            }
            ]]>
        </style>
    </head>
    <body>
		<span>You are here: </span>
		<a href="{$ct-home-web}/overview.html">Groups</a>
		<span>&#160;&gt;&#160;</span>
		<a href="{$ct-home-web}/{$group}/index.html">{$group}</a>
		<span>&#160;&gt;&#160;</span>
		{
		if ($type="global") then
            (<span><a href="copy.html?type=global">Global rulesets</a></span>,
    		<span>&#160; </span>,
            <span>[<a href="copy.html?type=group">Group specific rulesets</a>]</span>)
		else 
            (<span><a href="copy.html?type=group">Group specific rulesets</a></span>,
    		<span>&#160; </span>,
            <span>[<a href="copy.html?type=global">Global rulesets</a>]</span>)		
		}
    
        <h2>Ruleset Copy Result</h2>
        { let $dest_ruleset := doc($dest_ruleset-file)/cs:step/cs:checkset/cs:groups/cs:group[@id=$dest_ruleset-id]
          return
            <div>Copied the {$type} ruleset "{data($ruleset/@title)}" ({$group}/{$ruleset-id}) to "{data($dest_ruleset/@title)}" ({$dest_group}/{$dest_ruleset-id})</div>  
        }
    </body>
</html>