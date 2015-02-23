xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
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
let $group := request:get-attribute('group')
let $step_new := request:get-parameter('step_new','')
let $filename := concat('step_',$step_new,'.xml')
let $data-collection := concat($ct-home-data,'/',$group,'/')
let $steps := collection($data-collection)//cs:step/cs:identity/cs:step-id
let $exists := if ((for $step in $steps return if (lower-case($step)=lower-case($step_new)) then 'true' else ()) != '') then true() else false()
return
if (not(matches($step_new,'[A-Za-z][A-Za-z0-9_-]{1,99}'))) then
    <error>Invalid step name '{$step_new}'.</error>
else if ($exists) then
    <error>Step '{$step_new}' already exists.</error>
else
	let $copyTemplate := xmldb:copy($ct-home-data, $data-collection, 'step_template.xml') 
	let $renameTemplate := xmldb:rename($data-collection, 'step_template.xml', $filename) 
	let $res := update value doc(concat($data-collection, $filename))/cs:step/cs:identity/cs:step-id/text() with $step_new
	let $res := update value doc(concat($data-collection, $filename))/cs:step/cs:identity/cs:step-group/text() with $group
	let $reindex := xmldb:reindex($data-collection)
	return
	<html xmlns="http://www.w3.org/1999/xhtml">
		<body>
			<div>Created a new step '<a href="{$ct-home-web}/{$group}/step/{$step_new}/edit.html">{$step_new}</a>' for group '<a href="{$ct-home-web}/{$group}/overview.html">{$group}</a>'.</div>
			<br/>
			<div>Go back to <a href="overview.html">Step overview</a></div>
		</body>
	</html>