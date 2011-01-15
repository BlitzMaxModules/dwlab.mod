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



Type LTXMLObject Extends LTObject
	Field Name:String
	Field Attributes:TList = New TList
	Field Children:TList = New TList
	Field Fields:TList = New TList
	Field Closing:Int = False
	
	
	
	Method GetAttribute:String( AttrName:String )
		For Local Attr:LTXMLAttribute = EachIn Attributes
			If Attr.Name = AttrName Then Return Attr.Value
		Next
	End Method
	
	
	
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
		'DebugLog Attr.Name + "=" +Attr.Value
	End Method
	
	
	
	Method GetField:LTXMLObject( FieldName:String )
		For Local ObjectField:LTXMLObjectField = EachIn Fields
			If ObjectField.Name = FieldName Then Return ObjectField.Value
		Next	
	End Method
	
	
	
	Method SetField:LTXMLObjectField( FieldName:String, XMLObject:LTXMLObject )
		Local ObjectField:LTXMLObjectField = New LTXMLObjectField
		ObjectField.Name = FieldName
		ObjectField.Value = XMLObject
		Fields.AddLast( ObjectField )
		Return ObjectField
	End Method
	
	
	
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
	
	
	
	Method ManageFloatAttribute( AttrName:String, AttrVariable:Float Var, DefaultValue:Float = 0 )
		If L_XMLMode = L_XMLGet Then
			For Local Attr:LTXMLAttribute = EachIn Attributes
				If Attr.Name = AttrName Then
					AttrVariable = Attr.Value.ToFloat()
					Return
				End If
			Next
			AttrVariable = DefaultValue
		ElseIf AttrVariable <> DefaultValue Then
			SetAttribute( AttrName, String( L_TrimFloat( AttrVariable ) ) )
		End If
	End Method
	
	
	
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
	
	
	
	Method ManageObjectAttribute:LTObject( AttrName:String, Obj:LTObject )
		If L_XMLMode = L_XMLGet Then
			'debugstop
			Local ID:Int = GetAttribute( AttrName ).ToInt()
			If Not ID Then Return Obj
			
			Obj = L_IDArray[ ID ]
			
			?debug
			L_Assert( Obj <> Null, "Object with id " + ID + " not found" )
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
	
	
	
	Method ManageListField( FieldName:String, List:TList Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLObject:LTXMLObject = GetField( FieldName )
			If XMLObject Then XMLObject.ManageChildList( List )
		ElseIf Not List.IsEmpty() Then
			Local XMLObject:LTXMLObject = New LTXMLObject
			XMLObject.Name = "TList"
			XMLObject.ManageChildList( List )
			SetField( FieldName, XMLObject )
		End If
	End Method
	
	
	
	Method ManageObjectMapField( FieldName:String, Map:TMap Var )
		If L_XMLMode = L_XMLGet Then
			For Local XMLObject:LTXMLObject = Eachin Children
				Local Key:LTObject
				XMLObject.ManageObjectAttribute( "key", Key )
				Map.Insert( Key, XMLObject.ManageObject( Null ) )
			Next
		Else
			Local XMLMap:LTXMLObject = New LTXMLObject
			XMLMap.Name = "TMap"
			For Local KeyValue:TKeyValue = Eachin Map
				Local XMLValue:LTXMLObject = New LTXMLObject
				XMLValue.ManageObject( LTObject( KeyValue.Value() ) )
				XMLValue.ManageObjectAttribute( "key", LTObject( KeyValue.Value() ) )
				XMLMap.Children.AddLast( XMLValue )
			Next
			SetField( FieldName, XMLMap )
		End If
	End Method
	
	
	
	Method ManageObjectArrayField( FieldName:String, FieldObjectsArray:LTObject[] Var )
		If L_XMLMode = L_XMLGet Then
			Local XMLArray:LTXMLObject = GetField( FieldName )
			If XMLArray Then XMLArray.ManageChildArray( FieldObjectsArray )
		ElseIf FieldObjectsArray Then
			Local XMLArray:LTXMLObject = New LTXMLObject
			XMLArray.Name = "Array"
			XMLArray.ManageChildArray( FieldObjectsArray )
			SetField( FieldName, XMLArray )
		End If
	End Method
	
	
	
	Method ManageObject:LTObject( Obj:LTObject )
		If L_XMLMode = L_XMLGet Then
			Local ID:Int = GetAttribute( "id" ).ToInt()
				
			If Name = "define" Then
				'if GetAttribute( "object" ) = "SystemMethodTemplate" THen debugstop
				Obj = LTObject( TTypeId.ForName( GetAttribute( "object" ) ).NewObject() )
				L_IDArray[ ID ] = Obj
			ElseIf Name = "include" Then
				Obj = LTObject( L_IncludedObjects.ValueForKey( GetAttribute( "name" ) ) )
				
				?debug
				L_Assert( Obj <> Null, "There is no object named ~q" + GetAttribute( "name" ) + "~q in the included objects list" )
				?
				
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
					L_Assert( TypeID <> Null, "Object ~qLT" + Name + "~q not found" )
					?
					
					Obj = LTObject( TypeID.NewObject() )
					
					L_IDArray[ ID ] = Obj
				End If
				Obj.XMLIO( Self )
			End If
			
			?debug
			L_Assert( Obj <> Null, "Object with ID " + ID + " not found." )
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
					L_Assert( False, "Error in XML file - wrong closing tag ~q" + Child.Name + "~q, expected ~q" + Obj.Name + "~q" )
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
					L_Assert( ReadingValue, "Error in XML file - unexpected quotes: " + Txt[ ..N ] )
					?
					
					ChunkBegin = N + 1
					Quotes = Txt[ N ]
				ElseIf Txt[ N ] = Asc( "<" ) Then
					?debug
					If ReadingContents Or ReadingValue Then L_Assert( False, "Error in XML file - unexpected beginning of tag" + Txt[ ..N ] )
					?
					
					ReadingContents = True
				ElseIf IDSym( Txt[ N ] ) Then
					If ChunkBegin < 0 Then ChunkBegin = N
					
					?debug
					If Closing And Not ReadingName Then L_Assert( False, "Error in XML file - invalid closing tag: " + Txt[ ..N ] )
					?
				Else
					?debug
					If Txt[ N ] = Asc( "=" ) And ReadingName Or ReadingValue Then L_Assert( False, "Error in XML file - unexpected ~q=~q: " + Txt[ ..N ] )
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
						If ReadingValue Or Closing Then L_Assert( False, "Error in XML file - unexpected slash: " + Txt[ ..N ] )
						?
						
						If ReadingName Then Closing = 2 Else Closing = 1
					End If
					
					If Txt[ N ] = Asc( ">" ) Then
						?debug
						If Not ReadingContents Or ReadingValue Or ReadingName Then L_Assert( False, "Error in XML file - unexpected end of tag: " + Txt[ ..N ] )
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