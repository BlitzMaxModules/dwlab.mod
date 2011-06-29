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

Rem
bbdoc: Global object class
End Rem
Type LTObject
	Rem
	bbdoc: Name of the object.
	End Rem
	Field Name:String
	

	
	Rem
	bbdoc: Retrieving object's name part.
	returns: Part of the name for given index (parts are separated by commas). 
	about: First part index is 1.
	End Rem
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

	Rem
	bbdoc: Method for loading / saving object.
	about: This method is for storing object fields into XML object for saving and retrieving object fields from XML object for loading.
	You can put different XMLObject commands and your own algorithms for loading / saving data structures here.
	
	See also: #ManageChildArray, #ManageChildList, #ManageDoubleAttribute, #ManageIntArrayAttribute
	#ManageIntAttribute, #ManageListField, #ManageObjectArrayField, #ManageObjectAttribute, #ManageObjectField
	#ManageObjectMapField, #ManageStringAttribute 
	End Rem
	Method XMLIO( XMLObject:LTXMLObject )
		If L_XMLMode = L_XMLSet Then XMLObject.Name = TTypeId.ForObject( Self ).Name()
		XMLObject.ManageStringAttribute( "name", Name )
	End Method
	


	Rem
	bbdoc: Loads object with all contents from file.
	about: See also: #SaveToFile, #XMLIO
	End Rem
	Function LoadFromFile:LTObject( FileName:String )
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



	Rem
	bbdoc: Saves object with all contents to file.
	about: See also: #LoadFromFile, #XMLIO
	End Rem
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