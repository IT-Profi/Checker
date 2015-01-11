xquery version "3.0";
declare namespace cs="http://checker.bintellix.de/checkset/";
import module namespace process="http://exist-db.org/xquery/process" at "java:org.exist.xquery.modules.process.ProcessModule";

import module namespace run='http://checker.bintellix.de/' at 'step_run.xqm';

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

let $ct-home-web := request:get-attribute('ct-home-web')
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-parameter('group', '')
let $step := request:get-parameter('step', '')
let $debug := request:get-parameter('debug', '0')
let $cmd-path := request:get-attribute('cmd-path')
let $cmd-file := request:get-attribute('cmd-file')
let $uri := request:get-attribute('uri')

let $result := run:run($group, $step, $cmd-path, $cmd-file, $uri, $ct-home-web, $ct-home-db, $ct-home-data, $debug)
return $result
