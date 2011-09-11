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
	bbdoc: Returns value of XMLObject attribute with given name.
	returns: Attribute string value.
	about: See also: #SetAttribute, #RemoveAttribulte
	End Rem
	Method GetAttribute:String( AttrName:String )
		For Local Attr:LTXMLAttribute = EachIn Attributes
			If Attr.Name = AttrName Then Return Attr.Value
		Next
	End Method
	
	
	
	Rem
	bbdoc: Sets value of XMLObject attribute with given name.
	about: See also: #GetAttribute, #RemoveAttribulte
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
	about: See also: #GetAttribute, #SetAttribute
	End Rem
	Method RemoveAttribute:String( AttrName:String )
		Local Link:TLink = Attributes.FirstLink()
		While Link
			If LTXMLAttribute( Link.Value() ).Name = AttrName Then Link.Remove()
			Link = Link.NextLink()
		Wend
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
	bbdoc: Transfers data between XMLObject attribute and framework object parameter with Int type.
	about: See also: #ManageDoubleAttribute, #ManageStringAttribute, #ManageObjectAttribute, #ManageIntArrayAttribute
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
	bbdoc: Transfers data between XMLObject attribute and framework object parameter with Double type.
	about: See also: #ManageIntAttribute, #ManageStringAttribute, #ManageObjectAttribute
	End Rem
	Method ManageDoubleAttribute( AttrName:String, AttrVariable:Double Var, DefaultValue:Double = 0.0 )
		If L_XMLMode = L_XMLGet Then
			For Local Attr:LTXMLAttribute = EachIn Attributes
				If Attr.Name = AttrName Then
					AttrVariable = Attr.Value.ToDouble()
					Return
				End If
			Next
			AttrVariable = DefaultValue
		ElseIf AttrVariable <> DefaultValue Then
			SetAttribute( AttrName, String( L_TrimDouble( AttrVariable ) ) )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object parameter with String type.
	about: See also: #ManageIntAttribute, #ManageDoubleAttribute, #ManageObjectAttribute
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
	bbdoc: Transfers data between XMLObject attribute and framework object parameter with LTObject type.
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
			If Obj Then
				Local ID:String = String( L_IDMap.ValueForKey( Obj ) )
				
				If Not ID Then
					ID = String( L_IDNum )
					L_IDMap.Insert( Obj, ID )
					L_DefinitionsMap.Insert( Obj, ID )
					L_IDNum :+ 1
					
					Local XMLObject:LTXMLObject = New LTXMLObject
					XMLObject.Name = "Define"
					XMLObject.SetAttribute( "object", TTypeId.ForObject( Obj ).Name()[ 2.. ] );
					XMLObject.SetAttribute( "id", ID )
					L_Definitions.Children.AddLast( XMLObject )
				End If
				L_RemoveIDMap.Remove( Obj )
			
				SetAttribute( AttrName, ID )
			End If
		End If
		Return Obj
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject attribute and framework object parameter with Int[] type.
	about: See also: #ManageIntAttribute
	End Rem
	Method ManageIntArrayAttribute( AttrName:String, IntArray:Int[] Var )
		If L_XMLMode = L_XMLGet Then
			Local Values:String[] = GetAttribute( AttrName ).Split( "," )
			Local Quantity:Int = Values.Dimensions()[ 0 ]
			IntArray = New Int[ Quantity ]
			For Local N:Int = 0 Until Quantity
				IntArray[ N ] = Values[ N ].ToInt()
			Next
		Else
			Local Values:String = ""
			For Local N:Int = 0 Until IntArray.Dimensions()[ 0 ]
				If Values Then Values :+ ","
				Values :+ IntArray[ N ]
			Next
			SetAttribute( AttrName, Values )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject field and framework object parameter with LTObject type.
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
	bbdoc: Transfers data between XMLObject contents and framework object parameter with TList type.
	about: See also: #ManageChildList
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
	bbdoc: Transfers data between XMLObject contents and framework object parameter with LTObject[] type.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectMapField
	End Rem
	Method ManageObjectArrayField( FieldName:String, Array:LTObject[] Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLArray:LTXMLObject = GetField( FieldName )
			If Not XMLArray Then Return
			If XMLArray Then XMLArray.ManageChildArray( Array )
		ElseIf Array Then
			Local XMLArray:LTXMLObject = New LTXMLObject
			XMLArray.Name = "Array"
			XMLArray.ManageChildArray( Array )
			SetField( FieldName, XMLArray )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject field and framework object parameter with TMap type filled with LTObject-LTObject pairs.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectArrayField
	End Rem
	Method ManageObjectMapField( FieldName:String, Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLMap:LTXMLObject = GetField( FieldName )
			If Not XMLMap Then Return
			If XMLMap Then XMLMap.ManageChildMap( Map )
		ElseIf Map Then
			If Map.IsEmpty() Then Return
			Local XMLMap:LTXMLObject = New LTXMLObject
			XMLMap.Name = "Map"
			XMLMap.ManageChildMap( Map )
			SetField( FieldName, XMLMap )
		End If
	End Method
	
	
	
	Method ManageObject:LTObject( Obj:LTObject )
		If L_XMLMode = L_XMLGet Then
			Local ID:Int = GetAttribute( "id" ).ToInt()
				
			If Name = "define" Then
				'if GetAttribute( "object" ) = "SystemMethodTemplate" THen debugstop
				Obj = LTObject( TTypeId.ForName( GetAttribute( "object" ) ).NewObject() )
				L_IDArray[ ID ] = Obj
			ElseIf Name = "object" Then
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
					
					L_IDArray[ ID ] = Obj
				End If
				Obj.XMLIO( Self )
			End If
			
			?debug
			If Obj = Null Then L_Error( "Object with ID " + ID + " not found." )
			?
			
			Return Obj
		ElseIf Obj Then
			Local ID:String = String( L_IDMap.ValueForKey( Obj ) )
			Local DefID:Object = L_DefinitionsMap.ValueForKey( Obj )
			If ID And Not DefID Then
				L_RemoveIDMap.Remove( Obj )
				Name = "Object"
				SetAttribute( "id", ID )
				Return Obj
			Else
				If DefID Then
					L_DefinitionsMap.Remove( Obj )
				ElseIf Not LTXMLObject( Obj ) Then
					ID = String( L_IDNum )
					L_IDMap.Insert( Obj, ID )
					
					L_IDNum :+ 1
					L_RemoveIDMap.Insert( Obj, Self )
				End If
				
				SetAttribute( "id", ID )

				Obj.XMLIO( Self )
			End If
		End If
		
		Return Obj
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject contents and framework object parameter with TList type.
	about: See also: #ManageListField, #ManageChildArray
	End Rem
	Method ManageChildList( List:TList Var )
		'debugstop
		If L_XMLMode = L_XMLGet Then
			List = New TList
			For Local XMLObject:LTXMLObject = EachIn Children
				List.AddLast( XMLObject.ManageObject( Null ) )
			Next
		Else
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
	Method ManageChildArray( ChildArray:LTObject[] Var )
		If L_XMLMode = L_XMLGet Then
			ChildArray = New LTObject[ Children.Count() ]
			Local N:Int = 0
			For Local XMLObject:LTXMLObject = EachIn Children
				ChildArray[ N ] = XMLObject.ManageObject( Null )
				If Not ChildArray[ N ] Then DebugStop
				N :+ 1
			Next
		Else
			For Local Obj:LTObject = EachIn ChildArray
				Local XMLObject:LTXMLObject = New LTXMLObject
				XMLObject.ManageObject( Obj )
				Children.AddLast( XMLObject )
			Next
		End If
	End Method
	
	
	
	Rem
	bbdoc: Transfers data between XMLObject field and framework object parameter with TMap type filled with LTObject-LTObject pairs.
	about: See also: #ManageObjectAttribute, #ManageObjectField, #ManageObjectArrayField
	End Rem
	Method ManageChildMap( Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			For Local XMLObject:LTXMLObject = Eachin Children
				Local Key:LTObject = Null
				XMLObject.ManageObjectAttribute( "key", Key )
				Map.Insert( Key, XMLObject.ManageObject( Null ) )
			Next
		Else
			For Local KeyValue:TKeyValue = Eachin Map
				Local XMLValue:LTXMLObject = New LTXMLObject
				XMLValue.ManageObject( LTObject( KeyValue.Value() ) )
				XMLValue.ManageObjectAttribute( "key", LTObject( KeyValue.Value() ) )
				Children.AddLast( XMLValue )
			Next
		End If
	End Method
	

	
	Function ReadFromFile:LTXMLObject( Filename:String )
		Local File:TStream = ReadFile( Filename )
		Local Content:String = ""
		
		While Not Eof( File )
			Content :+ ReadLine( File )
		Wend
		
		CloseFile File
		
		Local N:Int = 0
		'DebugLog Content
		Local FieldName:String = ""
		Return ReadObject( Content, N, FieldName )
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
				
		Return Obj
	End Function
	
	
	
	Method WriteObject( File:TStream, Indent:String = "" )
		Local St:String = Indent + "<" + Name
		For Local Attr:LTXMLAttribute = EachIn Attributes
			St :+ " " + Attr.Name + "=~q" +Attr.Value + "~q"
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
							If Attr.Name = "id" Then L_IDNum = Max( L_IDNum, Attr.Value.ToInt() )
							Attributes.AddLast( Attr )
						End If
					
					ReadingValue = False
					ChunkBegin = -1
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
								If Attr.Name = "id" Then L_IDNum = Max( L_IDNum, Attr.Value.ToInt() )
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