'
' Super Mario Bros - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TExit Extends LTVectorSprite
	Method Act()
		If Overlaps( Game.Mario ) And Game.Mario.OnLand Then 
			If DY > 0.0 Then
				If KeyDown( Key_Down ) Then Game.Mario.AttachModel( TEnteringVerticalPipe.Create( Self ) )
			Else
				Game.Mario.AttachModel( TEnteringHorizontalPipe.Create( Self ) )
			End If
		End If
	End Method
End Type





Type TEnteringVerticalPipe Extends LTBehaviorModel
	Const Speed:Double = 2.0
	
	Field ExitSprite:TExit
	
	
	
	Function Create:TEnteringVerticalPipe( ExitSprite:TExit )
		Local Enterting:TEnteringVerticalPipe = New TEnteringVerticalPipe
		Enterting.ExitSprite = ExitSprite
		Return Enterting
	End Function
	
	
	
	Method Init( Shape:LTShape )
		Shape.DeactivateAllModels()
		Game.Level.Active = False
		Shape.LimitByWindowShape( ExitSprite )
		Game.Pipe.Play()
		If Game.Mario.FindModel( "TBig" ) Then Game.Mario.Frame = TMario.Sitting
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Shape.Move( 0.0, Speed )
		If Shape.Y >= ExitSprite.Y + 2.0 Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Game.Mario.Frame = TMario.Jumping
		Shape.RemoveWindowLimit()
		Shape.ActivateAllModels()
		Game.Level.Active = True
		Game.SwitchToLevel( ExitSprite.GetNamePart( 1 ).ToInt(), ExitSprite.GetNamePart( 2 ).ToInt() )
	End Method
End Type





Type TEnteringHorizontalPipe Extends LTBehaviorModel
	Const Speed:Double = 1.0
	
	Field ExitSprite:TExit
	
	
	
	Function Create:TEnteringHorizontalPipe( ExitSprite:TExit )
		Local Enterting:TEnteringHorizontalPipe = New TEnteringHorizontalPipe
		Enterting.ExitSprite = ExitSprite
		Return Enterting
	End Function
	
	
	
	Method Activate( Shape:LTShape )
		Shape.DeactivateAllModels()
		Game.Level.Active = False
		Shape.LimitByWindow( ExitSprite.X, ExitSprite.Y, ExitSprite.Width, ExitSprite.Height )
		Game.Pipe.Play()
	End Method
	
	
	
	Method ApplyTo( Shape:LTShape )
		Shape.Move( ExitSprite.DX * Speed, 0.0 )
		Game.Mario.Animate( Game, TMario.WalkingAnimationSpeed, 3, 1 )
		If ( ExitSprite.DX > 0.0 And Shape.X >= ExitSprite.X + 1.0 ) Or ( ExitSprite.DX < 0.0 And Shape.X <= ExitSprite.X - 1.0 ) Then Remove( Shape )
	End Method
	
	
	
	Method Deactivate( Shape:LTShape )
		Game.Mario.Frame = TMario.Jumping
		Shape.RemoveWindowLimit()
		Shape.ActivateAllModels()
		Game.Level.Active = True
		Game.SwitchToLevel( ExitSprite.GetNamePart( 1 ).ToInt(), ExitSprite.GetNamePart( 2 ).ToInt() )
	End Method
End Type