'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global L_EmptyTilemapFrame:Int = -1

Type LTImageVisualizer Extends LTVisualizer
	Field Image:LTImage

	
	
	Function FromFile:LTImageVisualizer( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		Local ImageVisualizer:LTImageVisualizer = New LTImageVisualizer
		ImageVisualizer.Image = LTImage.FromFile( Filename, XCells, YCells )
		Return ImageVisualizer
	End Function
	
	
	
	Function FromImage:LTImageVisualizer( Image:LTImage )
		Local ImageVisualizer:LTImageVisualizer = New LTImageVisualizer
		ImageVisualizer.Image = Image
		Return ImageVisualizer
	End Function
	
	
	
	Method GetImage:LTImage()
		Return Image
	End Method
	
	
	
	Method SetImage( NewImage:LTImage )
		Image = NewImage
	End Method
	
	
	
	Method SetDXDY( NewDX:Float, NewDY:Float )
		DX = NewDX
		DY = NewDY
	End Method
	
	
	
	Method DrawUsingSprite( Sprite:LTSprite )
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha Alpha
	
		Local SX:Float, SY:Float, SWidth:Float, SHeight:Float
		L_CurrentCamera.FieldToScreen( Sprite.X + DX, Sprite.Y + DY, SX, SY )
		
		Local AngularSprite:LTAngularSprite = LTAngularSprite( Sprite )
		If Rotating And AngularSprite Then
			SetRotation( Angle + AngularSprite.Angle )
		Else
			SetRotation( Angle )
		End If
		
		If Image Then
			If Scaling Then
				L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
				SetScale( XScale * SWidth / ImageWidth( Image.BMaxImage ), YScale * SHeight / ImageHeight( Image.BMaxImage ) )
			Else
				SetScale XScale, YScale
			End If
			
			If Sprite.Frame < 0 Or Sprite.Frame >= Image.FramesQuantity() Then L_Error( "Incorrect frame number ( " + Sprite.Frame + " ) for sprite ~q" + Sprite.Name + "~q, must be less than " + Image.FramesQuantity() )
			
			DrawImage( Image.BMaxImage, SX, SY, Sprite.Frame )
		Else
			L_CurrentCamera.SizeFieldToScreen( Sprite.Width, Sprite.Height, SWidth, SHeight )
			DrawRect( SX - 0.5 * SWidth, SY - 0.5 * SHeight, SWidth, SHeight )
		End If
		
		SetScale( 1.0, 1.0 )
		SetRotation( 0.0 )
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap )
		If Not Image Then Return
	
		Local FrameMap:LTIntMap = TileMap.FrameMap
	
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha Alpha
	
		Local SWidth:Float, SHeight:Float
		Local CellWidth:Float = TileMap.Width / FrameMap.XQuantity
		Local CellHeight:Float = TileMap.Height / FrameMap.YQuantity
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
					DrawTile( FrameMap, XX, YY, XFrame & FrameMap.XMask, YFrame & FrameMap.YMask )
				Else
					DrawTile( FrameMap, XX, YY, FrameMap.WrapX( XFrame ), FrameMap.WrapY( YFrame ) )
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
	
	
	
	Method DrawTile( FrameMap:LTIntMap, X:Float, Y:Float, TileX:Int, TileY:Int )
		Local Value:Int = FrameMap.Value[ TileX, TileY ]
		If Value <> L_EmptyTilemapFrame Then Drawimage( Image.BMaxImage, X, Y, Value )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
		XMLObject.ManageFloatAttribute( "angle", Angle )
		XMLObject.ManageIntAttribute( "rotating", Rotating, 1 )
	End Method
End Type