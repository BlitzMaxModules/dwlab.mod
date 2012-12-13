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

Rem
bbdoc: This visualizer draws rectangular animated dashed frame around the shape.
End Rem
Type LTMarchingAnts Extends LTVisualizer
	Method DrawUsingSprite( Sprite:LTSprite, SpriteShape:LTSprite = Null )
		If Not SpriteShape Then SpriteShape = Sprite
		
		If Not Sprite.Visible Then Return
		ApplyColor()
		
		If L_CurrentCamera.Isometric Then
			Local SX11:Double, SY11:Double, SX12:Double, SY12:Double
			Local SX21:Double, SY21:Double, SX22:Double, SY22:Double
			L_CurrentCamera.FieldToScreen( SpriteShape.LeftX(), SpriteShape.TopY(), SX11, SY11 )
			L_CurrentCamera.FieldToScreen( SpriteShape.LeftX(), SpriteShape.BottomY(), SX12, SY12 )
			L_CurrentCamera.FieldToScreen( SpriteShape.RightX(), SpriteShape.TopY(), SX21, SY21 )
			L_CurrentCamera.FieldToScreen( SpriteShape.RightX(), SpriteShape.BottomY(), SX22, SY22 )
			
			Local Pos:Int = Int( Millisecs() / 100 ) Mod 8
		
			Local Width:Int = L_Distance( SX12 - SX11, SY12 -SY11 )
			If Width > 0 Then
				Local LineImage:TImage = MakeMALine( Width, Pos )
				DrawMALine( LineImage, SX11, SY11, SX12, SY12 )
				DrawMALine( LineImage, SX22, SY22, SX21, SY21 )
			End If
			
			Local Height:Int = L_Distance( SX21 - SX11, SY21 - SY11 )
			If Height > 0 Then
				Local LineImage:TImage = MakeMALine( Height, Pos )
				DrawMALine( LineImage, SX12, SY12, SX22, SY22 )
				DrawMALine( LineImage, SX21, SY21, SX11, SY11 )
			End If
		Else
			Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
			L_CurrentCamera.FieldToScreen( SpriteShape.X, SpriteShape.Y, SX, SY )
			L_CurrentCamera.SizeFieldToScreen( SpriteShape.Width * XScale, SpriteShape.Height * YScale, SWidth, SHeight )
			
			DrawMARect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, L_Round( SWidth ), L_Round( SHeight ) )
		End If
		
		ResetColor()
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap, Shapes:TList = Null )
		If Not TileMap.Visible Then Return
		Local Sprite:LTSprite = LTSprite.FromShapeType()
		Sprite.JumpTo( TileMap )
		Sprite.SetSize( TileMap.Width, TileMap.Height )
		DrawUsingSprite( Sprite )
	End Method
	
	
	
	Rem
	bbdoc: Draws voluntary marching ants rectangle.
	End Rem
	Function DrawMARect( X:Int, Y:Int, Width:Int, Height:Int )
		Local Pos:Int = Int( Millisecs() / 100 ) Mod 8
		
		If Width Then
			Local LineImage:TImage = MakeMALine( Width, Pos )
			SetScale( -1.0, 1.0 )
			DrawImage( LineImage, X + Width, Y )
			SetScale( 1.0, 1.0 )
			DrawImage( LineImage, X, Y + Height - 1 )
		End If

		If Height Then
			Local LineImage:TImage = MakeMALine( Height, Pos )
			SetRotation( 90.0 )
			DrawImage( LineImage, X, Y )
			SetRotation( -90.0 )
			DrawImage( LineImage, X + Width - 1, Y + Height )
			SetRotation( 0.0 )
		End If
	End Function
	
	
	
	Rem
	bbdoc: Creates marching ants line.
	End Rem
	Function MakeMALine:TImage( Width:Int, Pos:Int Var )
		If Width <= 0 Then Width = 1
		Local Image:TImage = CreateImage( Width, 1 )
		Local Pixmap:TPixmap = LockImage( Image )
		For Local XX:Int = 0 Until Width
			Pixmap.WritePixel( XX, 0, $FF000000 + $FFFFFF * ( Pos >= 4 ) )
			Pos = ( Pos + 1 ) Mod 8
		Next
		UnlockImage( Image )
		Return Image
	End Function
	
	
	
	Function DrawMALine( Image:TImage, X1:Int, Y1:Int, X2:Int, Y2:Int )
		SetRotation( ATan2( Y2 - Y1, X2 - X1 ) )
		If Not Image Then
			Local Pos:Int = Int( MilliSecs() / 100 ) Mod 8
			Image = MakeMALine( L_Distance( X1 - X2, Y1 - Y2 ), Pos )
		End If
		DrawImage( Image, X1, Y1 )
		SetRotation( 0.0 )
	End Function
	
	
	
	Method DrawUsingLineSegment( LineSegment:LTLineSegment )
		Local SX1:Double, SY1:Double, SX2:Double, SY2:Double
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 0 ].X, LineSegment.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( LineSegment.Pivot[ 1 ].X, LineSegment.Pivot[ 1 ].Y, SX2, SY2 )
		DrawMALine( Null, SX1, SY1, SX2, SY2 )
	End Method
End Type