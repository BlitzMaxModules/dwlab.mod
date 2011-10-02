'
' Word converter to version 1.2 - Digital Wizard's Lab tool
' Copyright (C) 2011, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Import dwlab.frmwork

Local FileName:String = RequestFile( "Select world file to convert", "lw" )
If Not FileName Then End
Local XMLObject:LTXMLObject = LTXMLObject.ReadFromFile( FileName )
Process( XMLObject )
If Not RenameFile( FileName, FileName + ".bak" ) Then End
XMLObject.WriteToFile( FileName )

Function Process( XMLObject:LTXMLObject )
	If XMLObject.Name = "ltSprite" Then
		XMLObject.Name = "ltsprite"
	ElseIf XMLObject.Name = "ltvectorsprite" Then
		XMLObject.Name = "ltsprite"
		Local DX:Double = XMLObject.GetAttribute( "dx" ).ToDouble()
		Local DY:Double = XMLObject.GetAttribute( "dy" ).ToDouble()
		XMLObject.SetAttribute( "angle", ATan2( DY, DX ) )
		XMLObject.SetAttribute( "velocity", L_Distance( DY, DX ) )
		XMLObject.RemoveAttribute( "dx" )
		XMLObject.RemoveAttribute( "dy" )
	End If
	For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
		Process( ChildXMLObject )
	Next
End Function
