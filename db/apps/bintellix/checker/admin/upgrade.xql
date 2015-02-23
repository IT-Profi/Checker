xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace cs="http://checker.bintellix.de/checkset/";
declare namespace sm="http://exist-db.org/xquery/securitymanager";

import module namespace dbutil="http://exist-db.org/xquery/dbutil";

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
let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
return

<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
        <div>
        {

        let $xslt-cleanup := doc(concat($ct-home-db,'/admin/upgrade_cleanup.xsl'))
            let $xslt-v1 := doc(concat($ct-home-db,'/admin/upgrade_v1.xsl'))
            let $collections := xmldb:get-child-collections($ct-home-data)
            return 
                for $collection in ($collections, '') order by lower-case($collection)
                return 
                    for $filelocation in dbutil:scan-resources(xs:anyURI(concat($ct-home-data,'/',$collection)), function($resource) { $resource })
                        return
                            let $file-before := doc($filelocation)
                            let $file-after-cleanup := transform:transform($file-before, $xslt-cleanup, ())
                            let $step-id := if (contains($filelocation,'step_')) then substring-after(substring-before($filelocation,'.xml'),'step_') else substring-after(substring-before($filelocation,'.xml'),'step') 
                            let $parameters :=  <parameters>
                                                    <param name="group" value="{$collection}"/>
                                                    <param name="step" value="{$step-id}"/>
                                                </parameters>
                            let $file-after := transform:transform($file-after-cleanup, $xslt-v1, $parameters)
                            let $filename := concat('step', if ($step-id='') then '' else '_',$step-id,'.xml')
                            return 
                                if ($file-after/*) then
                                     let $store := xmldb:store(concat($ct-home-data,'/',$collection), $filename, $file-after)
                                     return
                                        () (: <div><a href="{$ct-home-web}/{$collection}/step/{$step-id}/edit.html">Step: {$collection} / {$step-id}</a> Result: {$store}</div> :)
                                else
                                    <div><a href="{$ct-home-web}/{$collection}/step/{$step-id}/edit.html">Step: {$collection} / {$step-id} (Filename: {$filename}</a> Result: ERROR {$filelocation} {$file-after}</div>
        }
        </div>       
    
        <div>
        <!--
        {
            let $collections := xmldb:get-child-collections($ct-home-data)
            return 
                for $collection in ($collections,'') order by lower-case($collection)
                return 
                    for $filename in dbutil:scan-resources(xs:anyURI(concat($ct-home-data,'/',$collection)), function($resource) { $resource }) where contains($filename, 'checkset')
                        return
                            let $file := doc($filename)
                            let $step-id := if (contains($filename,'checkset_')) then substring-after(substring-before($filename,'.xml'),'checkset_') else substring-after(substring-before($filename,'.xml'),'checkset')
                            let $file-orig := replace($filename,'.*checkset','checkset')
                            let $file-new := concat('step', if ($step-id='') then '' else '_',$step-id,'.xml')
                            let $move := xmldb:rename(concat($ct-home-data,'/',$collection),$file-orig, $file-new)
                            return
                                <div>Moved file at group '{$collection}' from '{$file-orig}' to '{$file-new}'.</div>
        }
        -->
        </div>
        <div>
       {
            for $element in collection($ct-home-data)//cs:groups/cs:group[not(@notes)]
            return 
                let $result := update insert attribute notes {''} into $element
                return 
                    <div>updated</div>
       }
        </div>
      
        <div>
        {
            let $index := xmldb:reindex($ct-home-data)
            return 
                <div>Done.</div>
        }
        </div>
    </body>
</html>

