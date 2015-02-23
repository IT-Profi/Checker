xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
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

declare variable $xupdate {
<xupdate:modifications version="1.0" xmlns:xupdate="http://www.xmldb.org/xupdate" xmlns:cs="http://checker.bintellix.de/checkset/">
   <xupdate:variable name="value" select="(//cs:xml/cs:request)[1]"/>
   <xupdate:update select="(//cs:xml/cs:request)[1]">
     <xupdate:value-of select="replace('xxx','^[ \t]+|[ \t]+$',''))"/> 
  </xupdate:update>
</xupdate:modifications>
};

let $ct-home-data := request:get-attribute('ct-home-data')
let $group := request:get-attribute('group')
let $item := request:get-data()
let $store := xmldb:store(concat($ct-home-data,'/', $group), 'step.xml', $item)
(:let $xxx := xmldb:update($checkset-location, $xupdate):)

return 
<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
        <subtitle>Group '{$group}' updated successfully.</subtitle>
    </body>
</html>