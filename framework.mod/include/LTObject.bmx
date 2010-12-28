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
Global L_NameForObjectMap:TMap = New TMap
Global L_ObjectForNameMap:TMap = New TMap
Global L_IncludedObjects:TMap = New TMap

Type LTObject

	' ==================== Name ===================
	
	Method GetName:String()
		Return String( L_NameForObjectMap.ValueForKey( Self ) )
	End Method
	
	
	
	Method SetName( NewName:String )
		?debug
		Local Name:String = String( L_ObjectForNameMap.ValueForKey( NewName ) )
		L_Assert( Name = "", "Name already exists" )
		?
		
		L_NameForObjectMap.Insert( Self, NewName )
		L_ObjectForNameMap.Insert( NewName, Self )
	End Method
	
	
	
	Method ClearName()
		L_ObjectForNameMap.Remove( GetName() )
		L_NameForObjectMap.Remove( Self )
	End Method
	
	
	
	Function FindByName:LTObject( Name:String )
		Return LTObject( L_ObjectForNameMap.ValueForKey( Name ) )
	End Function

	' ==================== loading / saving ===================

	Method XMLIO( XMLObject:LTXMLObject )
		If L_XMLMode = L_XMLGet Then
			Local Name:String = GetName()
			If Name Then XMLObject.SetAttribute( "name", Name )
		Else
			XMLObject.Name = TTypeId.ForObject( Self ).Name()
			Local Name:String = XMLObject.GetAttribute( "name" )
			If Name Then SetName( Name )
		End If
	End Method



	Method SaveToFile( FileName:String )
		L_IDMap = New TMap
		L_RemoveIDMap = New TMap
		L_DefinitionsMap = New TMap
		L_IDNum = 1
		
		L_Definitions = New LTXMLObject
		L_Definitions.Name = "TList"
		
		For Local KeyValue:TKeyValue = Eachin L_IncludedObjects
			Local XMLObject:LTXMLObject = New LTXMLObject
			XMLObject.Name = "Include"
			XMLObject.SetAttribute( "id", L_IDNum )
			XMLObject.SetAttribute( "name", String( KeyValue.Key() ) )
			L_Definitions.Children.AddLast( XMLObject )
			L_IDMap.Insert( KeyValue.Value(), String( L_IDNum ) )
			L_IDNum :+ 1
		Next
		
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





Function L_ObjectForName:LTObject( Name:String )
	Return LTObject( L_ObjectForNameMap.ValueForKey( Name ) )
End Function





Function L_ClearNames()
	L_ObjectForNameMap.Clear()
	L_NameForObjectMap.Clear()
End Function