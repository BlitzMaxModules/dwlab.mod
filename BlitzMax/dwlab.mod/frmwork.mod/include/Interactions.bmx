'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "SpriteInteraction.bmx"
Include "SpritesInteraction.bmx"

Rem
bbdoc: Constant for dealing with inaccuracy of double type operations.
End Rem
Global L_Inaccuracy:Double = 0.000001

Type LTInteraction
	Global ServicePivot1:LTSprite
	Global ServicePivot2:LTSprite
	Global ServicePivot3:LTSprite
	Global ServicePivot4:LTSprite
	Global ServicePivots:LTSprite[] = New LTSprite[ 4 ]
	Global ServiceOval1:LTSprite
	Global ServiceOval2:LTSprite
	Global ServiceLineSegment:LTLineSegment = New LTLineSegment
	Global ServiceLine1:LTLine = New LTLine
	Global ServiceLine2:LTLine = New LTLine
	Global ServiceLines:LTLine[] = New LTLine[ 2 ]
	
	
	
	Method SpritesCollide:Int( Sprite1:LTSprite, Sprite2:LTSprite )
	End Method
	
	
	
	Method SpriteCollidesWithLineSegment:Int( Sprite:LTSprite, LSPivot1:LTSprite, LSPivot2:LTSprite )
	End Method
	
	
	
	Method SpriteOverlapsSprite:Int( Sprite1:LTSprite, Sprite2:LTSprite )
	End Method
	
	
	
	Method WedgeOffSprites( Sprite1:LTSprite, Sprite2:LTSprite, DX:Double Var, DY:Double Var )
	End Method
	
	
	
	Global SpritesInteractionsMap:TMap = New TMap
	
	Function RegisterSpritesInteraction( ShapeType1:LTShapeType, ShapeType2:LTShapeType, Interaction:LTInteraction )
		Local Map:TMap = TMap( SpritesInteractionsMap.ValueForKey( ShapeType1 ) )
		If Not Map Then
			Map = New TMap
			SpritesInteractionsMap.Insert( ShapeType1, Map )
		End If
		Map.Insert( ShapeType2, Interaction )
	End Function
	
	
	
	Global SpriteInteractionsMap:TMap = New TMap
	
	Function RegisterSpriteInteraction( ShapeType:LTShapeType, Interaction:LTInteraction )
		SpriteInteractionsMap.Insert( ShapeType, Interaction )
	End Function
	
	
	
	Global SpritesInteractionsArray:LTInteraction[,]
	Global SpriteInteractionsArray:LTInteraction[]
	
	Function Init()
		Local Quantity:Int = LTShapeType.ShapeTypes.Count()
		
		SpritesInteractionsArray = New LTInteraction[ Quantity, Quantity ]
		For Local KeyValue1:TKeyValue = Eachin SpritesInteractionsMap
			Local ShapeType1:LTShapeType = LTShapeType( KeyValue1.Key() )
			For Local KeyValue2:TKeyValue = Eachin TMap( KeyValue1.Value() )
				SpritesInteractionsArray[ ShapeType1.GetNum(), LTShapeType( KeyValue2.Key() ).GetNum() ] = LTInteraction( KeyValue2.Value() ) 
			Next
		Next
		
		SpriteInteractionsArray = New LTInteraction[ Quantity ]
		For Local KeyValue:TKeyValue = Eachin SpriteInteractionsMap
			SpriteInteractionsArray[ LTShapeType( KeyValue.Key() ).GetNum() ] = LTInteraction( KeyValue.Value() ) 
		Next		
	End Function
	
	
	
	Function LineSegmentCollidesWithLineSegment:Int( LS1Pivot1:LTSprite, LS1Pivot2:LTSprite, LS2Pivot1:LTSprite, LS2Pivot2:LTSprite )
		LTLine.FromPivots( LS1Pivot1, LS1Pivot2, ServiceLine1 )
		If ServiceLine1.PivotOrientation( LS2Pivot1 ) = ServiceLine1.PivotOrientation( LS2Pivot2 ) Then Return False
		LTLine.FromPivots( LS2Pivot1, LS2Pivot2, ServiceLine1 )
		If ServiceLine1.PivotOrientation( LS1Pivot1 ) <> ServiceLine1.PivotOrientation( LS1Pivot2 ) Then Return True
	End Function
	
	
	
	Function PopAngle( Triangle1:LTSprite, Triangle2:LTSprite, DY:Double Var )
		Triangle2.GetRightAngleVertex( ServicePivots[ 0 ] )
		Triangle2.GetHypotenuse( ServiceLines[ 0 ] )
		Triangle1.GetOtherVertices( ServicePivots[ 1 ], ServicePivots[ 2 ] )
		Local O:Int = ServiceLines[ 0 ].PivotOrientation( ServicePivots[ 0 ] )
		For Local N:Int = 1 To 2
			If O = ServiceLines[ 0 ].PivotOrientation( ServicePivots[ N ] ) Then
				If L_DoubleInLimits( ServicePivots[ N ].X, Triangle2.LeftX(), Triangle2.RightX() ) Then
					DY = Max( DY, Abs( ServiceLines[ 0 ].GetY( ServicePivots[ N ].X ) - ServicePivots[ N ].Y ) )
				End If
			End If
		Next
	End Function
End Type



LTInteraction.ServicePivot1 = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
LTInteraction.ServicePivot2 = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
LTInteraction.ServicePivot3 = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
LTInteraction.ServicePivot4 = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
LTInteraction.ServiceOval1 = LTSprite.FromShapeType( LTSprite.Oval )
LTInteraction.ServiceOval2 = LTSprite.FromShapeType( LTSprite.Oval )

For Local N:Int = 0 To 3
	LTInteraction.ServicePivots[ N ] = LTSprite.FromShape( 0, 0, 0, 0, LTSprite.Pivot )
	If N < 2 Then LTInteraction.ServiceLines[ N ] = New LTLine
Next

Local Triangles:LTShapeType[] = [ LTShapeType( LTSprite.TopLeftTriangle ), LTShapeType( LTSprite.TopRightTriangle ), ..
		LTShapeType( LTSprite.BottomLeftTriangle ), LTShapeType( LTSprite.BottomRightTriangle ) ]

For Local Triangle:LTShapeType = Eachin Triangles
	LTInteraction.RegisterSpritesInteraction( LTSprite.Pivot, Triangle, LTPivotWithTriangle.Instance )
	LTInteraction.RegisterSpritesInteraction( LTSprite.Oval, Triangle, LTOvalWithTriangle.Instance )
	LTInteraction.RegisterSpritesInteraction( LTSprite.Rectangle, Triangle, LTRectangleWithTriangle.Instance )
	LTInteraction.RegisterSpritesInteraction( LTSprite.Ray, Triangle, LTRayWithTriangle.Instance )
	For Local Triangle2:LTShapeType = Eachin Triangles
		LTInteraction.RegisterSpritesInteraction( Triangle, Triangle2, LTTriangleWithTriangle.Instance )
	Next
	LTInteraction.RegisterSpriteInteraction( Triangle, LTTriangleInteraction.Instance )
Next