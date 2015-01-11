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
let $group := request:get-parameter('group','')
let $data-collection := concat($ct-home-data, '/', $group, '/')
let $exist := xmldb:collection-available($data-collection)
return 
if (not($exist)) then
    <error>Group '$group' does not exist.</error>
else
    let $store := xmldb:remove($data-collection)
    return
    <html xmlns="http://www.w3.org/1999/xhtml">
       <body>
           <subtitle>Group '{$group}' has been removed.</subtitle>
           <br/>
           <div>Go back to <a href="../index.html">group overview</a></div>
       </body>
    </html>
