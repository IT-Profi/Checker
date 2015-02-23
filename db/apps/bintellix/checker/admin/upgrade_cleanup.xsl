<!-- 
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
(c) 2010-2015 by InterSecurity GmbH & Co. KG, Germany
========================================================================
@Author: Eduard Huber
@Version: 1.0
======================================================================== 
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cs="http://checker.bintellix.de/checkset/" exclude-result-prefixes="" version="2.0"><xsl:output method="xml" indent="yes"/><xsl:template match="*[namespace-uri()='http://checker.bintellix.de/checkset/']"><xsl:element name="cs:{local-name()}" namespace="http://checker.bintellix.de/checkset/"><xsl:copy-of select="@*"/><xsl:apply-templates/></xsl:element></xsl:template><xsl:template match="node()|@*" priority="-1"><xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy></xsl:template></xsl:stylesheet>