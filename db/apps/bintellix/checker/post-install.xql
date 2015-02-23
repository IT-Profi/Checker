xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace bc="http://checker.bintellix.de/";
declare namespace cs="http://checker.bintellix.de/checkset/";

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

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

let $config := doc(concat($target,'/../checker_config.xml'))
let $ct-home-web := $config/bc:config/bc:home/bc:web/text()
let $ct-home-db := $config/bc:config/bc:home/bc:db/text()
let $ct-home-data := $config/bc:config/bc:home/bc:data/text()
let $db-exist := doc(concat($ct-home-data,'/sitemap.xml'))
let $data-exist := doc(concat($ct-home-data,'/step.xml'))

let $dir-setup := concat($target,'/setup/')
let $dir-data := concat($target, '/../checker_data')
return

if ($data-exist/*) then 
    <div>All parts already settled.</div>
else
    let $config := xmldb:copy($dir-setup, concat($target,'/../'), 'checker_config.xml')
    let $data := xmldb:create-collection(concat($target,'/../'),'checker_data')
    let $step := xmldb:copy($dir-setup, $dir-data, 'step.xml')
    let $step_template := xmldb:copy($dir-setup, $dir-data, 'step_template.xml')
    let $step_group_template := xmldb:copy($dir-setup, $dir-data, 'step_group_template.xml')
    let $rights := xmldb:chmod-collection($dir-data, util:base-to-integer(0777, 8))
    let $examples := xmldb:copy(concat($dir-setup,'/Examples'),$dir-data)
    let $reindex := xmldb:reindex($dir-data)
    return 
        <div>Created config file and data directory.</div>