'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTVisualizer Extends LTObject
	Field Red:Float = 1.0, Green:Float = 1.0, Blue:Float = 1.0
	Field Alpha:Float = 1.0
	FIeld DX:Float = 0.0, DY:Float = 0.0
	Field XScale:Float = 1.0, YScale:Float = 1.0
	Field Scaling:Int = True
	Field Angle:Float = 0.0
	Field Rotating:Int = True

	' ==================== Parameters ====================
	
	Method SetDXDY( NewDX:Float, NewDY:Float )
		DX = NewDX
		DY = NewDY
	End Method
	
	
	
	Method SetVisualizerScale( NewXScale:Float, NewYScale:Float )
		XScale = NewXScale
		YScale = NewYScale
	End Method
	
	
	
	Method GetImage:LTImage()
	End Method
	
	
	
	Method SetImage( NewImage:LTImage )
	End Method
	
	' ==================== Drawing ===================	
	
	Method DrawUsingSprite( Sprite:LTSprite )
		ApplyColor()
		
		Local SX:Float, SY:Float, SWidth:Float, SHeight:Float
		L_CurrentCamera.FieldToScreen( Sprite.X + DX, Sprite.Y + DY, SX, SY )
		L_CurrentCamera.SizeFieldToScreen( Sprite.Width * XScale, Sprite.Height * YScale, SWidth, SHeight )
		
		Select Sprite.ShapeType
			Case LTSprite.Pivot
				DrawOval( SX - 2, SY - 2, 5, 5 )
			Case LTSprite.Circle
				DrawOval( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
			Case LTSprite.Rectangle
				DrawRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
		End Select
		
		ResetColor()
	End Method
	
	
	
	Method DrawUsingLine( Line:LTLine )
		ApplyColor()
		
		Local SX1:Float, SY1:Float, SX2:Float, SY2:Float
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, SX1, SY1 )
		L_CurrentCamera.FieldToScreen( Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y, SX2, SY2 )
		
		DrawLine( SX1, SY1, SX2, SY2 )
		
		ResetColor()
	End Method
	
	

	Method DrawUsingTileMap( TileMap:LTTileMap )
		Local TileSet:LTTileSet = TileMap.TileSet
		If Not TileSet Then Return
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then Return
	
		Local FrameMap:LTIntMap = TileMap.FrameMap
	
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha Alpha
	
		Local SWidth:Float, SHeight:Float
		Local CellWidth:Float = TileMap.GetCellWidth()
		Local CellHeight:Float = TileMap.GetCellHeight()
		L_CurrentCamera.SizeFieldToScreen( CellWidth, CellHeight, SWidth, SHeight )
		SetScale( SWidth / ImageWidth( Image.BMaxImage ), SHeight / ImageHeight( Image.BMaxImage ) )
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( TileMap.X - 0.5 * TileMap.Width, TileMap.Y - 0.5 * TileMap.Height, SX, SY )

		Local X1:Float = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.Width
		Local Y1:Float = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.Height
		Local X2:Float = X1 + L_CurrentCamera.ViewPort.Width + SWidth * 0.5
		Local Y2:Float = Y1 + L_CurrentCamera.ViewPort.Height + SHeight * 0.5
		
		Local StartXFrame:Int = Int( ( L_CurrentCamera.X - TileMap.X - 0.5 * ( L_CurrentCamera.Width - TileMap.Width ) ) / CellWidth )
		Local StartYFrame:Int = Int( ( L_CurrentCamera.Y - TileMap.Y - 0.5 * ( L_CurrentCamera.Height - TileMap.Height ) ) / CellHeight )
		Local StartX:Float = SX + SWidth * ( Int( ( X1 - SX ) / SWidth ) ) + SWidth * 0.5
		Local StartY:Float = SY + SHeight * ( Int( ( Y1 - SY ) / SHeight ) ) + SHeight * 0.5
		
		If Not TileMap.Wrapped Then
			If StartXFrame < 0 Then 
				StartX :- StartXFrame * SWidth
				StartXFrame = 0
			End If
			Local EndX:Float = StartX + SWidth * ( FrameMap.XQuantity - StartXFrame ) - 0.001
			If  EndX < X2  Then X2 = EndX
			
			If StartYFrame < 0 Then 
				StartY :- StartYFrame * SHeight
				StartYFrame = 0
			End If
			Local EndY:Float = StartY + SHeight * ( FrameMap.YQuantity - StartYFrame ) - 0.001
			If  EndY < Y2  Then Y2 = EndY
		End If
		
		Local YY:Float = StartY
		Local YFrame:Int = StartYFrame
		While YY < Y2
			Local XX:Float = StartX
			Local XFrame:Int = StartXFrame
			While XX < X2
				If FrameMap.Masked Then
					DrawTile( TileMap, XX, YY, XFrame & FrameMap.XMask, YFrame & FrameMap.YMask )
				Else
					DrawTile( TileMap, XX, YY, FrameMap.WrapX( XFrame ), FrameMap.WrapY( YFrame ) )
				End If
				XX = XX + SWidth
				XFrame :+ 1
			Wend
			YY = YY + SHeight
			YFrame :+ 1
		Wend
		
		SetColor( 255, 255, 255 )
		SetScale( 1.0, 1.0 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method DrawTile( TileMap:LTTileMap, X:Float, Y:Float, TileX:Int, TileY:Int )
		Local Value:Int = TileMap.FrameMap.Value[ TileX, TileY ]
		If Value <> L_EmptyTilemapFrame Then Drawimage( TileMap.TileSet.Image.BMaxImage, X, Y, Value )
	End Method
	
	' ==================== Other ====================
	
	Method SetColorFromHex( S:String )
		Red = 1.0 * L_HexToInt( S[ 0..2 ] ) / 255.0
		Green = 1.0 * L_HexToInt( S[ 2..4 ] ) / 255.0
		Blue = 1.0 * L_HexToInt( S[ 4..6 ] ) / 255.0
	End Method
	
	
	
	Method SetColorFromRGB( NewRed:Float, NewGreen:Float, NewBlue:Float )
		?debug
		If NewRed < 0.0 Or NewRed > 1.0 Then L_Error( "Red component must be between 0.0 and 1.0 inclusive" )
		If NewGreen < 0.0 Or NewGreen > 1.0 Then L_Error( "Green component must be between 0.0 and 1.0 inclusive" )
		If NewBlue < 0.0 Or NewBlue > 1.0 Then L_Error( "Blue component must be between 0.0 and 1.0 inclusive" )
		?
		
		Red = NewRed
		Green = NewGreen
		Blue = NewBlue
	End Method
	
	
	
	Method AlterColor( D1:Float, D2:Float )
		Red = L_LimitFloat( Red + Rnd( D1, D2 ), 0.0, 1.0 )
		Green = L_LimitFloat( Green + Rnd( D1, D2 ), 0.0, 1.0 )
		Blue = L_LimitFloat( Blue + Rnd( D1, D2 ), 0.0, 1.0 )
	End Method
	
	
	
	Method ApplyColor()
		SetColor( 255.0 * Red, 255.0 * Green, 255.0 * Blue )
		SetAlpha( Alpha )
	End Method
	
	
	
	Method ResetColor()
		SetColor( 255, 255, 255 )
		SetAlpha( 1.0 )
	End Method
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageFloatAttribute( "red", Red, 1.0 )
		XMLObject.ManageFloatAttribute( "green", Green, 1.0 )
		XMLObject.ManageFloatAttribute( "blue", Blue, 1.0 )
		XMLObject.ManageFloatAttribute( "alpha", Alpha, 1.0 )
		XMLObject.ManageFloatAttribute( "xscale", XScale, 1.0 )
		XMLObject.ManageFloatAttribute( "yscale", YScale, 1.0 )
		XMLObject.ManageIntAttribute( "scaling", Scaling, 1 )
	End Method
End Type





Global L_DefaultVisualizer:LTVisualizer = New LTVisualizer