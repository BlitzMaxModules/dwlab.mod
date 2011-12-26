'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTAnimationModel Extends LTBehaviorModel
	Field StartingTime:Double
	Field Looped:Int
	Field Speed:Double
	Field FramesQuantity:Int
	Field FrameStart:Int
	Field PingPong:Int
	Field NextModels:TList = New TList
	
	
	
	Function Create:LTAnimationModel( Looped:Int = True, Speed:Double, FramesQuantity:Int = 0, FrameStart:Int = 0, PingPong:Int = False )
		Local Model:LTAnimationModel = New LTAnimationModel
		Model.Speed = Speed
		Model.Looped = Looped
		Model.FramesQuantity = FramesQuantity
		Model.FrameStart = FrameStart
		Model.PingPong = PingPong
		Return Model
	End Function
	
	
	
	Method Init( Shape:LTShape )
		StartingTime = L_CurrentProject.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		LTSprite( Shape ).Animate( Speed, FramesQuantity, FrameStart, StartingTime, PingPong )
		If Not Looped Then
			If L_CurrentProject.Time > StartingTime + Speed * ( FramesQuantity + ( FramesQuantity - 2 ) * PingPong ) Then
				Remove( Shape )
				Shape.AttachModels( NextModels )
			End If
		End If
	End Method
End Type