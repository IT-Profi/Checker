xquery version "3.0";

declare namespace compression="http://exist-db.org/xquery/compression";
declare namespace xs="http://www.w3.org/2001/XMLSchema";
declare namespace cs="http://checker.bintellix.de/checkset/";
declare namespace bc="http://checker.bintellix.de/";

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
let $ct-home-db := request:get-attribute('ct-home-db')
let $filename-pattern := request:get-attribute('filename-pattern')
let $group := request:get-attribute('group')
let $runset := request:get-attribute('runset')
let $data-collection := concat($ct-home-data, '/', $group, '/')

(:
let $checksets := for $id in collection($data-collection)/cs:step[cs:checkset/cs:runsets/cs:runset/@id=$runset]/cs:identity/cs:step-id
                    return xs:anyURI(concat($data-collection,'step_',$id,'.xml'))
:)
let $checksets := for $id in collection($data-collection)/cs:step[cs:checkset/cs:runsets/cs:runset/@id=$runset]/cs:identity/cs:step-id
                    return
                    let $path := concat(substring-before(request:get-url(),'/exist'),$ct-home-web,'/',$group,'/step/',$id,'/')
                    let $filename := replace(replace($filename-pattern,'\{\$group\}',$group),'\{\$step\}',$id)
                    return <entry name="{$filename}" type="xml" method="store">{doc(concat($path,$filename))}</entry>
let $zip64 := compression:zip($checksets, false())
return
  response:stream-binary($zip64,"application/zip", concat("runset_", $runset, ".zip"))
  
  