xquery version "3.0";
declare namespace xdb="http://exist-db.org/xquery/xmldb";

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
let $ct-home-db := request:get-attribute('ct-home-db')
let $data-collection := concat($ct-home-db,'/data/')
let $group := request:get-parameter('group', '')
let $checkset := request:get-parameter('checkset', '')
let $ruleset-type := request:get-parameter('type', 'group')
let $ruleset-file := 
    if ($ruleset-type="GLOBAL") then concat($data-collection, "checkset.xml")
    else if ($ruleset-type="GROUP") then concat($data-collection, $group, "/", "checkset.xml")
    else concat($data-collection, $group, "/", "checkset_", $checkset, ".xml")
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:cs="http://checker.bintellix.de/checkset/">
    <head>
        <link rel="stylesheet" type="text/css" href="{$ct-home-web}/base/checker.css"/>
        <style type="text/css">
        <![CDATA[
            label {
                width: 15ex;
                font-weight: bold;
                display: inline-block;
            }
            input[readonly] {
                color: #262626;
                border: 1px solid #BBB;
            }
        ]]>
        </style>
    </head>
    <body>
        <form  action="copy_result.html" method="get">
            <h3>Source</h3>
            <div>
            <!-- {element {option} {if ($ruleset-type='GLOBAL') then attribute {checked} {"checked"} else () } } -->
                <label>Type</label>
                <select name="type" readonly="readonly">
                    {if ($ruleset-type='global') then <option value="global" selected="selected">Global</option> else ()}
                    {if ($ruleset-type='group') then <option value="group" selected="selected">Group</option> else ()}                   
                </select>
                <br/>
                <label>Group</label>
                <input type="text" name="group" value="{$group}" readonly="readonly"/>
                <br/>
                <label>Ruleset</label>
                <select name="ruleset">
                { for $ruleset in doc($ruleset-file)/cs:step/cs:checkset/cs:groups/cs:group return
                    <option value="{data($ruleset/@id)}">Name: '{data($ruleset/@title)}' &#160;&#160;Type: '{data($ruleset/@type)}' &#160;&#160;Filter: '{data($ruleset/@filter)}'</option>
                }
                </select>
            </div>
            <h3>Destination</h3>
            <div>
                <label>Type</label>
                <select name="dest_type">
                    {if ($ruleset-type='global') then <option value="global" selected="selected">Global</option> else <option value="global">Global</option>}
                    {if ($ruleset-type='group') then <option value="group" selected="selected">Group</option> else <option value="global">Group</option>}
                </select>
                <br/>
                <label>Group</label>
                <select name="dest_group">
                { for $group in xdb:get-child-collections($data-collection) return
                  <option value="{$group}">{$group}</option>
                }
                </select>
            </div>
            <br/>
            <input type="submit" value="Copy"/>
        </form>
    </body>
</html>