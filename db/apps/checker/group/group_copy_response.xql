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

let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-parameter('group','')[1]
let $group_new := request:get-parameter('group_new','')
let $move := request:get-parameter('move','no')
let $data-collection := concat($ct-home-data, '/', $group, '/')
let $data-collection_new := concat($ct-home-data, '/', $group_new, '/')
let $exists-source := xmldb:collection-available($data-collection)
let $groups := xmldb:get-child-collections($ct-home-data)
let $exists-destination := if ((for $group in $groups return if (lower-case($group)=lower-case($group_new)) then 'true' else ()) != '') then true() else false()
return
if (lower-case($group) = ('admin','new','')) then
    <error>Group '{$group}' is not allowed (as source).</error>
else if (lower-case($group_new) = ('admin','new','')) then
    <error>Group '{$group_new}' is not allowed (as destination).</error>
else if (not(matches($group_new,'[A-Za-z][A-Za-z0-9_-]{1,99}'))) then
    <error>Invalid group name '{$group_new}'.</error>
else if (not($exists-source)) then
    <error>Souce group '{$group}' does not exist.</error>
else if ($exists-destination) then
    <error>Destination group '{$group_new}' already exists.</error>
else
    let $collection := xmldb:create-collection($ct-home-data,$group_new)
    let $rights := xmldb:chmod-collection($collection, util:base-to-integer(0777, 8))

	let $collection := xmldb:create-collection(concat($ct-home-data,'/',$group_new),'result')
	let $rights := xmldb:chmod-collection($collection, util:base-to-integer(0777, 8))

    let $resouces := xmldb:get-child-resources($data-collection)
    let $result := for $i in $resouces return xmldb:copy($data-collection, $data-collection_new, $i)
	let $result := update value collection($data-collection_new)/cs:step/cs:identity/cs:step-group/text() with $group_new
	let $reindex := xmldb:reindex($data-collection)
	let $remove := if ($move='yes') then xmldb:remove($data-collection) else ()
	return
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		</head>
		<body>
			{
			     if ($move='yes') then
			         <div>Renamed group '<a href="../{$group_new}/overview.html">{$group_new}</a>'.</div>
			     else
			         <div>Created new group '<a href="../{$group_new}/overview.html">{$group_new}</a>'.</div>
	        }
	        <br/>
	        <div>Go back to <a href="../index.html">group overview</a></div>
		</body>
	</html>
