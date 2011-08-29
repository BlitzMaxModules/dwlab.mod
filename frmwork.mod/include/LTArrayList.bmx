Global L_ArrayListChunkSize:Int = 16

Type LTArrayList Extends LTObject
	Field Size:Int = 0
	Field ValueArray:Object[]
	
	Function Create:LTArrayList( Size:Int = 0 )
		Local List:LTArrayList = New LTArrayList
		If Not Size Then Size = L_ArrayListChunkSize
		List.ValueArray = New Int( Size )
		Return List
	End Function
	
?Not Threaded
	Method Delete()
		Value = Null
	End Method
?
	Method Clear()
		ValueArray = New Int[ L_ArrayListChunkSize ]
	End Method

	Method IsEmpty()
		Return Size = 0
	End Method
	
	Method Contains( Value:Object )
		For Local N:Int = 0 Until Size
			If ValueArray[ N ] = Value Then Return True
		Next
	End Method

	Method AddFirst:TLink( Value:Object )
		ValueArray = New Int[ 1 ] + ValueArray
		ValueArray [ 0 ] = Value
		Size :+ 1
	End Method

	Method AddLast:TLink( Value:Object )
		If ValueArray.Dimensions()[ 0 ] = Size Then ValueArray = ValueArray + New Int[ L_ArrayListChunkSize ]
		ValueArray[ Size ] = Value
		Size :+ 1
	End Method

	Method First:Object()
		If Size = 0 Then L_Error( "Trying to retrieve element from empty array" )
		Return ValueArray[ 0 ]
	End Method

	Method Last:Object()
		If Size = 0 Then L_Error( "Trying to retrieve element from empty array" )
		Return ValueArray[ Size ]
	End Method

	Method RemoveFirst:Object()
		If Size = 0 Then L_Error( "Trying to remove element from empty array" )
		ValueArray = ValueArray[ 1.. ] + New Int[ 1 ]
		Size :- 1
	End Method

	Method RemoveLast:Object()
		If Size = 0 Then L_Error( "Trying to remove element from empty array" )
		Size :- 1
	End Method
	
	Method InsertBefore( Value:Object, Index:Int )
		ValueArray = ValueArray[ ..Index ] + Int[ 1 ] + ValueArray[ Index.. ]
		ValueArray[ Index ] = Value
		Size :+ 1
	End Method

	Method InsertAfter( Value:Object, Index:Int )
		ValueArray = ValueArray[ ..Index + 1 ] + Int[ 1 ] + ValueArray[ Index + 1.. ]
		ValueArray[ Index ] = Value
		Size :+ 1
	End Method

	Method Find:Int( Value:Object )
		For Local Index:Int = 0 Until Size
			If ValueArray[ Index ] = Value Then Return Index
		Next
	End Method

	Method ValueAtIndex:Object( Index )
		Return ValueArray[ Index ]
	End Method

	Method Count:Int()
		Return Size
	End Method

	Method Remove( Index:Int )
		ValueArray = ValueArray[ ..Index ] + ValueArray[ Index + 1.. ] + New Int[ 1 ]
		Size :- 1
	End Method

	Method RemoveObject( value:Object )
		For Local Index:Int = 0 Until Size
			If ValueArray[ Index ] = Value Then Remove( Index )
		Next
	End Method
		
	Method ObjectEnumerator:TListEnum()
		Local Enum:LTArrayListEnum = New LTArrayListEnum
		Enum.ArrayList = Self
		Return Enum
	End Method

	Method ToArray:Object[]()
		Return ValueArray[ ..Size ]
	End Method

	Function FromArray:TList( Arr:Object[] )
		ValueArray = Arr
		Size = ValueArray.Dimensions[ 0 ]()
	End Function
End Type





Type LTArrayListEnum Extends TListEnum
	Field ArrayList:LTArrayList
	Field Index:Int = 0
	
	Method HasNext()
		Return Index < Size
	End Method
	
	Method NextObject:Object()
		Index :+ 1
		Return ArrayList.ValueArray[ Index - 1 ]
	End Method
End Type