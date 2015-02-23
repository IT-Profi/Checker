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
let $group := request:get-attribute('group')
let $fileset := request:get-data()

let $fileset-id := $fileset/fileset/fileset-name 

let $collection := concat($ct-home-data,'/',$group,'/result_',$fileset-id)
let $collection := xmldb:create-collection(concat($ct-home-data,'/',$group),concat('result_',$fileset-id))
    let $rights := xmldb:chmod-collection($collection, util:base-to-integer(0777, 8))
    let $properties := xmldb:store($collection, 'properties.xml', $fileset)
	return
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		</head>
		<body>
			<div>Created an empty fileset '{$fileset-id}'</div>
	        <br/>
	        <div><a href="{$fileset-id}/run.html">Run all checks</a> for fileset '{$fileset-id}' now</div>
	        <br/>
	        <div>Go back to <a href="overview.html">Fileset overview</a></div>
		</body>
	</html>
