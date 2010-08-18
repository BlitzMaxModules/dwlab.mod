' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
' Distrbuted under GNU General Public License version 3
' You can read it at http://www.gnu.org/licenses/gpl.txt

Global L_NullModel:LTModel = New LTNullModel

Type LTModel Extends LTObject
	Method GetX:Float()
	End Method

	
	
	Method GetY:Float()
	End Method
	
	
	
	Method SetCoords( NewX:Float, NewY:Float )
	End Method

	
	
	Method AlterCoords( DX:Float, DY:Float )
	End Method

	
	
	Method GetAngle:Float()
	End Method
	
	
	
	Method SetAngle( NewAngle:Float )
	End Method
	
	
	
	Method GetSpeed:Float()
	End Method
	
	
	
	Method SetSpeed( NewSpeed:Float )
	End Method
End Type





Type LTPoint Extends LTModel
	Field X:Float
	Field Y:Float
	
	
	
	Method GetX:Float()
		Return X
	End Method

	
	
	Method GetY:Float()
		Return Y
	End Method
	
	
	
	Method GetSpeed:Float()
		Return 1.0
	End Method
	
	
	
	Method SetCoords( NewX:Float, NewY:Float )
		X = NewX
		Y = NewY
	End Method
	
	
	
	Method AlterCoords( DX:Float, DY:Float )
		X :+ DX
		Y :+ DY
	End Method
	
	
	
	Method Move( DX:Float, DY:Float )
		X :+ DX * L_CurrentProject.DeltaTime
		Y :+ DY * L_CurrentProject.DeltaTime
	End Method
End Type





Type LTPivot Extends LTDot
	Field Angle:Float
	Field Speed:Float
	
	
	
	Method MoveForward( DX:Float, DY:Float )
		X :+ DX * Speed * L_CurrentProject.DeltaTime
		Y :+ DY * Speed * L_CurrentProject.DeltaTime
	End Method
End Type