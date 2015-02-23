xquery version "3.0";
declare namespace cs = "http://checker.bintellix.de/checkset/";

import module namespace dbutil="http://exist-db.org/xquery/dbutil";

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
let $group_new := request:get-parameter('group_new',$group)
let $fileset := request:get-attribute('fileset')
let $fileset_new := request:get-parameter('fileset_new','NewFileset')
let $move := request:get-attribute('move')
let $data-collection-source := concat($ct-home-data, '/', $group, '/result_',$fileset)
let $data-collection-destination := concat($ct-home-data, '/', $group_new, '/result_',$fileset_new)
let $exists-source := xmldb:collection-available($data-collection-source)
let $exists-destination := xmldb:collection-available($data-collection-destination)
return
if (not(xmldb:collection-available(concat($ct-home-data, '/', $group)))) then
    <error>Source group '{$group}' does not exist.</error>
else if (not(xmldb:collection-available(concat($ct-home-data, '/', $group_new)))) then
    <error>Destination group '{$group_new}' does not exist.</error>
else if (not($exists-source)) then
    <error>Source fileset '{$fileset}' does not exist.</error>
else if ($exists-destination) then
    <error>Fileset '{$fileset_new}' already exist (at destination group '{$group_new}').</error>
else if (not(matches($fileset_new,'[A-Za-z][A-Za-z0-9_-]{1,99}'))) then
    <error>Invalid destination fileset name '{$fileset_new}'.</error>
else
    let $create := xmldb:create-collection(concat($ct-home-data, '/', $group_new), concat('result_',$fileset_new))
    let $rights := xmldb:chmod-collection($data-collection-source, util:base-to-integer(0777, 8))
    let $copy := dbutil:scan-resources($data-collection-source, 
                                       function($resource) {
                                            (xmldb:copy($data-collection-source,$data-collection-destination,replace($resource,'.+/','')),
                                            sm:chmod($resource, "rwxrw-rw-"))
                                       })
    let $result := update value doc(concat($data-collection-destination,'/properties.xml'))/fileset/fileset-name with $fileset_new
    let $delte := if ($move='yes') then xmldb:remove($data-collection-source) else ()
	let $reindex := xmldb:reindex($data-collection-source)
	let $reindex := xmldb:reindex($data-collection-destination)
	return
	if (doc(concat($data-collection-destination,'/properties.xml'))/fileset/fileset-name != $fileset_new) then
	   <error>Copy of group '{$group}' fileset '{$fileset}' to group '{$group_new}' fileset '{$fileset}' failed</error>
	else
    	<html xmlns="http://www.w3.org/1999/xhtml">
    		<body>
    			{
    			     if ($move='yes') then
    			         <div>Renamed fileset to '<a href="../{$fileset_new}/view.html">{$fileset_new}</a>'.</div>
    			     else
    			         <div>Created new fileset '<a href="../{$fileset_new}/view.html">{$fileset_new}</a>'.</div>
    	        }
    	        <br/>
    	        <div>Go back to <a href="../overview.html">Fileset overview</a></div>
    		</body>
    	</html>