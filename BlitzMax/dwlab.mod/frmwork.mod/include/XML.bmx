'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_XMLMode:Int
Global L_XMLVersion:Int

Const L_XMLGet:Int = 0
Const L_XMLSet:Int = 1

Rem
bbdoc: Class for intermediate objects to save/load objects from XML file.
about: When you load framework object from XML file this file firstly will be transformed to the structure consisting of XMLObjects.
During next step new objects will be created and filled with information using this XMLObjects structure.
When you save object to XML file, the system firstly creates a XMLObjects structure and unloads all information there, then save this structure to file. 
End Rem
Type LTXMLObject Extends LTObject
	Field Name:String
	Field Attributes:TList = New TList
	Field Children:TList = New TList
	Field Fields:TList = New TList
	Field Closing:Int = False
	
	
	
	Rem
	bbdoc: Cheks if attribute with specified name exists.
	returns: True if attribute exists.
	about: See also: #GetAttribute, #SetAttribute, #RemoveAttribulte
	End Rem
	Method AttributeExists:Int( AttrName:String )
		For Local Attr:LTXMLAttribute = EachIn Attributes
			If Attr.Name = AttrName Then Return True
		Next
	End Method
	
	
	
	Rem
	bbdoc: Returns value of XMLObject attribute with given name.
	returns: Attribute string value.
	about: See also: #AttributeExists, #SetAttribute, #RemoveAttribulte
	End Rem
	Method GetAttribute:String( AttrName:String )
		For Local Attr:LTXMLAttribute = EachIn Attributes
			If Attr.Name = AttrName Then Return Attr.Value
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets value of XMLObject attribute with given name.
	about: See also: #AttributeExists, #GetAttribute, #RemoveAttribulte
	End Rem
	Method SetAttribute( AttrName:String, AttrValue:String)
		For Local Attr:LTXMLAttribute = EachIn Attributes
			If Attr.Name = AttrName Then
				Attr.Value = AttrValue
				Return
			End If
		Next
		
		Local Attr:LTXMLAttribute = New LTXMLAttribute
		Attr.Name = AttrName
		Attr.Value = AttrValue
		Attributes.AddLast( Attr )
	End Method
	
	
	
	Rem
	bbdoc: Removes attribute with given name of XMLObject.
	about: See also: #AttributeExists, #GetAttribute, #SetAttribute
	End Rem
	Method RemoveAttribute:String( AttrName:String )
		Local Link:TLink = Attributes.FirstLink()
		While Link
			If LTXMLAttribute( Link.Value() ).Name = AttrName Then Link.Remove()
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Rem
	bbdoc: Cheks if field with specified name exists.
	returns: True if field exists.
	about: See also: #GetField, #SetField, #RemoveField
	End Rem
	Method FieldExists:Int( FieldName:String )
		Return GetField( FieldName ) <> Null
	End Method
	
	
	
	Rem
	bbdoc: Returns XMLObject which is the field with given name of current XMLObject.
	returns: XMLObject representing a field.
	about: See also: #SetField
	End Rem
	Method GetField:LTXMLObject( FieldName:String )
		For Local ObjectField:LTXMLObjectField = EachIn Fields
			If ObjectField.Name = FieldName Then Return ObjectField.Value
		Next	
	End Method
	
	
	
	Rem
	bbdoc: Sets value of the field with given name to given XMLObject.
	about: See also: #GetField
	End Rem
	Method SetField:LTXMLObjectField( FieldName:String, XMLObject:LTXMLObject )
		Local ObjectField:LTXMLObjectField = New LTXMLObjectField
		ObjectField.Name = FieldName
		ObjectField.Value = XMLObject
		Fields.AddLast( ObjectField )
		Return ObjectField
	End Method
	
	
	
	Rem
	bbdoc: Removes field with given name of XMLObject.
	about: See also: #FieldExists, #GetField, #SetField
	End Rem
	Method RemoveField:String( FieldName:String )
		Local Link:TLink = Fields.FirstLink()
		While Link
			If LTXMLObjectField( Link.Value() ).Name = FieldName Then Link.Remove()
			Link = Link.NextLink()
		Wend
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object field with Int type.
	about: See also: #ManageDoubleAttribute, #ManageStringAttribute, #ManageObjectAttribute, #ManageIntArrayAttribute, #XMLIO example
	End Rem
	Method ManageIntAttribute( AttrName:String, AttrVariable:Int Var, DefaultValue:Int = 0 )
		If L_XMLMode = L_XMLGet Then
			For Local Attr:LTXMLAttribute = EachIn Attributes
				If Attr.Name = AttrName Then
					AttrVariable = Attr.Value.ToInt()
					Return
				End If
			Next
			AttrVariable = DefaultValue
		ElseIf AttrVariable <> DefaultValue Then
			SetAttribute( AttrName, String( AttrVariable ) )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object field with Double type.
	about: See also: #ManageIntAttribute, #ManageStringAttribute, #ManageObjectAttribute, #XMLIO example
	End Rem
	Method ManageDoubleAttribute( AttrName:String, AttrVariable:Double Var, DefaultValue:Double = 0.0:Double )
		If L_XMLMode = L_XMLGet Then
			For Local Attr:LTXMLAttribute = EachIn Attributes
				If Attr.Name = AttrName Then
					AttrVariable = Attr.Value.ToDouble()
					Return
				End If
			Next
			AttrVariable = DefaultValue
		ElseIf AttrVariable <> DefaultValue Then
			SetAttribute( AttrName, String( L_TrimDouble( AttrVariable, 8 ) ) )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object field with String type.
	about: See also: #ManageIntAttribute, #ManageDoubleAttribute, #ManageObjectAttribute, #XMLIO example
	End Rem
	Method ManageStringAttribute( AttrName:String, AttrVariable:String Var )
		If L_XMLMode = L_XMLGet Then
			For Local Attr:LTXMLAttribute = EachIn Attributes
				If Attr.Name = AttrName Then
					AttrVariable = Attr.Value
					Return
				End If
			Next
		ElseIf AttrVariable Then
			SetAttribute( AttrName, AttrVariable )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object field wit LTObject type.
	returns: Loaded object or same object for saving mode.
	about: Use "ObjField = ObjFieldType( ManageObjectAttribute( FieldName, ObjField ) )" command syntax.
	
	See also: #ManageIntAttribute, #ManageDoubleAttribute, #ManageStringAttribute, #ManageObjectField, #ManageChildArray
	End Rem
	Method ManageObjectAttribute:LTObject( AttrName:String, Obj:LTObject )
		If L_XMLMode = L_XMLGet Then
			'debugstop
			Local ID:Int = GetAttribute( AttrName ).ToInt()
			If Not ID Then Return Obj
			
			Obj = L_IDArray[ ID ]
			
			?debug
			If Obj = Null Then L_Error( "Object with id " + ID + " not found" )
			?
		ElseIf Obj Then
			Local ID:String = String( L_IDMap.ValueForKey( Obj ) )
			
			If Not ID Then
				ID = String( L_MaxID )
				L_IDMap.Insert( Obj, ID )
				L_MaxID :+ 1
				L_UndefinedObjects.Insert( Obj, Null )
			End If
			L_RemoveIDMap.Remove( Obj )
		
			SetAttribute( AttrName, ID )
		End If
		Return Obj
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object field with Int[] type.
	about: See also: #ManageIntAttribute
	End Rem
	Method ManageIntArrayAttribute( AttrName:String, IntArray:Int[] Var, ChunkLength:Int = 0 )
		If L_XMLMode = L_XMLGet Then
			Local Data:String = GetAttribute( AttrName )
			If Not Data Then Return
			If ChunkLength Then
				IntArray = New Int[ Data.Length / ChunkLength ]
				Local Pos:Int = 0
				Local N:Int = 0
				While Pos < Data.Length
					IntArray[ N ] = L_Decode( Data[ Pos..Pos + ChunkLength ] )
					Pos :+ ChunkLength
					N :+ 1
				Wend
			Else
				Local Values:String[] = Data.Split( "," )
				Local Quantity:Int = Values.Dimensions()[ 0 ]
				IntArray = New Int[ Quantity ]
				For Local N:Int = 0 Until Quantity
					IntArray[ N ] = Values[ N ].ToInt()
				Next
			End If
		Elseif IntArray Then
			Local Values:String = ""
			For Local N:Int = 0 Until IntArray.Dimensions()[ 0 ]
				if ChunkLength Then
					Values :+ L_Encode( IntArray[ N ], ChunkLength )
				Else
					If Values Then Values :+ ","
					Values :+ IntArray[ N ]
				End If
			Next
			SetAttribute( AttrName, Values )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject field and framework object field with LTObject type.
	about: See also: #XMLIO example
	End Rem
	Method ManageObjectField:LTObject( FieldName:String, FieldObject:LTObject)
		If L_XMLMode = L_XMLGet Then
			Local XMLObject:LTXMLObject = GetField( FieldName )
			
			If Not XMLObject Then Return FieldObject

			Return XMLObject.ManageObject( FieldObject )
		ElseIf FieldObject Then
		
			If FieldObject Then
				Local XMLObject:LTXMLObject = New LTXMLObject
				XMLObject.ManageObject( FieldObject )
				SetField( FieldName, XMLObject )
			End If
			
			Return FieldObject
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object field with TList type.
	about: See also: #ManageChildList, #XMLIO example
	End Rem
	Method ManageListField( FieldName:String, List:TList Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLObject:LTXMLObject = GetField( FieldName )
			If Not XMLObject Then Return
			If XMLObject Then XMLObject.ManageChildList( List )
		ElseIf List Then
			If List.IsEmpty() Then Return
			Local XMLObject:LTXMLObject = New LTXMLObject
			XMLObject.Name = "TList"
			XMLObject.ManageChildList( List )
			SetField( FieldName, XMLObject )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object field with LTObject[] type.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectMapField
	End Rem
	Method ManageObjectArrayField( FieldName:String, Array:LTObject[] Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLArray:LTXMLObject = GetField( FieldName )
			If Not XMLArray Then Return
			If XMLArray Then XMLArray.ManageChildObjectArray( Array )
		ElseIf Array Then
			Local XMLArray:LTXMLObject = New LTXMLObject
			XMLArray.Name = "Array"
			XMLArray.ManageChildObjectArray( Array )
			SetField( FieldName, XMLArray )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject field and framework object field with TMap type filled with LTObject-LTObject pairs.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectArrayField
	End Rem
	Method ManageObjectMapField( FieldName:String, Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLMap:LTXMLObject = GetField( FieldName )
			If Not XMLMap Then Return
			If XMLMap Then XMLMap.ManageChildObjectMap( Map )
		ElseIf Map Then
			If Map.IsEmpty() Then Return
			Local XMLMap:LTXMLObject = New LTXMLObject
			XMLMap.Name = "Map"
			XMLMap.ManageChildObjectMap( Map )
			SetField( FieldName, XMLMap )
		End If
	End Method
	
	
	
	Method ManageStringObjectMapField( FieldName:String, Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLMap:LTXMLObject = GetField( FieldName )
			If Not XMLMap Then Return
			If XMLMap Then XMLMap.ManageChildStringObjectMap( Map )
		ElseIf Map Then
			If Map.IsEmpty() Then Return
			Local XMLMap:LTXMLObject = New LTXMLObject
			XMLMap.Name = "Map"
			XMLMap.ManageChildStringObjectMap( Map )
			SetField( FieldName, XMLMap )
		End If
	End Method
	
	
	
	Method ManageStringMapField( FieldName:String, Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLMap:LTXMLObject = GetField( FieldName )
			If Not XMLMap Then Return
			If XMLMap Then XMLMap.ManageChildStringMap( Map )
		ElseIf Map Then
			If Map.IsEmpty() Then Return
			Local XMLMap:LTXMLObject = New LTXMLObject
			XMLMap.Name = "Map"
			XMLMap.ManageChildStringMap( Map )
			SetField( FieldName, XMLMap )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject field and framework object field with TMap type filled with LTObject-LTObject pairs.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectArrayField
	End Rem
	Method ManageObjectSetField( FieldName:String, Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLMap:LTXMLObject = GetField( FieldName )
			If Not XMLMap Then Return
			If XMLMap Then XMLMap.ManageChildObjectSet( Map )
		ElseIf Map Then
			If Map.IsEmpty() Then Return
			Local XMLMap:LTXMLObject = New LTXMLObject
			XMLMap.Name = "Set"
			XMLMap.ManageChildObjectSet( Map )
			SetField( FieldName, XMLMap )
		End If
	End Method
	
	
	
	Method ManageObject:LTObject( Obj:LTObject )
		If L_XMLMode = L_XMLGet Then
			Local ID:Int = GetAttribute( "id" ).ToInt()
				
			If Name = "object" Then
				Obj = L_IDArray[ ID ]
			Else
				If ID And L_IDArray[ ID ] Then
					Obj = L_IDArray[ ID ]
					'debugstop
				Else
					Local TypeID:TTypeId = TTypeId.ForName( Name )
					
					?debug
					If TypeID = Null Then L_Error( "Object ~q" + Name + "~q not found" )
					?
					
					Obj = LTObject( TypeID.NewObject() )
				End If
				Obj.XMLIO( Self )
			End If
			
			?debug
			If Obj = Null Then L_Error( "Object with ID " + ID + " not found." )
			?
			
			Return Obj
		ElseIf Obj Then
			Local ID:String = String( L_IDMap.ValueForKey( Obj ) )
			Local Undefined:Int = L_UndefinedObjects.Contains( Obj )
			If ID And Not Undefined Then
				L_RemoveIDMap.Remove( Obj )
				Name = "Object"
				SetAttribute( "id", ID )
				Return Obj
			Else
				If Not LTXMLObject( Obj ) And Not Undefined Then
					ID = String( L_MaxID )
					L_IDMap.Insert( Obj, ID )
					L_MaxID :+ 1
					L_RemoveIDMap.Insert( Obj, Self )
				End If
				
				SetAttribute( "id", ID )

				Obj.XMLIO( Self )
			End If
		End If
		
		Return Obj
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object field with TList type.
	about: See also: #ManageListField, #ManageChildArray, #XMLIO example
	End Rem
	Method ManageChildList( List:TList Var )
		'debugstop
		If L_XMLMode = L_XMLGet Then
			List = New TList
			For Local XMLObject:LTXMLObject = EachIn Children
				List.AddLast( XMLObject.ManageObject( Null ) )
			Next
		ElseIf List Then
			Children.Clear()
			For Local Obj:LTObject = EachIn List
				Local XMLObject:LTXMLObject = New LTXMLObject
				XMLObject.ManageObject( Obj )
				Children.AddLast( XMLObject )
			Next
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object parameter with LTObject[] type.
	about: See also: #ManageChildList, #ManageListField
	End Rem
	Method ManageChildObjectArray( ChildArray:LTObject[] Var )
		If L_XMLMode = L_XMLGet Then	
			If L_XMLVersion < 01043200 Then
				ChildArray = New LTObject[ Children.Count() ]
				Local N:Int = 0
				For Local XMLObject:LTXMLObject = EachIn Children
					If XMLObject.Name <> "null" Then ChildArray[ N ] = XMLObject.ManageObject( Null )
					N :+ 1
				Next
			Else
				ChildArray = New LTObject[ GetAttribute( "size" ).ToInt() ]
				For Local XMLObject:LTXMLObject = EachIn Children
					ChildArray[ XMLObject.GetAttribute( "index" ).ToInt() ] = XMLObject.ManageObject( Null )
				Next
			End If
		Else
			SetAttribute( "size", ChildArray.Length )
			For Local N:Int = 0 Until ChildArray.Length
				If ChildArray[ N ] Then
					Local XMLObject:LTXMLObject = New LTXMLObject
					XMLObject.ManageObject( ChildArray[ N ] )
					XMLObject.SetAttribute( "index", N )
					Children.AddLast( XMLObject )
				End If
			Next
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object field with TMap type filled with LTObject-LTObject pairs.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectArrayField
	End Rem
	Method ManageChildObjectMap( Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Map = New TMap
			For Local XMLObject:LTXMLObject = Eachin Children
				Local Key:LTObject = Null
				XMLObject.ManageObjectAttribute( "key", Key )
				Map.Insert( Key, XMLObject.ManageObject( Null ) )
			Next
		Else
			For Local KeyValue:TKeyValue = Eachin Map
				Local XMLValue:LTXMLObject = New LTXMLObject
				XMLValue.Name = "Pair"
				XMLValue.ManageObject( LTObject( KeyValue.Value() ) )
				Local Key:LTObject = LTObject( KeyValue.Key() )
				XMLValue.ManageObjectAttribute( "key", Key )
				Children.AddLast( XMLValue )
			Next
		End If
	End Method
	
	
	
	Method ManageChildStringObjectMap( Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Map = New TMap
			For Local XMLObject:LTXMLObject = Eachin Children
				Map.Insert( XMLObject.GetAttribute( "key" ), XMLObject.ManageObject( Null ) )
			Next
		Else
			For Local KeyValue:TKeyValue = Eachin Map
				Local XMLValue:LTXMLObject = New LTXMLObject
				XMLValue.Name = "Pair"
				XMLValue.ManageObject( LTObject( KeyValue.Value() ) )
				XMLValue.SetAttribute( "key", String( KeyValue.Key() ) )
				Children.AddLast( XMLValue )
			Next
		End If
	End Method
	
	
	
	Method ManageChildStringMap( Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Map = New TMap
			For Local XMLObject:LTXMLObject = Eachin Children
				Map.Insert( XMLObject.GetAttribute( "key" ), XMLObject.GetAttribute( "value" ) )
			Next
		Else
			For Local KeyValue:TKeyValue = Eachin Map
				Local XMLValue:LTXMLObject = New LTXMLObject
				XMLValue.Name = "Pair"
				XMLValue.SetAttribute( "value", String( KeyValue.Value() ) )
				XMLValue.SetAttribute( "key", String( KeyValue.Key() ) )
				Children.AddLast( XMLValue )
			Next
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object field with TMap type filled with LTObject keys.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectArrayField
	End Rem
	Method ManageChildObjectSet( Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Map = New TMap
			For Local XMLObject:LTXMLObject = Eachin Children
				Map.Insert( XMLObject.ManageObject( Null ), Null )
			Next
		Else
			For Local Obj:LTObject = Eachin Map.Keys()
				Local XMLValue:LTXMLObject = New LTXMLObject
				XMLValue.ManageObject( Obj )
				Children.AddLast( XMLValue )
			Next
		End If
	End Method
	

	
	Global L_EscapingBackslash:Int = 0
	
	Function ReadFromFile:LTXMLObject( Filename:String )
		Local File:TStream = ReadFile( Filename )
		Local Content:String = ""
		
		L_LoadingStatus = "Loading XML..."
		
		L_XMLVersion = 0
		While Not Eof( File )
			Content :+ ReadLine( File )
			If Not L_XMLVersion Then L_XMLVersion = L_VersionToInt( GetAttributeFromString( Content, "dwlab_version" ) )
			L_LoadingProgress = 1.0 * StreamPos( File ) / StreamSize( File )
			If L_LoadingUpdater Then L_LoadingUpdater.Update()
		Wend
		
		CloseFile File
		
		Local N:Int = 0
		Local FieldName:String = ""
		
		L_LoadingStatus = "Parsing XML..."
		Return ReadObject( Content, N, FieldName )
	End Function
	
	
	
	Function GetAttributeFromString:String( Text:String, AttrName:String )
		Local Quote:Int = Text.Find( "~q", Text.Find( AttrName ) )
		Return Text[ Quote + 1..Text.Find( "~q", Quote + 1 ) ]
	End Function
	
	
	
	Method WriteToFile( Filename:String )
		Local File:TStream = WriteFile( FileName )
		WriteObject( File )
		CloseFile File
	End Method
	
	
	
	Function ReadObject:LTXMLObject( Txt:String Var, N:Int Var, FieldName:String Var )
		Local Obj:LTXMLObject = New LTXMLObject
		
		Obj.ReadAttributes( Txt, N, FieldName )
		
		If Not Obj.Closing Then
			Repeat
				Local ChildFieldName:String = ""
				Local Child:LTXMLObject = Obj.ReadObject( Txt, N, ChildFieldName )
				If Child.Closing = 2 Then
					If Child.Name = Obj.Name Then Return Obj
					
					?debug
					L_Error( "Error in XML file - wrong closing tag ~q" + Child.Name + "~q, expected ~q" + Obj.Name + "~q" )
					?
				ElseIf ChildFieldName Then
					Local ObjectField:LTXMLObjectField = New LTXMLObjectField
					ObjectField.Name = ChildFieldName
					ObjectField.Value = Child
					Obj.Fields.AddLast( ObjectField )
				Else
					Obj.Children.AddLast( Child )
				End If
			Forever
		End If

		L_LoadingProgress = 1.0 * N / Txt.Length
		If L_LoadingUpdater Then L_LoadingUpdater.Update()
				
		Return Obj
	End Function
	
	
	
	Method WriteObject( File:TStream, Indent:String = "" )
		Local St:String = Indent + "<" + Name
		For Local Attr:LTXMLAttribute = EachIn Attributes
			Local NewValue:String = ""
			For Local Num:Int = 0 Until Len( Attr.Value )
				Local CharNum:Int = Attr.Value[ Num ]
				Select CharNum
					Case Asc( "~q" ), Asc( "%" )
						NewValue :+ "%" + Chr( CharNum )
					Case Asc( "~n" )
						NewValue :+ "%n"
					Default
						If CharNum >= 128 Then 
							NewValue :+ L_UTF8ToASCII( CharNum )
						Else
							NewValue :+ Chr( CharNum )
						End If
				End Select
			Next
			St :+ " " + Attr.Name + "=~q" +NewValue + "~q"
		Next
		If Children.IsEmpty() And Fields.IsEmpty() Then
			WriteLine( File, St + "/>" )
		Else
			WriteLine( File, St + ">" )
			'debugstop
			For Local ObjectField:LTXMLObjectField = EachIn Fields
				Local Attr:LTXMLAttribute = New LTXMLAttribute
				Attr.Name = "field"
				Attr.Value = ObjectField.Name
				ObjectField.Value.Attributes.AddFirst( Attr )
				ObjectField.Value.WriteObject( File, Indent + "~t" )
			Next
			For Local XMLObject:LTXMLObject = EachIn Children
				XMLObject.WriteObject( File, Indent + "~t" )
			Next
			WriteLine( File, Indent + "</" + Name + ">" )
		End If
	End Method
	
	
	
	Method ReadAttributes( Txt:String Var, N:Int Var, FieldName:String Var )
		Local ReadingContents:Int = False
		Local ReadingName:Int = True
		Local ReadingValue:Int = False
		Local Quotes:Int = False
		Local ChunkBegin:Int = -1
	
		Local Attr:LTXMLAttribute = Null
		
		While N < Len( Txt )
			If Quotes Then
				If Quotes = Txt[ N ] Then
					Quotes = False
					Attr.Value = Txt[ ChunkBegin..N ]
					
					If Attr.Name = "field" Then
						FieldName = Attr.Value
					Else
						If Attr.Name = "id" Then L_MaxID = Max( L_MaxID, Attr.Value.ToInt() )
						Attributes.AddLast( Attr )
					End If
					
					ReadingValue = False
					ChunkBegin = -1
				ElseIf Txt[ N ] >= 128 And L_XMLVersion >= 01041800 Then
					'debugstop
					Local Pos:Int = N
					Local Chunk:String = L_ASCIIToUTF8( Txt, Pos )
					Txt = Txt[ ..N ] + Chunk + Txt[ Pos + 1.. ]
				ElseIf L_XMLVersion < 01041800 Then
					If Txt[ N ] = Asc( "\" ) Then
						Select Txt[ N + 1 ]
							Case Asc( "~q" ), Asc( "\" )
								Txt = Txt[ ..N ] + Txt[ N + 1.. ]
						End Select
					End If
				ElseIf Txt[ N ] = Asc( "%" ) Then
					Select Txt[ N + 1 ]
						Case Asc( "~q" ), Asc( "%" )
							Txt = Txt[ ..N ] + Txt[ N + 1.. ]
						Case Asc( "n" )
							Txt = Txt[ ..N ] + "~n" + Txt[ N + 2.. ]
					End Select
				End If
			Else
				If Txt[ N ] = Asc( "'" ) Or Txt[ N ] = Asc( "~q" ) Then
					?debug
					If Not ReadingValue Then L_Error( "Error in XML file - unexpected quotes: " + Txt[ ..N ] )
					?
					
					ChunkBegin = N + 1
					Quotes = Txt[ N ]
				ElseIf Txt[ N ] = Asc( "<" ) Then
					?debug
					If ReadingContents Or ReadingValue Then L_Error( "Error in XML file - unexpected beginning of tag" + Txt[ ..N ] )
					?
					
					ReadingContents = True
				ElseIf IDSym( Txt[ N ] ) Then
					If ChunkBegin < 0 Then ChunkBegin = N
					
					?debug
					If Closing And Not ReadingName Then L_Error( "Error in XML file - invalid closing tag: " + Txt[ ..N ] )
					?
				Else
					?debug
					If Txt[ N ] = Asc( "=" ) And ReadingName Or ReadingValue Then L_Error( "Error in XML file - unexpected ~q=~q: " + Txt[ ..N ] )
					?
					
					If ChunkBegin >= 0 Then
						If ReadingName Then
							Name = Txt[ ChunkBegin..N ].ToLower()
							ReadingName = False
						ElseIf ReadingValue Then
							Attr.Value = Txt[ ChunkBegin..N ]
							
							If Attr.Name = "field" Then
								FieldName = Attr.Value
							Else
								If Attr.Name = "id" Then L_MaxID = Max( L_MaxID, Attr.Value.ToInt() )
								Attributes.AddLast( Attr )
							End If
							
							ReadingValue = False
						Else
							Attr = New LTXMLAttribute
							Attr.Name = Txt[ ChunkBegin..N ].ToLower()
							ReadingValue = True
						End If
						ChunkBegin = -1
					End If
					
					If Txt[ N ] = Asc( "/" ) Then
						?debug
						If ReadingValue Or Closing  Then L_Error( "Error in XML file - unexpected slash: " + Txt[ ..N ] )
						?
						
						If ReadingName Then Closing = 2 Else Closing = 1
					End If
					
					If Txt[ N ] = Asc( ">" ) Then
						?debug
						If Not ReadingContents Or ReadingValue Or ReadingName Then L_Error("Error in XML file - unexpected end of tag: " + Txt[ ..N ] )
						?
						
						N :+ 1
						Return
					End If
				End If
			End If
			
			N :+ 1
		Wend
		DebugStop
	End Method
	
	
	
	Function IDSym:Int( Sym:Int )
		If Sym >= Asc( "a" ) And Sym <= Asc( "z" ) Then Return True
		If Sym >= Asc( "A" ) And Sym <= Asc( "Z" ) Then Return True
		If Sym >= Asc( "0" ) And Sym <= Asc( "9" ) Then Return True
		If Sym = Asc( "_" ) Or Sym = Asc( "-" ) Then Return True
	End Function
End Type





Type LTXMLAttribute
	Field Name:String
	Field Value:String
End Type





Type LTXMLObjectField
	Field Name:String
	Field Value:LTXMLObject
End Type