'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTSpriteTemplate Extends LTShapeType
	Global ServiceRectangle:LTSprite
	Global ServiceSprite:LTSprite
	
	Field Name:String
	Field Sprites:TList = New TList
	
	
	
	Method GetNum:Int()
		Return 9
	End Method
	
	
	
	Method GetName:String()
		Return Name
	End Method
	
	
		
	Method Singleton:Int()
		Return False
	End Method
	
	
		
	Method CustomDrawing:Int()
		Return True
	End Method
	
	
	
	Method SetShape( Sprite:LTSprite, TemplateSprite:LTSprite, SpriteShape:LTSprite )
		If Sprite.DisplayingAngle = 0 Then
			SpriteShape.X = TemplateSprite.X * Sprite.Width + Sprite.X
			SpriteShape.Y = TemplateSprite.Y * Sprite.Height + Sprite.Y
		Else
			Local RelativeX:Double = TemplateSprite.X * Sprite.Width
			Local RelativeY:Double = TemplateSprite.Y * Sprite.Height
			SpriteShape.X = RelativeX * Cos( Sprite.DisplayingAngle ) - RelativeY * Sin( Sprite.DisplayingAngle ) + Sprite.X
			SpriteShape.Y = RelativeX * Sin( Sprite.DisplayingAngle ) + RelativeY * Cos( Sprite.DisplayingAngle ) + Sprite.Y
		End If
		SpriteShape.Width = Sprite.Width * TemplateSprite.Width
		SpriteShape.Height = Sprite.Height * TemplateSprite.Height
		SpriteShape.DisplayingAngle = Sprite.DisplayingAngle + TemplateSprite.DisplayingAngle
	End Method
	
	
	
	Method GetTileSprite:LTSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double )
		ServiceRectangle.X = Sprite.X * XScale + DX
		ServiceRectangle.Y = Sprite.Y * YScale + DY
		ServiceRectangle.Width = Sprite.Width * XScale
		ServiceRectangle.Height = Sprite.Height * YScale
		ServiceRectangle.ShapeType = Sprite.ShapeType
		Return ServiceRectangle
	End Method
	
	
	
	Function FromSprites:LTSpriteTemplate( Sprites:TList, Layer:LTLayer = Null, PivotShape:LTShape = Null, Relativity:Int = LTShape.After )
		Local Template:LTSpriteTemplate = Null
		Local LeftX:Double, TopY:Double, RightX:Double, BottomY:Double
		Local NewSprite:LTSprite = New LTSprite
		
		For Local Sprite:LTSprite = Eachin Sprites
			If Sprite.ShapeType.GetNum() = LTSprite.SpriteTemplate.GetNum() Then Continue
			If Template Then
				LeftX = Min( LeftX, Sprite.LeftX() )
				TopY = Min( TopY, Sprite.TopY() )
				RightX = Max( RightX, Sprite.RightX() )
				BottomY = Max( BottomY, Sprite.BottomY() )
			Else
				Template = New LTSpriteTemplate
				LeftX = Sprite.LeftX()
				TopY = Sprite.TopY()
				RightX = Sprite.RightX()
				BottomY = Sprite.BottomY()
				If Not PivotShape Then PivotShape = Sprite
			End If
		Next
		
		If Template Then
			NewSprite.X = 0.5 * ( LeftX + RightX )
			NewSprite.Y = 0.5 * ( TopY + BottomY )
			NewSprite.Width = RightX - LeftX
			NewSprite.Height = BottomY - TopY
			NewSprite.ShapeType = Template
			If Layer Then Layer.InsertShape( NewSprite, , PivotShape, Relativity )
			
			For Local Sprite:LTSprite = Eachin Sprites
				If Sprite.ShapeType.GetNum() = LTSprite.SpriteTemplate.GetNum() Then Continue
				Layer.Remove( Sprite )
				Sprite.X = ( NewSprite.X - Sprite.X ) / NewSprite.Width
				Sprite.Y = ( NewSprite.Y - Sprite.Y ) / NewSprite.Height
				Sprite.Width :/ NewSprite.Width
				Sprite.Height :/ NewSprite.Height
				Template.Sprites.AddLast( Sprite )
			Next
		End If
		
		Return Template
	End Function
	
	
	
	Method ToSprites( Sprite:LTSprite, Layer:LTLayer, PivotShape:LTShape = Null, Relativity:Int = LTShape.Before )
		Local NewSprites:TList = New TList
		For Local TemplateSprite:LTSprite = Eachin Sprites
			Local NewSprite:LTSprite = New LTSprite
			TemplateSprite.CopySpriteTo( NewSprite )
			SetShape( Sprite, TemplateSprite, NewSprite )
			NewSprites.AddLast( NewSprite )
		Next
		Layer.InsertShape( , NewSprites, PivotShape, Relativity )
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "name", Name )
		XMLObject.ManageChildList( Sprites )
	End Method
End Type



LTShapeType.Register( New LTSpriteTemplate )
LTSpriteTemplate.ServiceSprite = New LTSprite
LTSpriteTemplate.ServiceRectangle = New LTSprite