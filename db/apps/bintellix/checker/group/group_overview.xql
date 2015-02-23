xquery version "3.0";
declare namespace xdb="http://exist-db.org/xquery/xmldb";
declare namespace cs ="http://checker.bintellix.de/checkset/";

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
let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $data-collection := concat($ct-home-data, '/', $group, '/')
return
<html xmlns="http://www.w3.org/1999/xhtml">
   <menu xmlns="">
        <crosslinks>
            <crosslink url="about.html" title="About"/>
        </crosslinks>
    </menu>
    <body>
        <subtitle>Go to</subtitle>
        <ul>
            <li><a href="step/overview.html">Step overview</a></li>
            <li><a href="fileset/overview.html">Fileset overview</a></li>
            <li><a href="runset/overview.html">Runset overview</a></li>
        </ul>
        <a href="edit.html">Edit Group Settings</a>
        <ul>
            <li><a href="edit.html?tab=namespaces">Group wide namespaces</a></li>
            <li><a href="edit.html?tab=variables">Group wide variables</a></li>
            <li><a href="edit.html?tab=compare">Group wide compare</a></li>
            <li><a href="edit.html?tab=rulesets">Group wide rulesets</a></li>
        </ul>
    </body>
</html>
