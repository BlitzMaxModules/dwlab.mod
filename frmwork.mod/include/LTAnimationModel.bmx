'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: This model plays animation of the sprite.
about: You can specify parameters from LTSprite's Animate() method and add models which will be executed after animation will end to the
NextModels parameter. Though if animation is looped it will be played forever.

See also: #LTModelStack, #LTBehaviorModel example.
End Rem
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
	
	
	
	Method Activate( Shape:LTShape )
		StartingTime = L_CurrentProject.Time
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		If Not Looped Then
			If L_CurrentProject.Time > StartingTime + Speed * ( FramesQuantity + ( FramesQuantity - 2 ) * PingPong ) Then
				DeactivateModel( Shape )
				Shape.AttachModels( NextModels )
				Return
			End If
		End If
		LTSprite( Shape ).Animate( Speed, FramesQuantity, FrameStart, StartingTime, PingPong )
	End Method
	
	
	
	Method Info:String( Shape:LTShape )
		Return LTSprite( Shape ).Frame
	End Method
End Type