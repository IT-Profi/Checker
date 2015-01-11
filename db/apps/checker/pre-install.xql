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
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
let $db-exist := doc(concat($ct-home-data,'/sitemap.xml'))
let $data-exist := doc(concat($ct-home-data,'/step.xml'))
return
if ($data-exist/*) then 
    <div>All parts already settled.</div>
else
    let $config := xmldb:copy('/db/apps/checker/setup/', '/db/apps', 'checker_config.xml')
    let $data := xmldb:create-collection('/db/apps/','checker_data')
    let $step := xmldb:copy('/db/apps/checker/setup/', '/db/apps/checker_data', 'step.xml')
    let $step_template := xmldb:copy('/db/apps/checker/setup/', '/db/apps/checker_data', 'step_template.xml')
    let $step_group_template := xmldb:copy('/db/apps/checker/setup/', '/db/apps/checker_data', 'step_group_template.xml')
    let $rights := xmldb:chmod-collection('/db/apps/checker_data', util:base-to-integer(0777, 8))
    let $reindex := xmldb:reindex('/db/apps/checker/checker_data/')
    return 
        <div>Created config file and data directory.</div>