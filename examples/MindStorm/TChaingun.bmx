'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "TChaingunBullet.bmx"
Include "TFire.bmx"

Type TChaingun Extends LTAngularSprite
	Const BarrelAnimationAcceleration:Double = 100.0
	Const BarrelAnimationDeceleration:Double = 20.0
	Const MaxBarrelAnimationSpeed:Double = 60.0
	Const BarrelFramesQuantity:Int = 16
	Const FiringPeriod:Double = 0.1
	Const FireFramesQuantity:Int = 5
	
	Field Num:Int
	Field Hinge:LTAngularSprite
	Field Barrel:LTAngularSprite
	Field FirePos:LTAngularSprite[] = New LTAngularSprite[ 2 ]
	Field Aimer:LTAngularSprite
	Field BarrelAnimationSpeed:Double
	Field BarrelFrame:Double
	Field FiringStartingTime:Double
	Field Fire:TFire
	
	
	
	Method Init()
		Num = Name.ToInt()
		Game.Player.Weapon[ Num ] = Self
		
		Hinge = LTAngularSprite( Game.Level.FindShape( "Hinge," + Num ) )
		Barrel = LTAngularSprite( Game.Level.FindShape( "Barrel," + Num ) )
		Aimer = LTAngularSprite( Game.Level.FindShape( "Aimer," + Num ) )
		Fire = TFire( Game.Level.FindShapeWithType( "TFire", Num ) )
		Fire.Chaingun = Self
		
		Hinge.AttachModel( LTRevoluteJoint.Create( Game.Player ) )
		AttachModel( LTFixedJoint.Create( Hinge ) )
		Barrel.AttachModel( LTFixedJoint.Create( Hinge ) )
		Aimer.AttachModel( LTFixedJoint.Create( Hinge ) )
		
		For Local N:Int = 0 To 1
			FirePos[ N ] = LTAngularSprite( Game.Level.FindShape( "FirePos," + Num + "," + N ) )
			FirePos[ N ].AttachModel( LTFixedJoint.Create( Hinge ) )
		Next
	End Method
	
	
	
	Method Act()
		Aimer.DirectTo( Game.Target )
		Hinge.DirectAs( Aimer )
		
		If MouseDown( 1 ) Then
			BarrelAnimationSpeed :+ Game.PerSecond( BarrelAnimationAcceleration )
			If BarrelAnimationSpeed >= MaxBarrelAnimationSpeed Then
				BarrelAnimationSpeed = MaxBarrelAnimationSpeed
				Shoot()
			End If
		Else
			BarrelAnimationSpeed :- Game.PerSecond( BarrelAnimationDeceleration )
			If BarrelAnimationSpeed < 0.0 Then BarrelAnimationSpeed = 0.0
		End If
		BarrelFrame :+ Game.PerSecond( BarrelAnimationSpeed )
		Barrel.Frame = Floor( BarrelFrame + 0.5 * BarrelFramesQuantity * Num ) Mod BarrelFramesQuantity
		
		Super.Act()
		
		Fire.PlaceBetween( FirePos[ 0 ], FirePos[ 1 ], 0.5 - 0.5 * Cos( -20.0 + 360.0 * BarrelFrame / BarrelFramesQuantity ) )
		Fire.DirectAs( Aimer )
	End Method
	
	
	
	Method Shoot()
		If Game.Time > FiringStartingTime + FiringPeriod Then
			FiringStartingTime = Game.Time
			Fire.Frame = Rand( FireFramesQuantity - 1 )
			TChaingunBullet.Create( Fire )
			If Num Then Game.FireSounds.Play( Game.FireSound, 0.2 )
		End If
	End Method
End Type