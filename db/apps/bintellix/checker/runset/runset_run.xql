xquery version "3.0";
declare namespace cs="http://checker.bintellix.de/checkset/";

import module namespace run='http://checker.bintellix.de/' at '../step/step_run.xqm';

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

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $uri := request:get-attribute('uri')
let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
let $cmd-path := request:get-attribute('cmd-path')
let $cmd-file := request:get-attribute('cmd-file')
let $group := request:get-attribute('group')
let $runset := request:get-attribute('runset')
let $format := request:get-attribute('format')
let $debug := request:get-parameter('debug', '0')

let $steps := for $i in collection(concat($ct-home-data,'/',$group))/cs:step[cs:checkset/cs:runsets/cs:runset/@id=$runset]/cs:identity/cs:step-id
                    order by lower-case($i) return $i
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
    {
    for $step-id at $pos in $steps
        return
        <div>
            <span>{$pos}. Step <a href="../../step/{$step-id}/index.html">{$step-id/text()}</a>&#160;</span>
            {
                let $result := run:run($group, $step-id, '', '', $cmd-path, $cmd-file, $uri, $ct-home-web, $ct-home-db, $ct-home-data, <cs:variables/>, $debug)
                return 
                    if ($result//cs:run/cs:result[@status=('success','fine')]) then
                        <span><a href="../../step/{$step-id}/result.xml"><img src="{concat($ct-home-web,'/base/images/success.gif')}" title="fine"/></a>&#160;<a href="../../step/{$step-id}/result.html">Report</a></span>
                    else if ($result//cs:run/cs:result[@status='failed']) then
                        <span><a href="../../step/{$step-id}/result.xml" title="{$result/cs:step/cs:run/cs:result/note}"><img src="{concat($ct-home-web,'/base/images/failed.gif')}" title="failed"/></a>&#160;<a href="../../step/{$step-id}/result.html">Report</a></span>
                    else if ($result/*) then
                        <span><a href="../../step/{$step-id}/result.xml" title="{$result/cs:step/cs:run/cs:result/note}"><img src="{concat($ct-home-web,'/base/images/error.gif')}" title="error"/></a></span>
                    else
                        <span>unknown</span>
            }
        </div>
    }    
    <br/>
    <div>Go back to <a href="../overview.html">Runset overview</a></div>
    </body>
</html>
