'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_IDMap:TMap
Global L_RemoveIDMap:TMap
Global L_DefinitionsMap:TMap
Global L_Definitions:LTXMLObject
Global L_IDNum:Int
Global L_IDArray:LTObject[]
Global LayerName:String

Type LTObject
	Field Name:String
	

	
	Method GetNamePart:String( Num:Int = 1 )
		Local PartStart:Int = 0
		Local PartNum:Int = 1
		For Local Sym:Int = 0 Until Len( Name )
			if Name[ Sym ] = Asc( "," ) Then
				If PartNum = Num Then Return Name[ PartStart..Sym ]
				PartNum :+ 1
				PartStart = Sym + 1
			End If
		Next
		If PartNum = Num Then Return Name[ PartStart.. ]
		Return ""
	End Method

	' ==================== loading / saving ===================

	Method XMLIO( XMLObject:LTXMLObject )
		If L_XMLMode = L_XMLSet Then XMLObject.Name = TTypeId.ForObject( Self ).Name()
		XMLObject.ManageStringAttribute( "name", Name )
	End Method



	Method SaveToFile( FileName:String )
		L_IDMap = New TMap
		L_RemoveIDMap = New TMap
		L_DefinitionsMap = New TMap
		L_IDNum = 1
		
		L_Definitions = New LTXMLObject
		L_Definitions.Name = "TList"
		
		L_XMLMode = L_XMLSet
		Local XMLObject:LTXMLObject = New LTXMLObject
		XMLIO( XMLObject )
		
		XMLObject.SetAttribute( "dwlab_version", L_Version )
		XMLObject.SetField( "definitions", L_Definitions )
				
		For Local XMLObject:LTXMLObject = EachIn L_RemoveIDMap.Values()
			For Local Attr:LTXMLAttribute = EachIn XMLObject.Attributes
				If Attr.Name = "id" Then XMLObject.Attributes.Remove( Attr )
			Next
		Next
		
		L_IDMap = Null
		L_RemoveIDMap = Null
		
		XMLObject.WriteToFile( FileName )
	End Method
End Type
	
	


Function L_LoadFromFile:LTObject( FileName:String )
	L_IDNum = 0
	Local XMLObject:LTXMLObject = LTXMLObject.ReadFromFile( FileName )
	
	L_IDArray = New LTObject[ L_IDNum + 1 ]
	
	Local List:TList = New TList
	XMLObject.ManageListField( "definitions", List )
	
	Local Obj:LTObject = LTObject( TTypeId.ForName( XMLObject.Name ).NewObject() )
	
	L_XMLMode = L_XMLGet
	Obj.XMLIO( XMLObject )
	
	Return Obj
End Function