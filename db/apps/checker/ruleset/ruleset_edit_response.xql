xquery version "3.0";

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
let $group := request:get-parameter('group', '')
let $step := request:get-parameter('step', '')
let $ruleset-type := request:get-parameter('type', '')
let $step-location := 
    if ($ruleset-type="GLOBAL") then concat($ct-home-data,'/')
    else if ($ruleset-type="GROUP") then concat($ct-home-data, "/", $group, "/")
    else concat($ct-home-data, "/", $group, "/", "step_", $step, ".xml")
let $step-file := concat($step-location, "step.xml")
let $item := request:get-data()
let $store := xmldb:store($step-location, $step-file, $item)
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Step Rules - Updated</title>
    </head>
    <body>
        <h2>Step rules updated successfully</h2>
    </body>
</html>