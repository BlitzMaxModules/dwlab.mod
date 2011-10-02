'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTListBox Extends LTGadget
	Field InnerArea:LTShape
	Field Items:TList
	Field ListType:Int = Vertical
	
	
	
	Method GetClassTitle:String()
		Return "List box"
	End Method
	
	
	
	Method Init()
		If GetParameter( "list_type" ) = "horizontal" Then ListType = Horizontal
	End Method
	
	
	
	Method Draw()
		If ListType = Vertical Then
			Local ItemY:Double = TopY()
			For Local Item:Object = Eachin Items
				Local Shape:LTShape = New LTShape
				Shape.SetSize( Width, GetItemSize( Item ) )
				Shape.SetCornerCoords( X, ItemY )
				DrawItem( Item, Shape )
				Y :+ Shape.Height
			Next
		Else
			Local ItemX:Double = LeftX()
			For Local Item:Object = Eachin Items
				Local Shape:LTShape = New LTShape
				Shape.SetSize( GetItemSize( Item ), Height )
				Shape.SetCornerCoords( ItemX, Y )
				DrawItem( Item, Shape )
				X :+ Shape.Width
			Next
		End If
	End Method
	
	
	
	Method GetItemSize:Double( Item:Object )
	End Method
	
	
	
	Method DrawItem( Item:Object, Shape:LTShape )
	End Method
End Type