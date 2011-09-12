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
if Not RenameFile( FileName, FileName + ".bak" ) Then End
XMLObject.WriteToFile( FileName )

Function Process( XMLObject:LTXMLObject )
	Local Name:String = XMLObject.GetAttribute( "name" )
	If Name And XMLObject.Name <> "lttileset" And XMLObject.Name <> "lttilecategory" Then
		Local CommaPos:Int = Name.Find( "," )
	
		XMLObject.RemoveAttribute( "name" )
		Local Parameters:LTXMLObject = New LTXMLObject
		Parameters.Name = "list"
		
		Local ClassName:String = Name
		If CommaPos >= 0 Then ClassName = Name[ ..CommaPos ]
		If ClassName.ToLower() <> XMLObject.Name Then 
			Local Parameter:LTXMLObject = New LTXMLObject
			Parameter.Name = "ltparameter"
			Parameter.SetAttribute( "name", "class" )
			Parameters.Children.AddLast( Parameter ) 
			Parameter.SetAttribute( "value", ClassName )
		End If
		
		If CommaPos >= 0 Then
			Parameter = New LTXMLObject
			Parameter.Name = "ltparameter"
			Parameter.SetAttribute( "name", "name" )
			Parameter.SetAttribute( "value", Name[ CommaPos + 1.. ] )
			Parameters.Children.AddLast( Parameter) 
		End If 
		
		XMLObject.SetField( "parameters", Parameters )
	End If
	For Local ChildXMLObject:LTXMLObject = Eachin XMLObject.Children
		Process( ChildXMLObject )
	Next
End Function
