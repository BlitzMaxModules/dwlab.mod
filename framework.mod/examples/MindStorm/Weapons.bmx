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
	Field CannonAimer:LTPivot = New LTPivot
	Field Cannon:LTRectangle = New LTRectangle
	Field Barrel:LTRectangle = New LTRectangle
	Field FireMin:LTPivot = New LTPivot
	Field FireMax:LTPivot = New LTPivot
	Field Fire:LTRectangle = New LTRectangle
	Field BarrelAnim:Float
	Field BarrelAnimAcc:Float
	Field JointLinksList:TList = New TList
	Field Hinge:LTPivot = New LTPivot
	
	
	
	Function Create:TChaingun( WeaponPosition:Float )
		Local Chaingun:TChaingun = New TChaingun
		Chaingun.CannonAimer.SetCoordsRelativeToPivot( Game.Player, 0.593, WeaponPosition * 0.3 )
		Chaingun.Cannon.SetCoordsRelativeToPivot( Game.Player, 0.19, -WeaponPosition * 0.57 )
		Chaingun.Cannon.Visual = Game.ChaingunCannon
		Chaingun.Cannon.SetSize( 1.5, WeaponPosition )
		Chaingun.Cannon.CorrectYSize()
		Chaingun.Barrel.SetCoordsRelativeToPivot( Game.Player, 0.88, -WeaponPosition * 0.65 )
		Chaingun.Barrel.Visual = Game.ChaingunBarrel
		Chaingun.Barrel.SetSize( 0.75, 0.75 * WeaponPosition )
		Chaingun.Barrel.CorrectYSize()
		Chaingun.FireMin.SetCoordsRelativeToPivot( Game.Player, 0.55, WeaponPosition * 0.25 )
		Chaingun.FireMax.SetCoordsRelativeToPivot( Game.Player, 0.55, WeaponPosition * 0.33 )
		Chaingun.Hinge.SetCoords( 0.6, 0.65 )
		Chaingun.Hinge.Visual = New LTFilledPrimitive
		Chaingun.Hinge.Visual.SetColorFromHex( "FF0000" )
		Chaingun.Hinge.Visual.SetVisualScale( 0.05, 0.05 )
		
		
		L_SetJointLinksList( Chaingun.JointLinksList )
		LTRevoluteJoint.Create( Game.Player, Chaingun.Cannon, 0.0, 0.42 )
		LTFixedJoint.Create( Chaingun.Cannon, Chaingun.Barrel )
		L_SetJointLinksList( Null )
		Return Chaingun
	End Function
	
	
	
	Method Logic()
		Fire.PlaceBetweenPivots( FireMin, FireMax, ( Sin( BarrelAnim * 22.5 + 90 ) + 1.0 ) * 0.5 )
		CannonAimer.DirectToPivot( Game.Target )
		Cannon.SetAngle( CannonAimer.GetAngle() )
	End Method
	
	
	
	Method Render()
		Cannon.Draw()
		Barrel.Draw()
		Hinge.Draw()
	End Method
End Type