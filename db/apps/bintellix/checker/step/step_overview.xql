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

let $steps := for $i in collection($data-collection)/cs:step[cs:identity and cs:checkset] order by number($i/cs:identity/cs:step-order),lower-case($i/cs:identity/cs:step-id) return $i
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
        <subtitle>Table of Steps</subtitle>
		<div>
    		<table class="tableform">
        		<thead>
        			<tr>
        				<th>#</th>
        				<th>Name of Step</th>
        				<th colspan="6">Action</th>
        				<th>Last run</th>
        				<th>State</th>                        
        				<th>Current</th>
        				<th>Master</th>
        				<th>Notes</th>
        			</tr>
        		</thead>
        		<tbody>
        		{
            	  for $step at $pos in $steps 
            	  return
                    let $step-id := $step/cs:identity/cs:step-id
                    let $result := doc(concat($data-collection,'result/step_',$step-id,'.xml'))                  
                    return                        
                    <tr class="{if ($pos mod 2 = 0) then 'even' else 'odd'}">
                        <td class="index">{$pos} </td>
                        <td><a href="{$step-id}/index.html">{$step-id}</a></td>
                        <td><a href="{$step-id}/edit.html"><img src="{$ct-home-web}/base/images/action_edit.ico" title="Edit"/></a></td>
                        <td><a href="{$step-id}/copy.html"><img src="{$ct-home-web}/base/images/action_copy.ico" title="Copy"/></a></td>
                        <td><a href="{$step-id}/move.html"><img src="{$ct-home-web}/base/images/action_setup.ico" title="Rename"/></a></td>
                        <td><a href="{$step-id}/delete.html"><img src="{$ct-home-web}/base/images/action_delete.ico" title="Delete"/></a></td>
                        <td><a href="{$step-id}/run.html"><img src="{$ct-home-web}/base/images/action_view.ico" title="Run"/></a></td>
                        <td><a href="{$step-id}/{replace(replace($filename-pattern,'\{\$group\}',$group),'\{\$step\}',$step-id)}"><img src="{$ct-home-web}/base/images/action_export.ico" title="Download"/></a></td>
                        <!-- 
                            <td><a href="{$step-id}/order.html?move=+1">up</a>&#160;<a href="{$step-id}/step_order.html?move=-1">down</a></td>
                        -->
                        <!--
                        <td>{string(($checkset-data/cs:current/cs:connections/cs:connection[@enabled='true']/@name))[1]}</td>
                        <td>{string(($checkset-data/cs:master/cs:connections/cs:connection[@enabled='true']/@name))[1]}</td>
                        -->
                        <!--
                        { for $runset at $pos in $runsets
          			      return
          			      <td>{if ($step//cs:runset/@id=$runset) then "X" else ()}</td>
                        }
                        -->
                        <td>{format-dateTime($result/cs:step/cs:run/@timestamp,'[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]','EN',(),())}</td> <!-- [FNn,*-2]  -->
                        <td>
                            {
                            if ($result/cs:step/cs:run/cs:result[@status=('success','fine')]) then
                                <div><a href="{$step-id}/result.xml"><img src="{concat($ct-home-web,'/base/images/success.gif')}" title="fine"/></a>&#160;<a href="{$step-id}/result.html">Report</a></div>
                            else if ($result/cs:step/cs:run/cs:result[@status='failed']) then
                                <div><a href="{$step-id}/result.xml" title="{$result/cs:step/cs:run/cs:result/note}"><img src="{concat($ct-home-web,'/base/images/failed.gif')}" title="failed"/></a>&#160;<a href="{$step-id}/result.html">Report</a></div>
                            else if ($result/*) then
                                <div><a href="{$step-id}/result.xml" title="{$result/cs:step/cs:run/cs:result/note}"><img src="{concat($ct-home-web,'/base/images/error.gif')}" title="error"/></a></div>
                            else
                                <div>unknown</div>
                            }
                        </td>
                        <td>{data($step/cs:checkset/cs:current/cs:connections/cs:connection/@name)}</td>
                        <td>{data($step/cs:checkset/cs:master/cs:connections/cs:connection/@name)}</td>
                        <td>{$step/cs:notes}</td>
                        
                      </tr>                    
        	    }
    			</tbody>
    			<tfoot>
    				<tr>
    					<td colspan="13">
    						<a href="create.html"><img src="{concat($ct-home-web,'/base/images/action_add.ico')}" title="Add Step"/></a>
    						<span>&#160;&#160;</span>
                            <a href="import.html"><img src="{concat($ct-home-web,'/base/images/action_import.ico')}" title="Import Step"/></a>
                        </td>
    				</tr>
    			</tfoot>
    		</table>
		</div>
    </body>
</html>
