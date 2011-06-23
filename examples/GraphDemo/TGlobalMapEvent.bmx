'
' Graph usage demo - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TGlobalMapEvent Extends LTSprite
	Field Probability:Double
	Field Caption:String
	
	
	
	Method DrawInfo( ForPivot:LTSprite )
		Game.Font.Print( Caption + " ( " + L_TrimDouble( Probability * 100.0 ) + "% )", ForPivot.X + 5, ForPivot.Y, 1.0, LTAlign.ToRight, LTAlign.ToCenter )
	End Method
	
	
	
	Method Execute()
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageDoubleAttribute( "probability", Probability )
		XMLObject.ManageStringAttribute( "caption", Caption )
	End Method
End Type