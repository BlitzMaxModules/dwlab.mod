SuperStrict ' Skip

Framework brl.basic
Import dwlab.frmwork

Local Array:Int[] = [ 1, 2, 3, 4, 5 ]
PrintArray( "Source: ", Array )

L_RemoveItemFromIntArray( Array, 3 )
L_RemoveItemFromIntArray( Array, 2 )
L_AddItemToIntArray( Array, 8 )
L_AddItemToIntArray( Array, 9 )
PrintArray( "Result: ", Array )

Function PrintArray( Prefix:String, Array:Int[] )
	For Local Value:Int = Eachin Array
		Prefix :+ Value + ", "
	Next
	Print Prefix[ ..Len( Prefix ) - 2 ]
End Function