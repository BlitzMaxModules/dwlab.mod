'
' I, Ball 2 Remake - Digital Wizard's Lab example
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type TBlock Extends LTActor
End Type





Type TMovingBlock Extends LTActor
	Field BlockType:Int
	
	
	
	Const MovingBlock:Int = 0
	Const FallingBlock:Int = 1
	Const PinnedBlock:Int = 2
	
	
	
	Method Act()
		Select BlockType
			Case MovingBlock, FallingBlock
				MoveForward()
				Game.CollisionMap.CollisionsWithActor( Self )
		End Select
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TGameActor( Shape ) Then
			Shape.Destroy()
		Else
			Push( Shape, 0.0, 1.0 )
			If BlockType = MovingBlock Then SetDY( -GetDY() )
		End If
	End Method
End Type





Type TExitBlock Extends TBlock
End Type





Type THazardousBlock Extends TBlock
	Method New()
		Visual = Game.FlashingVisual
	End Method
	
	
	
	Method HandleCollision( Shape:LTShape )
		If TGameActor( Shape ) Then Shape.Destroy()
	End Method
End Type





Type TCollectableBlock Extends TBlock
	Field BlockType:Int
	
	
	
	Const Key:Int = 0 ' 250pts
	Const Bomb:Int = 1 ' 100pts
	Const Badge:Int = 2 ' 50pts
	Const Diamond:Int = 3 ' 100pts
	Const Score:Int = 4 ' 500pts
	Const Nothing:Int = 5
End Type