'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTPivotInteraction Extends LTInteraction
	Global Instance:LTPivotInteraction = New LTPivotInteraction
End Type

LTInteraction.RegisterSpriteInteraction( LTSprite.Pivot, LTPivotInteraction.Instance )



Type LTOvalInteraction Extends LTInteraction
	Global Instance:LTOvalInteraction = New LTOvalInteraction
	
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

LTInteraction.RegisterSpriteInteraction( LTSprite.Oval, LTOvalInteraction.Instance )



Type LTRectangleInteraction Extends LTInteraction
	Global Instance:LTRectangleInteraction = New LTRectangleInteraction
	
	Method SpriteCollidesWithLineSegment:Int( Rectangle:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		If LTPivotWithRectangle.Instance.SpritesCollide( LSPivot1, Rectangle ) Then Return True
		Rectangle.GetBounds( ServicePivots[ 0 ].X, ServicePivots[ 0 ].Y, ServicePivots[ 2 ].X, ServicePivots[ 2 ].Y )
		Rectangle.GetBounds( ServicePivots[ 1 ].X, ServicePivots[ 3 ].Y, ServicePivots[ 3 ].X, ServicePivots[ 1 ].Y )
		For Local N:Int = 0 To 3
			If LineSegmentCollidesWithLineSegment( ServicePivots[ N ], ServicePivots[ ( N + 1 ) Mod 4 ], LSPivot1, LSPivot2 ) Then Return True
		Next
	End Method
End Type

LTInteraction.RegisterSpriteInteraction( LTSprite.Rectangle, LTRectangleInteraction.Instance )

	
Type LTTriangleInteraction Extends LTInteraction
	Global Instance:LTTriangleInteraction = New LTTriangleInteraction
	
	Method SpriteCollidesWithLineSegment:Int( Triangle:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		If LTPivotWithTriangle.Instance.SpritesCollide( LSPivot1, Triangle ) Then Return True
		Triangle.GetOtherVertices( ServicePivots[ 0 ], ServicePivots[ 1 ] )
		Triangle.GetRightAngleVertex( ServicePivots[ 2 ] )
		For Local N:Int = 0 To 2
			If LineSegmentCollidesWithLineSegment( ServicePivots[ N ], ServicePivots[ ( N + 1 ) Mod 3 ], LSPivot1, LSPivot2 ) Then Return True
		Next
	End Method
End Type


	
Type LTRayInteraction Extends LTInteraction
	Global Instance:LTRayInteraction = New LTRayInteraction
	
	Method SpriteCollidesWithLineSegment:Int( Ray:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
		Ray.ToLine( ServiceLine1 )
		If ServiceLine1.IntersectionWithLineSegment( LSPivot1, LSPivot2, ServicePivot1 ) Then
			If Ray.HasPivot( ServicePivot1 ) Then Return True
		End If
	End Method
End Type

LTInteraction.RegisterSpriteInteraction( LTSprite.Ray, LTRayInteraction.Instance )