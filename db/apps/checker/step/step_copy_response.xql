xquery version "3.0";
declare namespace cs = "http://checker.bintellix.de/checkset/";

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
let $group := request:get-parameter('group','')[1]
let $group_new := request:get-parameter('group_new','')
let $step := request:get-parameter('step','')[1]
let $step_new := request:get-parameter('step_new','')
let $move := request:get-parameter('move','no')
let $data-collection-source := concat($ct-home-data, '/', $group, '/')
let $data-collection-destination := concat($ct-home-data, '/', $group_new, '/')
let $steps := collection($data-collection-destination)/cs:step/cs:identity/cs:step-id
let $filename-source := concat('step_', $step,'.xml')
let $filename-destination := concat('step_', $step_new,'.xml')
let $file-source := fn:doc(concat($data-collection-source, $filename-source))
let $exists-source := $file-source/cs:step/cs:identity/cs:step-id != ''
let $exists-destination := if ((for $step in $steps return if (lower-case($step)=lower-case($step_new)) then 'true' else ()) != '') then true() else false()
return
if (not(xmldb:collection-available($data-collection-source))) then
    <error>Source group '{$group}' does not exist.</error>
else if (not(xmldb:collection-available($data-collection-destination))) then
    <error>Destination group '{$group}' does not exist.</error>
else if (not($exists-source)) then
    <error>Source step '{$step_new}' does not exist.</error>
else if ($exists-destination) then
    <error>Step '{$step_new}' already exist (at destination group '{$group_new}').</error>
else if (not(matches($step_new,'[A-Za-z][A-Za-z0-9_-]{1,99}'))) then
    <error>Invalid destination step name '{$step_new}'.</error>
else
	let $product := xmldb:store($data-collection-destination,$filename-destination,$file-source)
	let $result := update value doc(concat($data-collection-destination,$filename-destination))/cs:step/cs:identity/cs:step-id with $step_new
	let $result := update value doc(concat($data-collection-destination,$filename-destination))/cs:step/cs:identity/cs:step-group with $group_new
	let $remove := if ($move='yes') then xmldb:remove($data-collection-source, $filename-source) else ()
	let $reindex := xmldb:reindex($data-collection-source)
	let $reindex := xmldb:reindex($data-collection-destination)
	return
	if (doc(concat($data-collection-destination,$filename-destination))/cs:step/cs:identity/cs:step-id != $step_new) then
	   <error>Copy of group '{$group}' step '{$step}' to group '{$group}' step '{$step_new}' failed</error>
	else
    	<html xmlns="http://www.w3.org/1999/xhtml">
    		<body>
    		  <h3>Filename {concat($data-collection-destination,$filename-destination)}; {$result}</h3>
    			{
    			     if ($move='yes') then
    			         <div>Renamed step to '<a href="../{$step_new}/edit.html">{$step_new}</a>'.</div>
    			     else
    			         <div>Created new step '<a href="../{$step_new}/edit.html">{$step_new}</a>'.</div>
    	        }
    	        <br/>
    	        <div>Go back to <a href="../overview.html">Step overview</a></div>
    		</body>
    	</html>