'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TPlayer Extends LTAngularSprite
	Const MinTargetDistance:Double = 1.25

	
	
	Field Weapon:TChaingun[] = New TChaingun[ 2 ]
	Field Visor:LTAngularSprite
	
	
	
	Method Init()
		Game.Player = Self
		Visor = LTAngularSprite( Game.Level.FindShape( "Visor" ) )
		Visor.AttachModel( LTFixedJoint.Create( Self ) )
	End Method
	
	
	
	Method Act()
		MoveUsingWSAD()
		
		If DistanceTo( Game.Target ) < MinTargetDistance Then
			Local TargetAngle:Double = DirectionTo( Game.Target )
			Game.Target.SetCoords( X + Cos( TargetAngle ) * MinTargetDistance, Y + Sin( TargetAngle ) * MinTargetDistance )
		End If
		DirectTo( Game.Target )
		
		L_CurrentCamera.JumpTo( Self )
	End Method
End Type