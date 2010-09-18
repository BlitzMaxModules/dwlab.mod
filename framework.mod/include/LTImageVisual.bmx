'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTImage.bmx"

Type LTImageVisual Extends LTVisual
	Field Image:LTImage
	
	
	
	Function FromFile:LTImageVisual( Filename:String, XCells:Int = 1, YCells:Int = 1 )
		Local ImageVisual:LTImageVisual = New LTImageVisual
		ImageVisual.Image = LTImage.FromFile( Filename, XCells, YCells )
		Return ImageVisual
	End Function
	
	
	
	Method DrawUsingActor( Actor:LTActor )
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local SX:Float, SY:Float, SXSize:Float, SYSize:Float
		L_CurrentCamera.FieldToScreen( Actor.X, Actor.Y, SX, SY )
		
		If Rotating Then
			SetRotation( Angle + Actor.Model.GetAngle() )
		Else
			SetRotation( Angle )
		End If
		
		If Scaling Then
			L_CurrentCamera.SizeFieldToScreen( Actor.XSize, Actor.YSize, SXSize, SYSize )
			SetScale( XScale * SXSize / ImageWidth( Image.BMaxImage ), YScale * SYSize / ImageHeight( Image.BMaxImage ) )
		Else
			SetScale XScale, YScale
		End If
		
		DrawImage( Image.BMaxImage, SX, SY, Actor.Frame )
		
		SetScale( 1.0, 1.0 )
		SetRotation( 0.0 )
		SetColor 255, 255, 255
		SetAlpha 1.0
	End Method
	
	
	
	Method DrawUsingTileMap( TileMap:LTTileMap )
		Local FrameMap:LTIntMap = TileMap.FrameMap
	
		SetColor 255.0 * R, 255.0 * G, 255.0 * B
		SetAlpha Alpha
	
		Local SXSize:Float, SYSize:Float
		Local CellXSize:Float = TileMap.XSize / FrameMap.XQuantity
		Local CellYSize:Float = TileMap.YSize / FrameMap.YQuantity
		L_CurrentCamera.SizeFieldToScreen( CellXSize, CellYSize, SXSize, SYSize )
		SetScale( SXSize / ImageWidth( Image.BMaxImage ), SYSize / ImageHeight( Image.BMaxImage ) )
		
		Local SX:Float, SY:Float
		L_CurrentCamera.FieldToScreen( TileMap.X - 0.5 * TileMap.XSize, TileMap.Y - 0.5 * TileMap.YSize, SX, SY )

		Local X1:Float = L_CurrentCamera.ViewPort.X - 0.5 * L_CurrentCamera.ViewPort.XSize
		Local Y1:Float = L_CurrentCamera.ViewPort.Y - 0.5 * L_CurrentCamera.ViewPort.YSize
		Local X2:Float = X1 + L_CurrentCamera.ViewPort.XSize + SXSize * 0.5
		Local Y2:Float = Y1 + L_CurrentCamera.ViewPort.YSize + SYSize * 0.5
		
		Local StartXFrame:Int = Int( ( L_CurrentCamera.X - TileMap.X - 0.5 * ( L_CurrentCamera.XSize - TileMap.XSize ) ) / CellXSize )
		Local StartYFrame:Int = Int( ( L_CurrentCamera.Y - TileMap.Y - 0.5 * ( L_CurrentCamera.YSize - TileMap.YSize ) ) / CellYSize )
		Local StartX:Float = SX + SXSize * ( Int( ( X1 - SX ) / SXSize ) ) + SXSize * 0.5
		Local StartY:Float = SY + SYSize * ( Int( ( Y1 - SY ) / SYSize ) ) + SYSize * 0.5
		
		If Not TileMap.Wrapped Then
			If StartXFrame < 0 Then 
				StartX :- StartXFrame * SXSize
				StartXFrame = 0
			End If
			Local EndX:Float = StartX + SXSize * ( FrameMap.XQuantity - StartXFrame )
			If  EndX < X2  Then X2 = EndX
			
			If StartYFrame < 0 Then 
				StartY :- StartYFrame * SYSize
				StartYFrame = 0
			End If
			Local EndY:Float = StartY + SYSize * ( FrameMap.YQuantity - StartYFrame )
			If  EndY < Y2  Then Y2 = EndY
		End If
		
		Local YY:Float = StartY
		Local YFrame:Int = StartYFrame
		While YY < Y2
			Local XX:Float = StartX
			Local XFrame:Int = StartXFrame
			While XX < X2
				DrawTile( FrameMap, XX, YY, L_Wrap( XFrame, FrameMap.XQuantity ), L_Wrap( YFrame, FrameMap.YQuantity ) )
				XX = XX + SXSize
				XFrame :+ 1
			Wend
			YY = YY + SYSize
			YFrame :+ 1
		Wend
		
		SetColor( 255, 255, 255 )
		SetScale( 1.0, 1.0 )
		SetAlpha( 1.0 )
	End Method
	
	
	
	Method DrawTile( FrameMap:LTIntMap, X:Float, Y:Float, TileX:Int, TileY:Int )
		Drawimage( Image.BMaxImage, X, Y, FrameMap.Value[ TileX, TileY ] )
	End Method
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
		XMLObject.ManageIntAttribute( "rotating", Rotating, 1 )
	End Method
End Type