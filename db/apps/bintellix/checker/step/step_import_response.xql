xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
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

let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $filename_in := request:get-parameter('name','new')
let $step_new := if (contains($filename_in, '.')) then substring-before($filename_in, '.') else $filename_in
let $filename := concat('step_',$step_new,'.xml')
let $file := request:get-uploaded-file-data('xmlfile')
let $data-collection := concat($ct-home-data, '/', $group, '/')
let $steps := collection($data-collection)//cs:step/cs:identity/cs:step-id
let $exists := if ((for $step in $steps return if (lower-case($step)=lower-case($step_new)) then 'true' else ()) != '') then true() else false()
return 
if (not(matches($step_new,'[A-Za-z][A-Za-z0-9_-]{1,99}'))) then
    <error>Invalid step name '{$step_new}'.</error>
else if ($exists) then
    <error>Step '{$step_new}' already exists.</error>
else if (not(xmldb:collection-available($data-collection))) then
    <error>Group '{$group}' does not exist.</error>
else
    if (xs:string($file) != '') then 
        let $xml := util:base64-decode(xs:string($file))
        let $store := xmldb:store($data-collection, $filename, $xml)
        let $result := update value doc(concat($data-collection,$filename))/cs:step/cs:identity/cs:step-id with $step_new
        let $result := update value doc(concat($data-collection,$filename))/cs:step/cs:identity/cs:step-group with $group
        let $result := update replace doc(concat($data-collection,$filename))/cs:step/cs:checkset/cs:groups with <cs:groups/>
        let $result := update delete doc(concat($data-collection,$filename))/cs:step/*[@type='GLOBAL']
        let $result := update delete doc(concat($data-collection,$filename))/cs:step/*[@type='GROUP']
        let $result := update delete doc(concat($data-collection,$filename))/cs:step/cs:checkset/*[@type='GLOBAL']
        let $result := update delete doc(concat($data-collection,$filename))/cs:step/cs:checkset/*[@type='GROUP']
        let $reindex := xmldb:reindex($data-collection)
        return
        <html xmlns="http://www.w3.org/1999/xhtml">
            <body>
                <subtitle>Successfully imported step '{$step_new}'.</subtitle>
                <br/>
                <div>Go back to <a href="overview.html">Step overview</a></div>
            </body>
        </html>
    else
        <error>Import of step '{$step_new}' failed.</error>
