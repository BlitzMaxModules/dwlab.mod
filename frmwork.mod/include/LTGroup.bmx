'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTGroup Extends LTSprite
	Field Children:TList = New TList
	
	' ==================== Drawing ===================
	
	Method Draw()
		If Visible Then
			For Local Obj:LTShape = Eachin Children
				Obj.Draw()
			Next
		End If
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		If Visible Then
			For Local Obj:LTShape = Eachin Children
				Obj.DrawUsingVisualizer( Vis )
			Next
		End If
	End Method
	
	
	
	Method Act()
		If Active Then
			For Local Obj:LTShape = Eachin Children
				Obj.Act()
			Next
		End If
	End Method
	
	' ==================== Collisions ===================
	
	Method SpriteGroupCollisions( Sprite:LTSprite, CollisionType:Int )
		Sprite.CollisionsWithGroup( Self, CollisionType )
	End Method
		
	' ==================== List methods ====================
	
	Method AddLast:TLink( Shape:LTShape )
		Return Children.AddLast( Shape )
	End Method
	
	
	
	Method Remove( Shape:LTShape )
		Children.Remove( Shape )
	End Method
	
	
	
	Method Clear()
		Children.Clear()
	End Method
	
	
	
	Method ValueAtIndex:LTShape( Index:Int )
		Return LTShape( Children.ValueAtIndex( Index ) )
	End Method
	
	
	
	Method ObjectEnumerator:TListEnum()
		Return Children.ObjectEnumerator()
	End Method
	
	
	
	Method Update()
		Local MinX:Float, MinY:Float
		Local MaxX:Float, MaxY:Float
		Local FirstShape:Int = False
		For Local Shape:LTShape = Eachin Children
			Shape.Update()
			If FirstShape Then
				MinX = X
				MinY = Y
				MaxX = X
				MaxY = Y
				FirstShape = False
			Else
				If X < MinX Then MinX = X
				If Y < MinY Then MinY = Y
				If X > MaxX Then MaxX = X
				If Y > MaxY Then MaxY = Y
			End If
		Next
		X = 0.5 * ( MinX + MaxX )
		Y = 0.5 * ( MinY + MaxY )
		Width = MaxX - MinX
		Height = MaxY - MinY
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageChildList( Children )
	End Method
End Type