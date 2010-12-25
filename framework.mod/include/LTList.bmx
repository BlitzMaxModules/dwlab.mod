'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTList Extends LTObject
	Field Children:TList = New TList
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Obj:LTActiveObject )
		For Local Obj2:LTActiveObject = Eachin Children
			Local Collision:Int = Obj2.CollidesWith( Obj )
			If Collision Then Return True
		Next
	End Method
	
	
	
	Method CollidesWithActor:Int( Actor:LTActor )
		Return CollidesWith( Actor )
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
		Return CollidesWith( Line )
	End Method
	

	
	Method CollisionsWith( Obj1:LTActiveObject )
		For Local Obj2:LTActiveObject = Eachin Children
			Obj2.CollisionsWith( Obj1 )
		Next
	End Method
	
	
	
	Method CollisionsWithActor( Actor:LTActor )
		For Local Obj:LTActiveObject = Eachin Children
			Actor.CollisionsWith( Obj )
		Next
	End Method
	
	
	
	Method CollisionsWithLine( Line:LTLine )
		For Local Obj:LTActiveObject = Eachin Children
			Line.CollisionsWith( Obj )
		Next
	End Method
		
	' ==================== Pushing ====================
	
	Method Draw()
		For Local Obj:LTActiveObject = Eachin Children
			Obj.Draw()
		Next
	End Method
	
	
	
	Method Act()
		For Local Obj:LTActiveObject = Eachin Children
			Obj.Act()
		Next
	End Method
	
	' ==================== List methods ====================
	
	Method AddLast:TLink( Obj:LTActiveObject )
		Return Children.AddLast( Obj )
	End Method
	
	
	
	Method Remove( Obj:LTActiveObject )
		Children.Remove( Obj )
	End Method
	
	
	
	Method Clear()
		Children.Clear()
	End Method
	
	
	
	Method ObjectEnumerator:TListEnum()
		Return Children.ObjectEnumerator()
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageChildList( Children )
	End Method
End Type