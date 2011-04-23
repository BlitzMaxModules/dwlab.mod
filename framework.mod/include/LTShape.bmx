'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTGroup.bmx"
Include "LTSprite.bmx"
Include "LTTileMap.bmx"
Include "LTLine.bmx"
Include "LTGraph.bmx"

Type LTShape Extends LTObject
	Field X:Float
	Field Y:Float
	Field Width:Float = 1.0
	Field Height:Float = 1.0
	Field Visualizer:LTVisualizer = L_DefaultVisualizer
	Field Visible:Int = True
	Field Active:Int = True
	
	' ==================== Drawing ===================
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
	End Method
	
	' ==================== Collisions ===================
	
	Method GetCollisionType:Int( Shape:LTShape )
		Local DX:Float = Shape.X - X
		Local DY:Float = Shape.Y - Y
		If Abs( DX ) > Abs( DY ) Then
			If DX < 0 Then Return L_Left Else Return L_Right
		Else	
			If DY < 0 Then Return L_Up Else Return L_Down
		End If
	End Method
	
	
	Rem
	bbdoc:Checks if objects collide.
	returns:True if objects collide.
	EndRem
	Method CollidesWith:Int( Shape:LTShape )
	End Method
	
	
	
	Method CollidesWithSprite:Int( Sprite:LTSprite )
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
	End Method
	
	
	Rem
	bbdoc:Checks collisions of objects and executes @HandleCollision for each collision.
	EndRem
	Method CollisionsWith( Obj:LTShape )
	End Method
	
	
	
	Method CollisionsWithSprite( Sprite:LTSprite )
	End Method
	
	
	
	Method CollisionsWithLine( Line:LTLine )
	End Method
	
	
	
	Method TileCollidesWithSprite:Int( Sprite:LTSprite, DX:Float, DY:Float, XScale:Float, YScale:Float )
	End Method
	

	
	Method HandleCollisionWith( Obj:LTShape, CollisionType:Int )
	End Method
	
	
	
	Method HandleCollisionWithTile( TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
	End Method
	
	' ==================== Pushing ====================
	
	Rem
	bbdoc:Wedges off shapes.
	about:Wedging off depends on masses of shapes:
	[ First shape | Second shape | Result 
	* less than 0 | bigger than 0 | Second shape will move from first, first will remain unmoved
	* more than 0 | 0 | Second shape will move from first, first will remain unmoved
	* less than 0 | less than 0 | Shapes will be moved from each other with same coefficients.
	* 0 | 0 | Shapes will be moved from each other with same coefficients.
	]	 
	EndRem
	Method WedgeOffWith( Shape:LTShape, SelfMass:Float, ShapeMass:Float )
	End Method


	
	Method WedgeOffWithSprite( Sprite:LTSprite, SelfMass:Float, SpriteMass:Float )
	End Method
	
	
	
	Method PushFrom( Shape:LTShape )
		WedgeOffWith( Shape, 0.0, 1.0 )
	End Method	

	' ==================== Position ====================
	
	Method CornerX:Float()
 		Return X - 0.5 * Width
 	End Method
	
	
	
	Method CornerY:Float()
 		Return Y - 0.5 * Height
 	End Method

	
	
	Method DistanceToPoint:Float( PointX:Float, PointY:Float )
		Local DX:Float = X - PointX
		Local DY:Float = Y - PointY
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method DistanceToShape:Float( Shape:LTShape )
		Local DX:Float = X - Shape.X
		Local DY:Float = Y - Shape.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method IsAtPositionOfShape:Int( Shape:LTShape )
		If Shape.X = X And Shape.Y = Y Then Return True
	End Method
	
	
	
	Method SetCoords( NewX:Float, NewY:Float )
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Method AlterCoords( DX:Float, DY:Float )
		SetCoords( X + DX, Y + DY )
	End Method
	
	
	
	Method SetCornerCoords( NewX:Float, NewY:Float )
		SetCoords( NewX + Width * 0.5, NewY + Height * 0.5 )
	End Method
	
	
	
	Method JumpToShape( Shape:LTShape )
		SetCoords( Shape.X , Shape.Y )
	End Method
	
	
	
	Method SetMouseCoords()
		Local NewX:Float, NewY:Float
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), NewX, NewY )
		SetCoords( NewX, NewY )
	End Method
	
	
	
	Method Move( DX:Float, DY:Float )
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
	
	
	
	Method PlaceBetweenShapes( Shape1:LTShape, Shape2:LTShape, K:Float )
		SetCoords( Shape1.X + ( Shape2.X - Shape1.X ) * K, Shape1.Y + ( Shape2.Y - Shape1.Y ) * K )
	End Method
	
	
	
	Method LimitWith( Rectangle:LTShape )
		Local X1:Float = Min( Rectangle.X, Rectangle.CornerX() + 0.5 * Width )
		Local Y1:Float = Min( Rectangle.Y, Rectangle.CornerY() + 0.5 * Height )
		Local X2:Float = Max( Rectangle.X, Rectangle.X + 0.5 * ( Rectangle.Width - Width ) )
		Local Y2:Float = Max( Rectangle.Y, Rectangle.Y + 0.5 * ( Rectangle.Height - Height ) )
		X = L_LimitFloat( X, X1, X2 )
		Y = L_LimitFloat( Y, Y1, Y2 )
		Update()
	End Method
	
	' ==================== Angle ====================
	
	Method DirectionToPoint:Float( PointX:Float, PointY:Float )
		Return ATan2( PointY - Y, PointX - X )
	End Method
	
	
	
	Method DirectionToShape:Float( Shape:LTShape )
		Return ATan2( Shape.Y - Y, Shape.X - X )
	End Method
	
	' ==================== Size ====================

	Method SetSize( NewWidth:Float, NewHeight:Float )
		Width = NewWidth
		Height = NewHeight
		Update()
	End Method
	
	
	
	Method SetDiameter( NewDiameter:Float )
		SetSize( NewDiameter, NewDiameter )
	End Method
	
	
	
	Method CorrectHeight()
		Local ImageVisualizer:LTImageVisualizer = LTImageVisualizer( Visualizer )
		
		?debug
		If ImageVisualizer = Null Then L_Error( "Cannot correct Height: visual is not of LTImageVisual type" )
		?
		
		SetSize( Width, Width * ImageHeight( ImageVisualizer.Image.BMaxImage ) / ImageWidth( ImageVisualizer.Image.BMaxImage ) )
	End Method
	
	' ==================== Other ===================
	
	Method Clone:LTShape()
	End Method
	
	
	
	Method CopyShapeTo( Shape:LTShape )
		Shape.Name = Name
		Shape.Visualizer = Visualizer
		Shape.X = X
		Shape.Y = Y
		Shape.Width = Width
		Shape.Height = Height
		Shape.Visible = Visible
		Shape.Active = Active
	End Method
	
	
	
	Method Act()
	End Method
	
	
	
	Method Update()
	End Method
	
	
	
	Method Destroy()
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
		XMLObject.ManageFloatAttribute( "width", Width, 1.0 )
		XMLObject.ManageFloatAttribute( "height", Height, 1.0 )
		XMLObject.ManageIntAttribute( "visible", Visible, 1 )
		XMLObject.ManageIntAttribute( "active", Active, 1 )
		Visualizer = LTVisualizer( XMLObject.ManageObjectField( "visualizer", Visualizer ) )
	End Method
End Type





Type LTMoveShape Extends LTAction
	Field Shape:LTShape
	Field OldX:Float, OldY:Float
	Field NewX:Float, NewY:Float
	
	
	
	Function Create:LTMoveShape( Shape:LTShape, X:Float = 0, Y:Float = 0 )
		Local Action:LTMoveShape = New LTMoveShape
		Action.Shape = Shape
		Action.OldX = Shape.X
		Action.OldY = Shape.Y
		Action.NewX = X
		Action.NewY = Y
		Return Action
	End Function
	
	
	
	Method Do()
		Shape.SetCoords( NewX, NewY )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Shape.SetCoords( OldX, OldY )
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type