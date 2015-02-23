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

let $ct-home-web := request:get-attribute('ct-home-web')
return
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<style type="text/css">
			table td, table th {{
				padding-left: 1ex;
				padding-right: 1ex;
			}}
			
			label {{
			     width: 20ex;
			     display: inline-block;
			     font-weight: bold;
		     }}
		</style>
    </head>
    <body>
        <div>
            <form action="import_response.html" enctype="multipart/form-data" method="post">
                <br/>
                <label>Step name: </label>
                <input type="text" name="name" size="40" required="required" pattern="[A-Za-z][A-Za-z0-9_-]{{1,99}}" min="1" max="100"/>
                <br/>
                <label>File: </label>
                <input type="file" name="xmlfile" size="40" required="required"/>
                <br/>
                <br/>
                <input type="submit" value="Import step"/>
            </form>
        </div>
    </body>
</html>