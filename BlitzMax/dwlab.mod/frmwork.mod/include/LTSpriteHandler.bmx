'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTSpriteHandler
	Global HandlersMap:TMap = New TMap
	
	Global ServicePivot1:LTSprite
	Global ServicePivots:LTSprite[] = New LTSprite[ 4 ]
	Global ServiceOval1:LTSprite
	Global ServiceOval2:LTSprite
	Global ServiceLine1:LTLine = New LTLine
	
	
	
	Function Register( ShapeType:LTShapeType, Handler:LTSpriteHandler )
		HandlersMap.Insert( ShapeType, Handler )
	End Function
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Sprite:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
	End Method
	
	
	
	Method DrawSprite( Visualizer:LTVisualizer, Sprite:LTSprite )
	End Method
	
	
	
	Method DrawShape( Sprite:LTSprite, SpriteShape:LTSprite, SX:Double, SY:Double, SWidth:Double, SHeight:Double )
	End Method
	
	
	
	Global HandlersArray:LTSpriteHandler[]
	
	Function Init()
		Local Quantity:Int = LTShapeType.ShapeTypes.Count()
		
		HandlersArray = New LTSpriteHandler[ Quantity ]
		For Local KeyValue:TKeyValue = Eachin HandlersMap
			HandlersArray[ LTShapeType( KeyValue.Key() ).GetNum() ] = LTSpriteHandler( KeyValue.Value() ) 
		Next
	End Function
	
	
	
	Function LineSegmentCollidesWithLineSegment:Int( LS1Pivot1:LTSprite, LS1Pivot2:LTSprite, LS2Pivot1:LTSprite, LS2Pivot2:LTSprite )
		LTLine.FromPivots( LS1Pivot1, LS1Pivot2, ServiceLine1 )
		If ServiceLine1.PivotOrientation( LS2Pivot1 ) = ServiceLine1.PivotOrientation( LS2Pivot2 ) Then Return False
		LTLine.FromPivots( LS2Pivot1, LS2Pivot2, ServiceLine1 )
		If ServiceLine1.PivotOrientation( LS1Pivot1 ) <> ServiceLine1.PivotOrientation( LS1Pivot2 ) Then Return True
	End Function
End Type





LTSpriteHandler.ServicePivot1 = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
LTSpriteHandler.ServiceOval1 = LTSprite.FromShapeType( LTSprite.Oval )
LTSpriteHandler.ServiceOval2 = LTSprite.FromShapeType( LTSprite.Oval )

For Local N:Int = 0 To 3
	LTSpriteHandler.ServicePivots[ N ] = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
Next





Type LTPivotHandler Extends LTSpriteHandler
	Global Instance:LTPivotHandler = New LTPivotHandler
End Type

LTSpriteHandler.Register( LTSprite.Pivot, LTPivotHandler.Instance )





Type LTOvalHandler Extends LTSpriteHandler
	Global Instance:LTOvalHandler = New LTOvalHandler
	
	
	
	Method DrawShape( Sprite:LTSprite, SpriteShape:LTSprite, SX:Double, SY:Double, SWidth:Double, SHeight:Double )
		If Sprite.Physics() Then SetRotation( SpriteShape.Angle )
		If SWidth = SHeight Then
			SetHandle( 0.5 * SWidth, 0.5 * SHeight )
			DrawOval( SX, SY, SWidth, SHeight )
			SetHandle( 0.0, 0.0 )
		ElseIf SWidth > SHeight Then
			Local DWidth:Double = SWidth - SHeight
			SetHandle( 0.5 * SWidth, 0.5 * SHeight )
			DrawOval( SX, SY, SHeight, SHeight )
			SetHandle( SHeight - 0.5 * SWidth, 0.5 * SHeight )
			DrawOval( SX, SY, SHeight, SHeight )
			SetHandle( 0.5 * DWidth, 0.5 * SHeight )
			DrawRect( SX, SY, DWidth, SHeight )
			SetHandle( 0.0, 0.0 )
		Else
			Local DHeight:Double = SHeight - SWidth
			SetHandle( 0.5 * SWidth, 0.5 * SHeight )
			DrawOval( SX, SY, SWidth, SWidth )
			SetHandle( 0.5 * SWidth, SWidth - 0.5 * SHeight )
			DrawOval( SX, SY, SWidth, SWidth )
			SetHandle( 0.5 * SWidth, 0.5 * DHeight )
			DrawRect( SX, SY, SWidth, DHeight )
			SetHandle( 0.0, 0.0 )
		End If
		SetOrigin( 0.0, 0.0 )
		SetRotation( 0.0 )
	End Method
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Oval:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		ServiceOval1.X = 0.5 * ( LSPivot1.X + LSPivot2.X )
		ServiceOval1.Y = 0.5 * ( LSPivot1.Y + LSPivot2.Y )
		ServiceOval1.Width = 0.5 * LSPivot1.DistanceTo( LSPivot2 )
		If LTOvalWithOval.Instance.SpritesCollide( Oval, ServiceOval1 ) Then
			LTLine.FromPivots( LSPivot1, LSPivot2, ServiceLine1 )
			Oval = Oval.ToCircleUsingLine( ServiceLine1, ServiceOval2 )
			If ServiceLine1.DistanceTo( Oval ) < 0.5 * Max( Oval.Width, Oval.Height ) - L_Inaccuracy Then
				ServiceLine1.PivotProjection( Oval, ServicePivot1 )
				If LTPivotWithOval.Instance.SpritesCollide( ServicePivot1, ServiceOval1 ) And ServicePivot1.DistanceTo( ServiceOval2 ) < ServiceOval1.Width - ..
						L_Inaccuracy Then Return True
			End If
		End If
	End Method
End Type

LTSpriteHandler.Register( LTSprite.Oval, LTOvalHandler.Instance )





Type LTRectangleHandler Extends LTSpriteHandler
	Global Instance:LTRectangleHandler = New LTRectangleHandler
	
	
	
	Method DrawShape( Sprite:LTSprite, SpriteShape:LTSprite, SX:Double, SY:Double, SWidth:Double, SHeight:Double )
		If Sprite.Physics() Then SetRotation( SpriteShape.Angle )
		SetHandle( 0.5 * SWidth, 0.5 * SHeight )
		DrawRect( SX, SY, SWidth, SHeight )
		SetHandle( 0.0, 0.0 )
		SetRotation( 0.0 )
	End Method
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Rectangle:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		If LTPivotWithRectangle.Instance.SpritesCollide( LSPivot1, Rectangle ) Then Return True
		Rectangle.GetBounds( ServicePivots[ 0 ].X, ServicePivots[ 0 ].Y, ServicePivots[ 2 ].X, ServicePivots[ 2 ].Y )
		Rectangle.GetBounds( ServicePivots[ 1 ].X, ServicePivots[ 3 ].Y, ServicePivots[ 3 ].X, ServicePivots[ 1 ].Y )
		For Local N:Int = 0 To 3
			If LineSegmentCollidesWithLineSegment( ServicePivots[ N ], ServicePivots[ ( N + 1 ) Mod 4 ], LSPivot1, LSPivot2 ) Then Return True
		Next
	End Method
End Type

LTSpriteHandler.Register( LTSprite.Rectangle, LTRectangleHandler.Instance )



	
Type LTTriangleHandler Extends LTSpriteHandler
	Global Instance:LTTriangleHandler = New LTTriangleHandler
	
	
	
	Method DrawShape( Sprite:LTSprite, SpriteShape:LTSprite, SX:Double, SY:Double, SWidth:Double, SHeight:Double )
		If Sprite.Physics() Then SetRotation( SpriteShape.Angle )
		SetOrigin( SX, SY )
		Select Sprite.ShapeType.GetNum()
			Case LTSprite.TopLeftTriangle.GetNum()
				DrawPoly( [ Float( -0.5 * SWidth ), Float( -0.5 * SHeight ), Float( 0.5 * SWidth ), Float( -0.5 * SHeight ), ..
						Float( -0.5 * SWidth ), Float( 0.5 * SHeight ) ] )
			Case LTSprite.TopRightTriangle.GetNum()
				DrawPoly( [ Float( -0.5 * SWidth ), Float( -0.5 * SHeight ), Float( 0.5 * SWidth ), Float( -0.5 * SHeight ), ..
						Float( 0.5 * SWidth ), Float( 0.5 * SHeight ) ] )
			Case LTSprite.BottomLeftTriangle.GetNum()
				DrawPoly( [ Float( -0.5 * SWidth ), Float( 0.5 * SHeight ), Float( 0.5 * SWidth ), Float( 0.5 * SHeight ), ..
						Float( -0.5 * SWidth ), Float( -0.5 * SHeight ) ] )
			Case LTSprite.BottomRightTriangle.GetNum()
				DrawPoly( [ Float( -0.5 * SWidth ), Float( 0.5 * SHeight ), Float( 0.5 * SWidth ), Float( 0.5 * SHeight ), ..
						Float( 0.5 * SWidth ), Float( -0.5 * SHeight ) ] )
		End Select
		SetOrigin( 0.0, 0.0 )
		SetRotation( 0.0 )
	End Method
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Triangle:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		If LTPivotWithTriangle.Instance.SpritesCollide( LSPivot1, Triangle ) Then Return True
		Triangle.GetOtherVertices( ServicePivots[ 0 ], ServicePivots[ 1 ] )
		Triangle.GetRightAngleVertex( ServicePivots[ 2 ] )
		For Local N:Int = 0 To 2
			If LineSegmentCollidesWithLineSegment( ServicePivots[ N ], ServicePivots[ ( N + 1 ) Mod 3 ], LSPivot1, LSPivot2 ) Then Return True
		Next
	End Method
End Type




	
Type LTRayHandler Extends LTSpriteHandler
	Global Instance:LTRayHandler = New LTRayHandler
	
	
	
	Method DrawShape( Sprite:LTSprite, SpriteShape:LTSprite, SX:Double, SY:Double, SWidth:Double, SHeight:Double )
		DrawOval( SX - 2, SY - 2, 5, 5 )
		Local Ang:Double = L_WrapDouble( SpriteShape.Angle, 360.0 )
		If Ang < 45.0 Or Ang >= 315.0 Then
			Local Width:Double = L_CurrentCamera.Viewport.RightX() - SX
			If Width > 0 Then DrawLine( SX, SY, SX + Width, SY + Width * Tan( Ang ) )
		ElseIf Ang < 135.0 Then
			Local Height:Double = L_CurrentCamera.Viewport.BottomY() - SY
			If Height > 0 Then DrawLine( SX, SY, SX + Height / Tan( Ang ), SY + Height )
		ElseIf Ang < 225.0 Then
			Local Width:Double = L_CurrentCamera.Viewport.LeftX() - SX
			If Width < 0 Then DrawLine( SX, SY, SX + Width, SY + Width * Tan( Ang ) )
		Else
			Local Height:Double = L_CurrentCamera.Viewport.TopY() - SY
			If Height < 0 Then DrawLine( SX, SY, SX + Height / Tan( Ang ), SY + Height )
		End If
	End Method
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Ray:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		Ray.ToLine( ServiceLine1 )
		If ServiceLine1.IntersectionWithLineSegment( LSPivot1, LSPivot2, ServicePivot1 ) Then
			If Ray.HasPivot( ServicePivot1 ) Then Return True
		End If
	End Method
End Type

LTSpriteHandler.Register( LTSprite.Ray, LTRayHandler.Instance )




	
Type LTSpriteTemplateHandler Extends LTSpriteHandler
	Global Instance:LTSpriteTemplateHandler = New LTSpriteTemplateHandler
	
	Field ServiceSprite:LTSprite = New LTSprite
	
	
	
	Method DrawSprite( Visualizer:LTVisualizer, Sprite:LTSprite )
		Local SpriteTemplate:LTSpriteTemplate = LTSpriteTemplate( Sprite.ShapeType )
		For Local TemplateSprite:LTSprite = Eachin SpriteTemplate.Sprites
			SpriteTemplate.SetShape( Sprite, TemplateSprite, ServiceSprite )
			TemplateSprite.Visualizer.DrawUsingSprite( TemplateSprite, ServiceSprite )
		Next
	End Method
	
	
	
	Method DrawShape( Sprite:LTSprite, SpriteShape:LTSprite, SX:Double, SY:Double, SWidth:Double, SHeight:Double )
		Local SpriteTemplate:LTSpriteTemplate = LTSpriteTemplate( Sprite.ShapeType )
		For Local TemplateSprite:LTSprite = Eachin SpriteTemplate.Sprites
			SpriteTemplate.SetShape( Sprite, TemplateSprite, ServiceSprite )
			TemplateSprite.Visualizer.DrawSpriteShape( TemplateSprite, ServiceSprite )
		Next
	End Method
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Sprite:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		Local SpriteTemplate:LTSpriteTemplate = LTSpriteTemplate( Sprite.ShapeType )
		For Local TemplateSprite:LTSprite = Eachin SpriteTemplate.Sprites
			SpriteTemplate.SetShape( Sprite, TemplateSprite, ServiceSprite )
			If LTSpriteHandler.HandlersArray[ Sprite.ShapeType.GetNum() ].SpriteCollidesWithLineSegment( Sprite, LSPivot1, LSPivot2 ) Then Return True
		Next
	End Method
End Type

LTSpriteHandler.Register( LTSprite.SpriteTemplate, LTSpriteTemplateHandler.Instance )