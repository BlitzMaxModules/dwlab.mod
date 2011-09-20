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
	Field MouseOver:TMap = NewTMap

	Method Operate( Project:LTProject )
		If Active Then
			For Local Gadget:LTGadget = Eachin Children
				If Gadget.CollidesWithSprite( L_GUI.Cursor ) Then
					If Not MouseOver.Contains( Gagdet ) Then
						OnMouseOver( Gadget )
						MouseOver.Insert( Gagdet, Null )
					End If
					For Local N:Int = 1 To 3
						If Project.MouseHit[ N ] = 1 Then OnClick( Gadget, N )
						If MouseDown( N ) Then OnMouseDown( Gadget, N )
					Next
				ElseIf MouseOver.Contains( Gagdet ) Then
					OnMouseOut( Gadget )
					MouseOver.Remove( Gadget )
				End If
			Next
		End If
	End Method

	Method OnClick( Gadget:LTGadget, Button:Int )
	End Method
	
	Method OnMouseDown( Gadget:LTGadget, Button:Int )
	End Method
	
	Method OnMouseOver( Gadget:LTGadget )
	End Method
	
	Method OnMouseOut( Gadget:LTGadget )
	End Method
End Type