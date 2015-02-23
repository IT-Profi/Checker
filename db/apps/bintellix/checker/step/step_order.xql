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
let $step := request:get-attribute('step')
let $move := request:get-parameter('move','')
let $data-collection := concat($ct-home-data, '/', $group, '/')
let $current-pos := collection($data-collection)/cs:step/cs:checkset/cs:step[cs:step-id=$step]/cs:step-order

return
    if ($move="1" or $move="+1") then
        let $new-pos := number($current-pos) +1
        let $result := update value collection($data-collection)/cs:step/cs:identity/cs:step-order with $new-pos
        return
        <html xmlns="http://www.w3.org/1999/xhtml">
    		<body>
    			<div>Moved step '{$step}' order to be {$new-pos}.</div>
    		</body>
    	</html>
    else if ($move="-1") then
        let $new-pos := number($current-pos) -1
        let $result := update value collection($data-collection)/cs:step/cs:identity/cs:step-order/text() with $new-pos
        return 
        <html xmlns="http://www.w3.org/1999/xhtml">
    		<body>
    			<div>Moved step '{$step}' order to be {$new-pos}.</div>
    		</body>
    	</html>
    else
	<error>Invalid move '{$move}' command</error>