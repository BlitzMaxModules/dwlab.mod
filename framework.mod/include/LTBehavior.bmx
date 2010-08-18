' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

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