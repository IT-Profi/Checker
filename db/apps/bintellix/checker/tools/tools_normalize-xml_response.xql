xquery version "3.0";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace bc="http://checker.bintellix.de/";
declare namespace cs="http://checker.bintellix.de/checkset/";

declare option exist:serialize "method=text media-type=text omit-xml-declaration=yes indent=no";
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
let $post-data := request:get-data()
(:
let $post-data := 
<config><file xs:type="xs:base64Binary">
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHNmZ19jbGllbnQ6Y2xpZW50
IHhtbG5zOnNmZ19jbGllbnQ9Imh0dHA6Ly93d3cuYm13ZnMuY29tL1NGR2xvYmFsL2NsaWVudCIg
CgltYXhJdGVyYXRpb25zPSIyIiAKCWNvdW50cnk9IkJFIiAKCWJyYW5kPSJCTVciIAoJYnJhbmRB
bGlhcz0iQk1XIGkiIAoJY2xpZW50U3RhdGU9IlBST0RVQ1RJVkUiIAoJc2ZUcmVlTWVyZ2U9IkF1
dG9tYXRpYyIgCgl2YWxpZGF0ZVZlaGljbGU9InRydWUiIAoJZG9jdW1lbnRWZXJzaW9uPSIyIj4K
CTxzZmdfY2xpZW50OmNsaWVudERpZ2lMYW5ndWFnZU1hcHBpbmdzPgoJCTxzZmdfY2xpZW50OmNs
aWVudERpZ2lMYW5ndWFnZU1hcHBpbmcgbGFuZ3VhZ2VDb2RlPSJmciIgZGVmYXVsdExhbmd1YWdl
PSJmYWxzZSIvPgoJCTxzZmdfY2xpZW50OmNsaWVudERpZ2lMYW5ndWFnZU1hcHBpbmcgbGFuZ3Vh
Z2VDb2RlPSJubCIgZGVmYXVsdExhbmd1YWdlPSJ0cnVlIi8+Cgk8L3NmZ19jbGllbnQ6Y2xpZW50
RGlnaUxhbmd1YWdlTWFwcGluZ3M+Cgk8c2ZnX2NsaWVudDpjbGllbnRMYW5ndWFnZU1hcHBpbmdz
PgoJCTxzZmdfY2xpZW50OmNsaWVudExhbmd1YWdlTWFwcGluZyBsYW5ndWFnZUNvZGU9ImVuIiBp
c0RlZmF1bHRMYW5ndWFnZT0idHJ1ZSIvPgoJPC9zZmdfY2xpZW50OmNsaWVudExhbmd1YWdlTWFw
cGluZ3M+CgkKCTxzZmdfY2xpZW50OmRpZ2l0YWxXYXJuaW5nTWVzc2FnZXM+CgkJPHNmZ19jbGll
bnQ6ZGlnaXRhbFdhcm5pbmdNZXNzYWdlIG1lc3NhZ2VJZD0iNTAxIiBsYW5ndWFnZUNvZGU9ImZy
Ij4KCQkJPHNmZ19jbGllbnQ6dGV4dD5EbXkgNTAxIEVOIE1zZyAtICVzPC9zZmdfY2xpZW50OnRl
eHQ+CgkJPC9zZmdfY2xpZW50OmRpZ2l0YWxXYXJuaW5nTWVzc2FnZT4KCQk8c2ZnX2NsaWVudDpk
aWdpdGFsV2FybmluZ01lc3NhZ2UgbWVzc2FnZUlkPSI1MDEiIGxhbmd1YWdlQ29kZT0ibmwiPgoJ
CQk8c2ZnX2NsaWVudDp0ZXh0PkRteSA1MDEgRU4gTXNnIC0gJXM8L3NmZ19jbGllbnQ6dGV4dD4K
CQk8L3NmZ19jbGllbnQ6ZGlnaXRhbFdhcm5pbmdNZXNzYWdlPgoJCTxzZmdfY2xpZW50OmRpZ2l0
YWxXYXJuaW5nTWVzc2FnZSBtZXNzYWdlSWQ9IjUwMiIgbGFuZ3VhZ2VDb2RlPSJmciI+CgkJCTxz
ZmdfY2xpZW50OnRleHQ+RG15IDUwMiBFTiBNc2cgLSAlczwvc2ZnX2NsaWVudDp0ZXh0PgoJCTwv
c2ZnX2NsaWVudDpkaWdpdGFsV2FybmluZ01lc3NhZ2U+CgkJPHNmZ19jbGllbnQ6ZGlnaXRhbFdh
cm5pbmdNZXNzYWdlIG1lc3NhZ2VJZD0iNTAyIiBsYW5ndWFnZUNvZGU9Im5sIj4KCQkJPHNmZ19j
bGllbnQ6dGV4dD5EbXkgNTAyIEVOIE1zZyAtICVzPC9zZmdfY2xpZW50OnRleHQ+CgkJPC9zZmdf
Y2xpZW50OmRpZ2l0YWxXYXJuaW5nTWVzc2FnZT4KCTwvc2ZnX2NsaWVudDpkaWdpdGFsV2Fybmlu
Z01lc3NhZ2VzPgo8L3NmZ19jbGllbnQ6Y2xpZW50Pgo=</file></config>
:)
let $document-as-string := util:base64-decode($post-data//file)
return
    if ($document-as-string='') then
        <error>
          <document-as-string>{$document-as-string}</document-as-string>
        </error>
    else
        let $document := util:parse($document-as-string)
        let $xslt := doc(concat($ct-home-db,'/tools/tools_normalize-xml.xsl'))
        let $result := transform:transform($document, $xslt, ())
        return    
            <result>{$result}</result>
