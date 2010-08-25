'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTBehavior Extends LTObject
	Method ApplyToActor( Actor:LTActor )
	End Method
End Type





Type LTWASDControl Extends LTBehavior
	Field Speed:Float
	
	
	
	Method ApplyToActor( Actor:LTActor )
		Local DX:Float = Speed * ( KeyDown( 205 ) - KeyDown( 203 ) )
		Local DY:Float = Speed * ( KeyDown( 208 ) - KeyDown( 200 ) )
		Actor.Model.MoveOn( DX, DY )
	End Method
	
	
	
	Function AddToActor:LTWASDControl( Actor:LTActor, Speed:Float )
		Local Behavior:LTWASDControl = New LTWASDControl
		Behavior.Speed = Speed
		Actor.AddBehavior( Behavior )
		Return Behavior
	End Function
End Type





Type LTAimAtMouse Extends LTBehavior
	Method ApplyToActor( Actor:LTActor )
		Local FX:Float, FY:Float
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), FX, FY )
		Actor.Model.SetAngle( ATan2( FY - Actor.Model.GetY(), FX - Actor.Model.GetX() ) )
	End Method
	
	
	
	Function AddToActor:LTAimAtMouse( Actor:LTActor )
		Local Behavior:LTAimAtMouse = New LTAimAtMouse
		Actor.AddBehavior( Behavior )
		Return Behavior
	End Function
End Type