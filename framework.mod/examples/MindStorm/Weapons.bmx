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

Type TWeapon Extends LTObject
	Method Draw()
		
	End Method
End Type





Type TChaingun Extends TWeapon
	Field CannonPivot:LTPivot
	Field BarrelPivot:LTPivot
	Field FirePivot:LTPivot
	
	
	
	Method Create:TChaingun()
		Local Chaingun:TChaingun = New TChaingun
		Chaingun.CannonPivot.SetCoordsRelativeToPivot( Pivot,
	End Method
	
	
	
	Method Draw()
		
	End Method
End Type