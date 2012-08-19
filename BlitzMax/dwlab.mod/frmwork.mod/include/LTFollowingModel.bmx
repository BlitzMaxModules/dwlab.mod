'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTFollowingModel Extends LTChainedModel
	Field DestinationShape:LTShape
	Field RemoveWhenStop:Int
	
	
	
	Function Create:LTFollowingModel( DestinationShape:LTShape, RemoveWhenStop:Int )
		Local Model:LTFollowingModel = New LTFollowingModel
		Model.DestinationShape = DestinationShape
		Model.RemoveWhenStop = RemoveWhenStop
		Return Model
	End Function
	
	
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).MoveTowards( DestinationShape, LTSprite( Shape ).Velocity )
		If RemoveWhenStop Then If Shape.IsAtPositionOf( DestinationShape ) Then Remove( Shape )
	End Method
End Type