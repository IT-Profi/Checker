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

let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $data-collection := concat($ct-home-data, '/' ,$group, '/')
let $exists := xmldb:collection-available($data-collection)
return
if (lower-case($group) = ('admin','new','')) then
    <error>Group '{$group}' is not allowed.</error>
else if (not($exists)) then
    <error>Group '{$group}' does not exist.</error>
else
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <style>
            <![CDATA[
            .warn{
                background-color: orange;
                color: black;
                font-size: 120%;
                line-height: 24pt;
                padding: 5pt;
                border: solid 1px black;
            }
            ]]>
            </style>
        </head>
        <body>
            <subtitle>Are you sure you want to delete group '{$group}'?</subtitle>
            <br/>
            <br/>
            <a class="warn" href="delete_response.html">Yes - Delete this group</a>
            <br/><br/>
            <br/>
            <a  class="warn" href="../overview.html">No - Go back to group overview</a>
        </body>
    </html>
