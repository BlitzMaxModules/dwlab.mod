'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTTileMap Extends LTRectangle
	Field FrameMap:LTIntMap
	Field ShapeMap:LTShape[ , ]
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingTileMap( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
		Vis.DrawUsingTileMap( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWithPivot:Int( Pivot:LTPivot )
		Local RX:Float = X - 0.5 * XSize
		Local RY:Float = Y - 0.5 * YSize
		Local CellXSize:Float = XSize / FrameMap.XQuantity
		Local CellYSize:Float = YSize / FrameMap.YQuantity
		Local X1:Int = Int( ( Pivot.X - RX ) / CellXSize )
		Local Y1:Int = Int( ( Pivot.Y - RY ) / CellYSize )
		
		If X1 >= 0 And Y1 >= 0 And X1 < FrameMap.XQuantity And Y1 < FrameMap.YQuantity Then
			Local Shape:LTShape = ShapeMap[ X1, Y1 ]
			If Shape Then
				Local Collision:Int = Shape.CollidesWithPivot( Pivot )
				If Collision Then Pivot.HandleCollision( Shape )
				Return Collision
			End If
		End If
	End Method
	
	
	
	Method CollidesWithCircle:Int( Circle:LTCircle )
		Local RX:Float = X - 0.5 * XSize
		Local RY:Float = Y - 0.5 * YSize
		Local CellXSize:Float = XSize / FrameMap.XQuantity
		Local CellYSize:Float = YSize / FrameMap.YQuantity
		Local Radius:Float = 0.5 * Circle.Diameter
		Local X1:Int = L_LimitInt( Int( ( Circle.X - Radius - RX ) / CellXSize ), 0, FrameMap.XQuantity )
		Local Y1:Int = L_LimitInt( Int( ( Circle.Y - Radius - RY ) / CellYSize ), 0, FrameMap.YQuantity )
		Local X2:Int = L_LimitInt( Int( ( Circle.X + Radius - RX ) / CellXSize ), 0, FrameMap.XQuantity - 1)
		Local Y2:Int = L_LimitInt( Int( ( Circle.Y + Radius - RY ) / CellYSize ), 0, FrameMap.YQuantity - 1)
		'Debuglog x1 + ", " + y1 + ", " + x2 + ", " + y2
		'waitkey
		Local Collided:Int = False
		For Local Y:Int = Y1 To Y2
			For Local X:Int = X1 To X2
				Local Shape:LTShape = ShapeMap[ X, Y ]
				If Shape Then
					Local Collision:Int = Shape.CollidesWithCircle( Circle )
					If Collision Then Circle.HandleCollision( Shape )
					Collided = Collided And Collision
				End If
			Next
		Next
		Return Collided
	End Method
	
	
	
	Method CollidesWithRectangle:Int( Rectangle:LTRectangle )
		Local RX:Float = X - 0.5 * XSize
		Local RY:Float = Y - 0.5 * YSize
		Local CellXSize:Float = XSize / FrameMap.XQuantity
		Local CellYSize:Float = YSize / FrameMap.YQuantity
		Local X1:Int = L_LimitInt( Int( ( Rectangle.X - 0.5 * Rectangle.XSize - RX ) / CellXSize ), 0, FrameMap.XQuantity )
		Local Y1:Int = L_LimitInt( Int( ( Rectangle.Y - 0.5 * Rectangle.YSize - RY ) / CellYSize ), 0, FrameMap.YQuantity )
		Local X2:Int = L_LimitInt( Int( ( Rectangle.X + 0.5 * Rectangle.XSize - RX ) / CellXSize ), 0, FrameMap.XQuantity - 1 )
		Local Y2:Int = L_LimitInt( Int( ( Rectangle.Y + 0.5 * Rectangle.YSize - RY ) / CellYSize ), 0, FrameMap.YQuantity - 1 )
		
		Local Collided:Int = False
		For Local Y:Int = Y1 To Y2
			For Local X:Int = X1 To X2
				Local Shape:LTShape = ShapeMap[ X, Y ]
				If Shape Then
					Local Collision:Int = Shape.CollidesWithRectangle( Rectangle )
					If Collision Then Rectangle.HandleCollision( Shape )
					Collided = Collided And Collision
				End If
			Next
		Next
		Return Collided
	End Method
	
	
	
	Method FillShapeMap( ShapeArray:LTShape[] )
		Local CellXSize:Float = XSize / FrameMap.XQuantity
		Local CellYSize:Float = YSize / FrameMap.YQuantity
		Local DX:Float = X - 0.5 * XSize' + 0.5 * CellXSize
		Local DY:Float = Y - 0.5 * YSize' + 0.5 * CellYSize
	
		ShapeMap = New LTShape[ FrameMap.XQuantity, FrameMap.YQuantity ]
		For Local Y:Int = 0 Until FrameMap.YQuantity
			For Local X:Int = 0 Until FrameMap.XQuantity
				Local Shape:LTShape = ShapeArray[ FrameMap.Value[ X, Y ] ]
				If Shape Then
					ShapeMap[ X, Y ] = Shape.CloneShape( DX + CellXSize * X, DY + CellYSize * Y, CellXSize, CellYSize )
					ShapeMap[ X, Y ].SetMass( -1.0 )
				End If
			Next
		Next
	End Method
End Type