'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Type LTGrid Extends LTActiveObject
	Field XSize:Float = 1.0
	Field YSize:Float = 1.0
	
	
	
	Method Draw()
		Local SX:Float, SY:Float
		SetColor( 0, 0, 0 )
		
		Local X:Float = Floor( L_CurrentCamera.CornerX() / XSize ) * XSize
		Local EndX:Float = L_CurrentCamera.CornerX() + L_CurrentCamera.XSize
		While X < EndX
			L_CurrentCamera.FieldToScreen( X, 0, SX, SY )
			DrawLine( SX, 0, SX, GraphicsHeight() )
			X :+ XSize
		WEnd
		
		Local Y:Float = Floor( L_CurrentCamera.CornerY() / YSize ) * YSize
		Local EndY:Float = L_CurrentCamera.CornerY() + L_CurrentCamera.YSize
		While Y < EndY
			L_CurrentCamera.FieldToScreen( 0, Y, SX, SY )
			DrawLine( 0, SY, GraphicsWidth(), SY )
			Y :+ YSize
		WEnd
		
		SetColor( 255, 255, 255 )
	End Method
	
	
	
	Method SnapX:Float( X:Float )
		If MenuChecked( Editor.SnapToGrid ) Then Return L_Round( X / XSize ) * XSize Else Return X
	End Method
	
	
	
	Method SnapY:Float( Y:Float )
		If MenuChecked( Editor.SnapToGrid ) Then Return L_Round( Y / YSize ) * YSize Else Return Y
	End method
	
	
	
	Method Snap( X:Float Var, Y:Float Var )
		X = SnapX( X )
		Y = SnapY( Y )
	End Method
	
	
	
	Method SetSnaps( Side1:Float Var, Side2:Float Var, Vertical:Int )
		If MenuChecked( Editor.SnapToGrid ) Then
			Local Snap1:Float, Snap2:Float
			If Vertical Then
				Snap1 = DYSnap( Side1 )
				Snap2 = DYSnap( Side2 )
			Else
				Snap1 = DXSnap( Side1 )
				Snap2 = DXSnap( Side2 )
			End If
			
			If Abs( Snap1 ) < Abs( Snap2 ) Then
				Side1 :+ Snap1
				Side2 :+ Snap1
			Else
				Side1 :+ Snap2
				Side2 :+ Snap2
			End If
		End If
	End Method
	
	
	
	Method SetCornerSnaps( NewHorizontalSide:Float Var, NewVerticalSide:Float Var, HorizontalSide:Float Var,..
	VerticalSide:Float Var, OppositeHorizontalSide:Float, OppositeVerticalSide:Float, X:Float, Y:Float )
	
		Local Diagonal:Float = L_Distance( HorizontalSide - OppositeHorizontalSide, VerticalSide - OppositeVerticalSide )
		Local R:Float = L_Distance( X - OppositeHorizontalSide, Y - OppositeVerticalSide )
		
		NewHorizontalSide = OppositeHorizontalSide + ( HorizontalSide - OppositeHorizontalSide ) * R / Diagonal
		NewVerticalSide = OppositeVerticalSide + ( VerticalSide - OppositeVerticalSide ) * R / Diagonal
		
		If MenuChecked( Editor.SnapToGrid ) Then
			Local HorizontalSnap:Float = DXSnap( NewHorizontalSide )
			Local VerticalSnap:Float = DYSnap( NewVerticalSide )
			If Abs( HorizontalSnap ) < Abs( VerticalSnap ) Then
				NewHorizontalSide = NewHorizontalSide + HorizontalSnap
				NewVerticalSide = NewVerticalSide + HorizontalSnap * ( VerticalSide - OppositeVerticalSide ) / ( HorizontalSide - OppositeHorizontalSide )
			Else
				NewHorizontalSide = NewHorizontalSide + VerticalSnap * ( HorizontalSide - OppositeHorizontalSide ) / ( VerticalSide - OppositeVerticalSide )
				NewVerticalSide = NewVerticalSide + VerticalSnap
			End If
		End If
	End Method
	
	
	
	Method DXSnap:Float( Coord:Float )
		Return XSize * L_Round( Coord / XSize ) - Coord
	End Method
	
	
	
	Method DYSnap:Float( Coord:Float )
		Return YSize * L_Round( Coord / YSize ) - Coord
	End Method
End Type