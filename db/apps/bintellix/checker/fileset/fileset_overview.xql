xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace cs ="http://checker.bintellix.de/checkset/";
declare namespace bc="http://checker.bintellix.de/";

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
let $ct-home-data := request:get-attribute('ct-home-data')
let $filename-pattern := request:get-attribute('filename-pattern')
let $group := request:get-attribute('group')
let $data-collection := concat($ct-home-data, '/', $group, '/')

let $filesets := xmldb:get-child-collections($data-collection)
return
<html xmlns="">
    <head>
		<style type="text/css">
			table td, table th {{
				padding-left: 1ex;
				padding-right: 1ex;
			}}
			
		</style>
    </head>
    <body>
		<subtitle>Table of Filesets</subtitle>
		<div>
    		<table class="tableform">
        		<thead>
        			<tr>
        				<th>#</th>
        				<th>Name of Fileset</th>
        				<th colspan="4">Action</th>
        				<th>Notes</th>
        			</tr>
        		</thead>
        		<tbody>
        		{
            	  for $fileset at $pos in $filesets
            	  where substring-after($fileset,'result_') != ''
            	  return
            	    let $properties := doc(concat($data-collection,'/',$fileset,'/properties.xml'))
            	    let $fileset-id := substring-after($fileset, 'result_')
            	    return
                    <tr class="{if ($pos mod 2 = 0) then 'even' else 'odd'}">
                        <td class="index">{$pos}</td>
                        <td><a href="../fileset/{substring-after($fileset,'result_')}/view.html">{$fileset-id}</a></td>
                        <td><a href="../fileset/{$fileset-id}/copy.html"><img src="/exist/apps/bintellix/checker/base/images/action_copy.ico" title="Copy"/></a></td>
                        <td><a href="../fileset/{$fileset-id}/move.html"><img src="/exist/apps/bintellix/checker/base/images/action_setup.ico" title="Rename"/></a></td>
                        <td><a href="../fileset/{$fileset-id}/delete.html"><img src="/exist/apps/bintellix/checker/base/images/action_delete.ico" title="Delete"/></a></td>
                        <td><a href="../fileset/{$fileset-id}/run.html?max=1000"><img src="/exist/apps/bintellix/checker/base/images/action_view.ico" title="Run"/></a></td>
                        <td>{$properties/fileset/notes}</td>
                      </tr>
        		}
    			</tbody>
    			<tfoot>
    			     <tr>
    			         <td colspan="7">
    			             <a href="../fileset/create.html"><img src="/exist/apps/bintellix/checker/base/images/action_add.ico" title="Add fileset"/></a>
    			         </td>
    		         </tr>
    			</tfoot>
    		</table>
		</div>
    </body>
</html>
