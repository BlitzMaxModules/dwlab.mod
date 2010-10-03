'
' MindStorm - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Const LeftSide:Float = -1
Const RightSide:Float = 1

Type TWeapon Extends LTObject
	Method Logic()
	End Method
	
	
	
	Method Render()
	End Method
End Type





Type TChaingun Extends TWeapon
	Field Position:Int
	Field CannonHinge:LTActor = New LTActor
	Field CannonAimer:LTActor = New LTActor
	Field Cannon:LTActor = New LTActor
	Field CannonVisualizer:LTImageVisualizer = New LTImageVisualizer
	Field Barrel:LTActor = New LTActor
	Field BarrelVisualizer:LTImageVisualizer = New LTImageVisualizer
	Field FireMin:LTActor = New LTActor
	Field FireMax:LTActor = New LTActor
	Field Fire:LTActor = New LTActor
	Field BarrelAnim:Float
	Field BarrelAnimAcc:Float
	Field JointList:TList = New TList
	Field Bullets:TList = New TList
	Field LastShotTime:Int
	
	
	
	Function Create:TChaingun( WeaponPosition:Float )
		Local Chaingun:TChaingun = New TChaingun
		Chaingun.Position = WeaponPosition

		Chaingun.CannonHinge.SetCoordsRelativeToActor( Game.Player, 0.0, 0.42 * WeaponPosition )
		Chaingun.CannonAimer.SetCoordsRelativeToActor( Game.Player, -0.19, 0.65 * WeaponPosition )
		Chaingun.Cannon.SetCoordsRelativeToActor( Game.Player, 0.19, 0.57 * WeaponPosition )
		Chaingun.Cannon.SetSize( 1.5, 1.5 )
		Chaingun.CannonVisualizer.Image = Game.ChaingunCannon
		Chaingun.CannonVisualizer.SetVisualizerScale( 1.0, -WeaponPosition )
		Chaingun.Cannon.Visualizer = Chaingun.CannonVisualizer
		Chaingun.Cannon.CorrectYSize()
		
		Chaingun.Barrel.SetCoordsRelativeToActor( Game.Player, 0.88, 0.65 * WeaponPosition )
		Chaingun.Barrel.SetSize( 0.75, 0.75 )
		Chaingun.BarrelVisualizer.Image = Game.ChaingunBarrel
		Chaingun.BarrelVisualizer.SetVisualizerScale( 1.0, -WeaponPosition )
		Chaingun.Barrel.Visualizer = Chaingun.BarrelVisualizer
		Chaingun.Barrel.CorrectYSize()
		
		Chaingun.Fire.SetSize( 1.5, 1.5 )
		Chaingun.Fire.Visualizer = Game.ChaingunFire
		
		Chaingun.FireMin.SetCoordsRelativeToActor( Game.Player, 1.0, 0.59 * WeaponPosition )
		Chaingun.FireMax.SetCoordsRelativeToActor( Game.Player, 1.0, 0.69 * WeaponPosition )
		
		
		L_SetJointList( Chaingun.JointList )
		LTRevoluteJoint.Create( Game.Player, Chaingun.CannonHinge )
		LTFixedJoint.Create( Chaingun.CannonHinge, Chaingun.Cannon )
		LTFixedJoint.Create( Chaingun.CannonHinge, Chaingun.Barrel )
		LTFixedJoint.Create( Chaingun.CannonHinge, Chaingun.FireMax )
		LTFixedJoint.Create( Chaingun.CannonHinge, Chaingun.FireMin )
		LTRevoluteJoint.Create( Chaingun.CannonHinge, Chaingun.CannonAimer )
		L_SetJointList()
		Return Chaingun
	End Function
	
	
	
	Method Logic()
		L_OperateJoints( JointList )
		CannonAimer.DirectToActor( Game.Target )
		CannonHinge.DirectAsActor( CannonAimer )
		Fire.DirectAsActor( CannonAimer )
		
		If Position = LeftSide Then
			If MouseDown( 1 ) Then
				BarrelAnimAcc :+ L_DeltaTime * 100
			Else
				BarrelAnimAcc :- L_DeltaTime * 20
			End If
		Else
			If MouseDown( 2 ) Then
				BarrelAnimAcc :+ L_DeltaTime * 100
			Else
				BarrelAnimAcc :- L_DeltaTime * 20
			End If
		End If
		
		If BarrelAnimAcc < 0.0 Then BarrelAnimAcc = 0.0
		If BarrelAnimAcc > 60.0 Then
			BarrelAnimAcc = 60.0
			If Millisecs() - LastShotTime >= 50 Then
				Local Bullet:LTChaingunBullet = New LTChaingunBullet
				Local BulletVisualizer:LTImageVisualizer = New LTImageVisualizer
				Bullet.Visualizer = BulletVisualizer
				Bullet.SetDiameter( Rnd( 0.1, 0.25 ) )
				BulletVisualizer.Image = Game.ChaingunBullet
				BulletVisualizer.SetVisualizerScale( 5.0, 5.0 )
				Bullet.SetVelocity( 7.0 )
				Bullet.CreatingTime = Millisecs()
				Bullet.FlyingPeriod = Rnd( 1.0, 2.0 )
				Bullet.FadingPeriod = Rnd( 1.0, 1.5 )
				Bullet.GameBulletListLink = Game.Bullets.AddLast( Bullet )
				Bullet.ChaingunBulletListLink = Bullets.AddLast( Bullet )
				Bullet.JumpToActor( Fire )
				Bullet.DirectAsActor( Fire )
				Bullet.Shape = L_Circle
				LastShotTime = Millisecs()
			End If
		End If
		
		For Local Bullet:LTChaingunBullet = Eachin Bullets
			Bullet.Act()
		Next
		
		BarrelAnim = L_WrapFloat( BarrelAnim + L_DeltaTime * BarrelAnimAcc, 16 )
		Barrel.Frame = Floor( BarrelAnim )
		Fire.PlaceBetweenActors( FireMin, FireMax, ( Sin( BarrelAnim * 22.5 + 90 ) + 1.0 ) * 0.5 )
	End Method
	
	
	
	Method Render()
		Cannon.Draw()
		If MilliSecs() - LastShotTime < 40 Then
			Fire.Frame = Rand( 0, 3 )
			Fire.Draw()
		End If
		Barrel.Draw()
	End Method
End Type




Type LTChaingunBullet Extends LTActor
	Field CreatingTime:Int
	Field FadingPeriod:Float
	Field FlyingPeriod:Float
	Field GameBulletListLink:TLink
	Field ChaingunBulletListLink:TLink
	
	
	
	Method Act()
		MoveForward()
		Local Time:Float = 0.001 * ( MilliSecs() - CreatingTime )
		Frame = L_WrapInt2( Floor( 10.0 + 50.0 * Time ), 27, 87 )
		If Time > FlyingPeriod Then
			Time = Time - FlyingPeriod
			If Time > FadingPeriod Then
				GameBulletListLink.Remove()
				ChaingunBulletListLink.Remove()
			Else
				Visualizer.Alpha = 1.0 - Time / FadingPeriod
			End If
		End If
	End Method
End Type