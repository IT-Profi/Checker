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
let $group := request:get-parameter('group','')
let $data-collection := concat($ct-home-data, '/', $group, '/')

let $steps := for $i in collection($data-collection)/cs:step[cs:identity and cs:checkset] order by number($i/cs:identity/cs:step-order),lower-case($i/cs:identity/cs:step-id) return $i
let $runsets := for $i in distinct-values(data(collection($data-collection)//cs:runset/@id)) order by lower-case($i) return $i
return
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="">
    <head>
		<style type="text/css">
			table td, table th {{
				padding-left: 1ex;
				padding-right: 1ex;
			}}
			
			.VerticalText {{
                -ms-transform: rotate(270deg); /* IE 9 */
                -ms-transform-origin: right bottom 0; /* IE 9 */
                -webkit-transform: rotate(270deg); /* Chrome, Safari, Opera */
                -webkit-transform-origin: right bottom 0; /* Chrome, Safari, Opera */			
			
	           transform: rotate(270deg);
	           transform-origin: right bottom 0;
            }}
		</style>
    </head>
    <body>
        <subtitle>List of steps</subtitle>
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
                        <td><a href="{$step-id}/copy.html?move=yes"><img src="{$ct-home-web}/base/images/action_setup.ico" title="Rename"/></a></td>
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
                            <a href="import.html"><img src="{concat($ct-home-web,'/base/images/action_import.ico')}" title="Import Stap"/></a>
                        </td>
    				</tr>
    			</tfoot>
    		</table>
		</div>
		<br/>
		<br/>
		<subtitle>List of runsets</subtitle>
		<div>
    		<table class="tableform">
        		<thead>
        			<tr>
        				<th>#</th>
        				<th>Name</th>
        				<th colspan="2">Action</th>
        				{ for $step at $pos in $steps
        				  return
        				    (: {if ($pos = 1) then attribute {colspan} {count($runsets)} else ()} :)
        				    <th class="VerticalText">{$step/cs:identity/cs:step-id}</th>
                        }
        			</tr>
        		</thead>
        		<tbody>
        		{
            	  for $runset at $pos in $runsets
            	  return
                    <tr class="{if ($pos mod 2 = 0) then 'even' else 'odd'}">
                        <td class="index">{$pos} </td>
                        <td>{$runset}</td>
                        <td><a href="../runset/{$runset}/run.html"><img src="{$ct-home-web}/base/images/action_view.ico" title="Run"/></a></td>
                        <td><a href="../runset/{$runset}/runset_{$runset}.zip"><img src="{$ct-home-web}/base/images/action_export.ico" title="Download"/></a></td>
                        { for $step at $pos in $steps
          			      return
          			       let $step-id := $step/cs:step/cs:identity/cs:step-id
          			       return
          			           <td>{if ($step//cs:runset/@id=$runset) then "X" else ()}</td>
                        }
                      </tr>
        		}
    			</tbody>
    		</table>
		</div>
    </body>
</html>
