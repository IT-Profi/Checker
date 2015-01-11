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

let $ct-home-db := request:get-attribute('ct-home-db')
let $ct-home-data := request:get-attribute('ct-home-data')
return

<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
<!-- harden program access -->
{    
    dbutil:scan-collections(xs:anyURI($ct-home-db), function($collection) {
        sm:chmod($collection, "rwxr-xr-x"),
        
        dbutil:scan-resources($collection, function($resource) {
            sm:chmod($resource, "rwxr--r--")    
        }),
        dbutil:find-by-mimetype($collection, "application/xquery", function($resource) {
            sm:chmod($resource, "rwxr-xr-x")
        })
    }),
    dbutil:find-by-mimetype(xs:anyURI(concat($ct-home-db, "/admin")), "application/xquery", function($resource) {
        sm:chmod($resource, "rwxr-xr--")
    }),    
    (
        sm:chmod(xs:anyURI(concat($ct-home-db,'/step/step_run.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/runset/runset_run.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/admin/config_edit.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/admin/config_edit_response.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/admin/refresh.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/admin/refresh.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/admin/upgrade.xql')), "rwsr-xr-x"),
        sm:chmod(xs:anyURI(concat($ct-home-db,'/admin/validate.xql')), "rwsr-xr-x")
    )
}

<!-- harden data access -->
{
    sm:chmod($ct-home-data, "rwxrwxrwx"),   
    dbutil:scan-collections(xs:anyURI($ct-home-data), function($collection) {
        sm:chmod($collection, "rwxrwxrwx"),
        dbutil:scan-resources($collection, function($resource) {
            sm:chmod($resource, "rw-rw-rw-") (: ,$resource,<br/> :)   
        })
    })
}

<!-- update database index -->
{
	let $reindex := xmldb:reindex($ct-home-data)
	return
		<div>Index updated for all groups.</div>
}

{
		<div>Done.</div>
}
    </body>
</html>

