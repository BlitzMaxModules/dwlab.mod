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
	
	
	
	Method DrawUsingSprite( Sprite:LTSprite )
		SetColor 255.0 * Red, 255.0 * Green, 255.0 * Blue
		SetAlpha Alpha
	
		Local SX:Double, SY:Double, SWidth:Double, SHeight:Double
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
			
			?debug
			If Sprite.Frame < 0 Or Sprite.Frame >= Image.FramesQuantity() Then L_Error( "Incorrect frame number ( " + Sprite.Frame + " ) for sprite ~q" + Sprite.Name + "~q, must be less than " + Image.FramesQuantity() )
			?
			
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
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		Image = LTImage( XMLObject.ManageObjectField( "image", Image ) )
		XMLObject.ManageDoubleAttribute( "angle", Angle )
		XMLObject.ManageIntAttribute( "rotating", Rotating, 1 )
	End Method
End Type