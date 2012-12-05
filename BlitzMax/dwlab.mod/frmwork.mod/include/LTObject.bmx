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
Global L_MaxID:Int
Global L_IDArray:LTObject[]
Global L_UndefinedObjects:TMap

Global L_NewTotalLoadingTime:Int
Global L_LoadingTime:Int
Global L_TotalLoadingTime:Int
Global L_LoadingProgress:Float
Global L_LoadingStatus:String
Global L_LoadingUpdater:LTObject = Null

Rem
bbdoc: Global object class
End Rem
Type LTObject
	Method Act()
	End Method
	

	
	Rem
	bbdoc: Method for updating object.
	End Rem
	Method Update()
	End Method
	
	' ==================== Loading / saving ===================

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
	End Method
	

	
	Global ObjectFileName:String

	Rem
	bbdoc: Loads object with all contents from file.
	about: See also: #SaveToFile, #XMLIO
	End Rem
	Function LoadFromFile:LTObject( FileName:String, UseIncbin:Int = -1, XMLObject:LTXMLObject = Null )
		ObjectFileName = FileName
		LTTileMap.MaxTileMapNum = 0
	
		Local IncbinValue:String = ""
		Select UseIncbin
			Case -1; IncbinValue = L_Incbin
			Case 1; IncbinValue = "incbin::"
		End Select
		
		If Not XMLObject Then
			L_MaxID = 0
			XMLObject = LTXMLObject.ReadFromFile( IncbinValue + FileName )
		End If
			
		L_LoadingStatus = "Serializing objects..."
		L_TotalLoadingTime = XMLObject.GetAttribute( "total-loading-time" ).ToInt()
		L_NewTotalLoadingTime = 0
		
		L_IDArray = New LTObject[ L_MaxID + 1 ]
		FillIDArray( XMLObject )
		Local Obj:LTObject = LTObject( TTypeId.ForName( XMLObject.Name ).NewObject() )
		
		L_XMLMode = L_XMLGet
		Obj.XMLIO( XMLObject )
		
		Return Obj
	End Function

	
	
	Function FillIDArray( XMLObject:LTXMLObject )
		If XMLObject.Name = "object" Then Return
		Local ID:Int = XMLObject.GetAttribute( "id" ).ToInt()
		If ID Then L_IDArray[ ID ] = LTObject( TTypeId.ForName( XMLObject.Name ).NewObject() )
		For Local Child:LTXMLObject = Eachin XMLObject.Children
			FillIDArray( Child )
		Next
		For Local ObjectField:LTXMLObjectField = Eachin XMLObject.Fields
			FillIDArray( ObjectField.Value )
		Next
	End Function
	


	Rem
	bbdoc: Saves object with all contents to file.
	about: See also: #LoadFromFile, #XMLIO
	End Rem
	Method SaveToFile( FileName:String )
		ObjectFileName = FileName
		L_IDMap = New TMap
		L_RemoveIDMap = New TMap
		L_MaxID = 1
		
		L_XMLMode = L_XMLSet
		Local XMLObject:LTXMLObject = New LTXMLObject
		L_UndefinedObjects = New TMap
		XMLIO( XMLObject )
		
		XMLObject.SetAttribute( "dwlab_version", L_Version )
		XMLObject.SetAttribute( "total-loading-time", L_NewTotalLoadingTime )
				
		For Local XMLObject2:LTXMLObject = EachIn L_RemoveIDMap.Values()
			For Local Attr:LTXMLAttribute = EachIn XMLObject2.Attributes
				If Attr.Name = "id" Then XMLObject2.Attributes.Remove( Attr )
			Next
		Next
		
		L_IDMap = Null
		L_RemoveIDMap = Null
		
		XMLObject.WriteToFile( FileName )
	End Method
End Type