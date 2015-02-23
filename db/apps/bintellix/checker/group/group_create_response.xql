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
let $group_new := request:get-parameter('group_new','')
let $step_new := request:get-parameter('step_new','')
let $template-collection := $ct-home-data
let $data-collection := concat($ct-home-data, '/', $group_new, '/')
let $groups := xmldb:get-child-collections($ct-home-data)
let $exists := if ((for $i in $groups return if (lower-case($i)=lower-case($group_new)) then 'true' else ()) != '') then true() else false()
return
if (lower-case($group_new) = ('admin','new','')) then
    <error>Group '{$group_new}' is not allowed.</error>
else if (not(matches($group_new,'[A-Za-z][A-Za-z0-9_-]{1,99}'))) then
    <error>Invalid group name '{$group_new}'.</error>
else if ($exists) then
    <error>Group '{$group_new}' already exists.</error>
else
	let $collection := xmldb:create-collection($ct-home-data, $group_new)
	let $rights := xmldb:chmod-collection($collection, util:base-to-integer(0777, 8))

	let $collection := xmldb:create-collection(concat($ct-home-data,'/',$group_new),'result')
	let $rights := xmldb:chmod-collection($collection, util:base-to-integer(0777, 8))

	let $result := xmldb:copy($template-collection, $data-collection, 'step_group_template.xml') 
	let $result := xmldb:rename($data-collection, 'step_group_template.xml', 'step.xml')

	let $result := xmldb:copy($template-collection, $data-collection, 'step_template.xml') 
	let $result := xmldb:rename($data-collection, 'step_template.xml', concat('step_',$step_new,'.xml'))

	let $result := update value collection($data-collection)/cs:step/cs:identity/cs:step-group/text() with $group_new
	let $result := update value collection($data-collection)/cs:step/cs:identity/cs:step-id/text() with $step_new
	
	let $reindex := xmldb:reindex($data-collection)
	return
    <html xmlns="http://www.w3.org/1999/xhtml">
    <body>
        <subtitle>Successfully created the group '<a href="../{$group_new}/overview.html">{$group_new}</a>'.</subtitle>
        <br />
        <div>Go back to <a href="../index.html">Group overview</a></div>
    </body>
    </html>


