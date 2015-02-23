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
let $runsets := for $i in distinct-values(data(collection($data-collection)//cs:runset/@id)) order by lower-case($i) return $i
return
<html xmlns="">
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
		<subtitle>Table of Runsets</subtitle>
		<div>
    		<table class="tableform">
        		<thead>
        			<tr>
        				<th>#</th>
        				<th>Name of Runset</th>
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
