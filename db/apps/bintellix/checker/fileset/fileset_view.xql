xquery version "3.0";
declare namespace cs="http://checker.bintellix.de/checkset/";

let $fileset := request:get-attribute('fileset')
let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')

let $data-collection := concat($ct-home-data,'/',$group,'/result_',$fileset)
let $tests := xmldb:get-child-resources($data-collection)
let $properties := doc(concat($ct-home-data,'/',$group,'/result_',$fileset,'/properties.xml'))
let $step-id := $properties/fileset/step-name
let $result := doc(concat($ct-home-data,'/',$group,'/step_',$step-id,'.xml'))
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
        <subtitle>Fileset '{$fileset}' details:</subtitle>
        <table class="tableform">
            <tbody>
                <tr>
                    <th>Name of Fileset</th>
                    <td>{$properties/fileset/fileset-name}</td>
                </tr>
                <tr>
                    <th>Master file variable</th>
                    <td>{$properties/fileset/master-file-variable}</td>
                </tr>
                <tr>
                    <th>Master file-list URL</th>
                    <td><a href="{$properties/fileset/master-file-list}">{$properties/fileset/master-file-list}</a></td>
                </tr>
                <tr>
                    <th>Current file variable</th>
                    <td>{$properties/fileset/current-file-variable}</td>
                </tr>
                <tr>
                    <th>Current file-list URL</th>
                    <td><a href="{$properties/fileset/current-file-list}">{$properties/fileset/current-file-list}</a></td>
                </tr>
                
                <tr>
                    <th>Notes</th>
                    <td>{$properties/fileset/notes}</td>
                </tr>
                
            </tbody>
        </table>
        <br/>
        { if ($result/*) then 
            <div>
                <subtitle>Step '{$step-id}' details:</subtitle>
                <table class="tableform">
                    <tbody>
                        <tr>
                            <th>Name of Step</th>
                            <td><a href="{concat($ct-home-web,'/',$group,'/step/',$step-id,'/edit.html')}">{$result/cs:step/cs:identity/cs:step-id}</a></td>
                        </tr>
                        <tr>
                            <th>Notes</th>
                            <td>{$result/cs:step/cs:identity/cs:notes}</td>
                        </tr>
                        
                    </tbody>
                </table>
                <br/>
            </div>
          else
            ()
        }
        <subtitle>Test reports:</subtitle>
        <table class="tableform">
        	<thead>
        		<tr>
        			<th>#</th>
        			<th>Test name</th>
        			<th>Action</th>
        			<th>Last run</th>
        			<th>Status</th>
        		</tr>
        	</thead>
            <tbody>
                { for $test at $pos in $tests
                  where $test != 'properties.xml'
        	      return
            	    let $result := doc(concat($data-collection,'/',$test))            	    
            	    return
                    <tr class="{if ($pos mod 2 = 0) then 'even' else 'odd'}">
                        <td class="index">{$pos}</td>                    
            			<td><a href="{substring-before($test,'.xml')}.html">{$test}</a></td>
            			<td>none</td>
            			<td>{format-dateTime($result/cs:step/cs:run/@timestamp,'[Y0001]-[M01]-[D01] [H01]:[m01]:[s01]','EN',(),())}</td>
            			<td>
            			    {
                            if ($result/cs:step/cs:run/cs:result[@status=('success','fine')]) then
                                <div><a href="{substring-before($test,'.xml')}.xml"><img src="{concat($ct-home-web,'/base/images/success.gif')}" title="fine"/></a>&#160;<a href="{substring-before($test,'.xml')}.html">Report</a></div>
                            else if ($result/cs:step/cs:run/cs:result[@status='failed']) then
                                <div><a href="{substring-before($test,'.xml')}.xml" title="{$result/cs:step/cs:run/cs:result/note}"><img src="{concat($ct-home-web,'/base/images/failed.gif')}" title="failed"/></a>&#160;<a href="{substring-before($test,'.xml')}.html">Report</a></div>
                            else if ($result/*) then
                                <div><a href="{substring-before($test,'.xml')}.xml" title="{$result/cs:step/cs:run/cs:result/note}"><img src="{concat($ct-home-web,'/base/images/error.gif')}" title="error"/></a></div>
                            else
                                <div>unknown</div>
                            }
            			</td>
            		</tr>
                }
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5">
                        <a href="run.html?max=1000">Run all checks again</a>
                    </td>
                </tr>
            </tfoot>
        </table>
    </body>
</html> 
   