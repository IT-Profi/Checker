xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

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
let $elements := xmldb:get-child-collections($ct-home-data)
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <menu xmlns="">
        <crosslinks>
            <crosslink url="admin/index.html" title="Administration"/>
            <crosslink url="tools/index.html" title="Tools"/>
            <crosslink url="about.html" title="About"/>
        </crosslinks>
    </menu>    
    <body>
        <subtitle>List of groups</subtitle>
		<table class="tableform">
            <thead>
                <tr>
                    <th class="index">#</th>
                    <th>Group name</th>
                    <th colspan="4">Action</th>
                </tr>
            </thead>
            <tbody>
                {
                    let $groups := for $element in $elements order by lower-case($element) return $element
                    for $group at $pos in $groups
                    return
                    <tr class="{if ($pos mod 2 = 0) then 'even' else 'odd'}">
                        <td class="index">{$pos}</td>
                        <td><a href="{$group}/index.html">{$group}</a></td>
                        <td><a href="{$group}/overview.html"><img src="{$ct-home-web}/base/images/action_edit.ico" title="Edit"/></a></td>
                        <td><a href="{$group}/copy.html"><img src="{$ct-home-web}/base/images/action_copy.ico" title="Copy"/></a></td>
                        <td><a href="{$group}/move.html"><img src="{$ct-home-web}/base/images/action_setup.ico" title="Rename"/></a></td>
                        <td><a href="{$group}/delete.html"><img src="{$ct-home-web}/base/images/action_delete.ico" title="Delete"/></a></td>
                    </tr>
                }
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="7">
                        <a href="new/create.html">Add new group</a>
                    </td>
                </tr>
            </tfoot>
        </table>
    </body>
</html>

