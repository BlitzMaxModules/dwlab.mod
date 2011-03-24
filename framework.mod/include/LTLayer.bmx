'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTWorld.bmx"

Type LTLayer Extends LTList
	Method Clone:LTActiveObject( Prefix:String, CollisionMap:LTCollisionMap )
		Local NewLayer:LTLayer = New LTLayer
		For Local Obj:LTActiveObject = Eachin Children
			Local NewObj:LTActiveObject = Obj.Clone( Prefix, CollisionMap )
			NewLayer.AddLast( NewObj )
		Next
		Return NewLayer
	End Method
	
	
	
	Method FindLayer:LTLayer( LayerName:String )
		If GetName() = LayerName Then Return Self
		For Local ChildLayer:LTLayer = Eachin Children
			Local Layer:LTLayer = ChildLayer.FindLayer( LayerName )
			If Layer Then Return Layer
		Next
		Return Null
	End Method
End Type
