'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_Cursor:LTSprite = New LTSprite
L_Cursor.ShapeType = LTSprite.Pivot

Type LTWindow Extends LTLayer
	Field World:LTWorld
	Field Project:LTProject
	Field MouseOver:TMap = New TMap
	Field Modal:Int

	Method Operate()
		If Active Then
			For Local Gadget:LTGadget = Eachin Children
				If Gadget.CollidesWithSprite( L_Cursor ) Then
					If Not MouseOver.Contains( Gadget ) Then
						OnMouseOver( Gadget )
						Gadget.OnMouseOver()
						MouseOver.Insert( Gadget, Null )
					End If
					For Local N:Int = 1 To 3
						If Project.MouseHits[ N ] = 1 Then OnClick( Gadget, N )
						If MouseDown( N ) Then Gadget.OnMouseDown( N )
					Next
				ElseIf MouseOver.Contains( Gadget ) Then
					Gadget.OnMouseOut()
					OnMouseOut( Gadget )
					MouseOver.Remove( Gadget )
				End If
			Next
		End If
	End Method

	Method OnClick( Gadget:LTGadget, Button:Int )
		Select Gadget.GetParameter( "action" ).ToLower()
			Case "save"
				Save()
			Case "saveandclose"
				Save()
				Close()
				Project.CloseWindow( Self )
			Case "close"
				Close()
				Project.CloseWindow( Self )
		End Select
		
		Local Name:String = Gadget.GetParameter( "window" )
		If Name Then
			Project.LoadWindow( World, Name ) 
		Else
			Local Class:String = Gadget.GetParameter( "windowclass" )
			If Class Then Project.LoadWindow( World, , Class ) 
		End If
	End Method
	
	Method OnMouseDown( Gadget:LTGadget, Button:Int )
	End Method
	
	Method OnMouseOver( Gadget:LTGadget )
	End Method
	
	Method OnMouseOut( Gadget:LTGadget )
	End Method
	
	Method Save()
	End Method

	Method Close()
	End Method
End Type