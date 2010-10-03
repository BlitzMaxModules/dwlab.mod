'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTTileMap.bmx"
Include "Collisions.bmx"

Const L_Pivot:Int = 0
Const L_Circle:Int = 1
Const L_Rectangle:Int = 2

Type LTActor Extends LTShape
	Field Shape:Int = L_Rectangle
	Field X:Float
	Field Y:Float
	Field XSize:Float = 1.0
	Field YSize:Float = 1.0
	Field Model:LTModel = L_DefaultModel
	Field Frame:Int
	Field CollisionMap:LTCollisionMap
	
	
	
	Method New()
		If L_DefaultModelTypeID Then Model = LTModel( L_DefaultModelTypeID.NewObject() )
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visualizer.DrawUsingActor( Self )
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
		Vis.DrawUsingActor( Self )
	End Method
	
	' ==================== Collisions ===================
	
	Method CollidesWith:Int( Shape:LTShape )
		Return Shape.CollidesWithActor( Self )
	End Method
	
	
	
	Method CollidesWithActor:Int( Actor:LTActor )
		Select Shape
			Case L_Pivot
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithPivot( X, Y, Actor.X, Actor.Y )
					Case L_Circle
						Return L_PivotWithCircle( X, Y, Actor.X, Actor.Y, Actor.XSize )
					Case L_Rectangle
						Return L_PivotWithRectangle( X, Y, Actor.X, Actor.Y, Actor.XSize, Actor.YSize )
				End Select
			Case L_Circle
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithCircle( Actor.X, Actor.Y, X, Y, XSize )
					Case L_Circle
						Return L_CircleWithCircle( X, Y, XSize, Actor.X, Actor.Y, Actor.XSize )
					Case L_Rectangle
						Return L_CircleWithRectangle( X, Y, XSize, Actor.X, Actor.Y, Actor.XSize, Actor.YSize )
				End Select
			Case L_Rectangle
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithRectangle( Actor.X, Actor.Y, X, Y, XSize, YSize )
					Case L_Circle
						Return L_CircleWithRectangle( Actor.X, Actor.Y, Actor.XSize, X, Y, XSize, YSize )
					Case L_Rectangle
						Return L_RectangleWithRectangle( X, Y, XSize, YSize, Actor.X, Actor.Y, Actor.XSize, Actor.YSize )
				End Select
		End Select
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
		Select Shape
			Case L_Pivot
				'Return L_PivotWithLine( Self, Line )
			Case L_Circle
				Return L_CircleWithLine( X, Y, XSize, Line.Pivot[ 0 ].X, Line.Pivot[ 0 ].Y, Line.Pivot[ 1 ].X, Line.Pivot[ 1 ].Y )
			Case L_Rectangle
				'Return L_RectangleWithLine( Self, Line )
		End Select
	End Method
	
	
	
	Method CollidesWithTile:Int( Actor:LTActor, DX:Float, DY:Float, XScale:Float, YScale:Float )
		Select Shape
			Case L_Pivot
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithPivot( X, Y, Actor.X * XScale + DX, Actor.Y * YScale + DY )
					Case L_Circle
						Return L_PivotWithCircle( X, Y, Actor.X * XScale + DX, Actor.Y * YScale + DY, Actor.XSize * XScale )
					Case L_Rectangle
						Return L_PivotWithRectangle( X, Y, Actor.X * XScale + DX, Actor.Y * YScale + DY, Actor.XSize * XScale, Actor.YSize * YScale )
				End Select
			Case L_Circle
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithCircle( Actor.X * XScale + DX, Actor.Y * YScale + DY, X, Y, XSize )
					Case L_Circle
						Return L_CircleWithCircle( X, Y, XSize, Actor.X * XScale + DX, Actor.Y * YScale + DY, Actor.XSize * XScale )
					Case L_Rectangle
						Return L_CircleWithRectangle( X, Y, XSize, Actor.X * XScale + DX, Actor.Y * YScale + DY, Actor.XSize * XScale, Actor.YSize * YScale )
				End Select
			Case L_Rectangle
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithRectangle( Actor.X * XScale + DX, Actor.Y * YScale + DY, X, Y, XSize, YSize )
					Case L_Circle
						Return L_CircleWithRectangle( Actor.X * XScale + DX, Actor.Y * YScale + DY, Actor.XSize * XScale, X, Y, XSize, YSize )
					Case L_Rectangle
						Return L_RectangleWithRectangle( X, Y, XSize, YSize, Actor.X * XScale + DX, Actor.Y * YScale + DY, Actor.XSize * XScale, Actor.YSize * YScale )
				End Select
		End Select
	End Method
	
	' ==================== Wedging off ====================
	
	Method WedgeOffWith( Shape:LTShape, SelfMass:Float, ShapeMass:Float )
		Shape.WedgeOffWithActor( Self, ShapeMass, SelfMass )
	End Method


	
	Method WedgeOffWithActor( Actor:LTActor, SelfMass:Float, ActorMass:Float )
		Local DX:Float, DY:Float
		Select Shape
			Case L_Pivot
				Select Actor.Shape
					Case L_Pivot
					Case L_Circle
					Case L_Rectangle
				End Select
			Case L_Circle
				Select Actor.Shape
					Case L_Pivot
					Case L_Circle
						L_WedgingValuesOfCircleAndCircle( X, Y, XSize, Actor.X, Actor.Y, Actor.XSize, DX, DY )
						L_Separate( Self, Actor, DX, DY, SelfMass, ActorMass )
					Case L_Rectangle
						L_WedgingValuesOfCircleAndRectangle( X, Y, XSize, Actor.X, Actor.Y, Actor.XSize, Actor.YSize, DX, DY )
						L_Separate( Self, Actor, DX, DY, SelfMass, ActorMass )
				End Select
			Case L_Rectangle
				Select Actor.Shape
					Case L_Pivot
					Case L_Circle
						L_WedgingValuesOfCircleAndRectangle( Actor.X, Actor.Y, Actor.XSize, X, Y, XSize, YSize, DX, DY )
						L_Separate( Actor, Self, DX, DY, ActorMass, SelfMass )
					Case L_Rectangle
						L_WedgingValuesOfRectangleAndRectangle( X, Y, XSize, YSize, Actor.X, Actor.Y, Actor.XSize, Actor.YSize, DX, DY )
						L_Separate( Self, Actor, DX, DY, SelfMass, ActorMass )
				End Select
		End Select
	End Method
	
	
	
	Method PushFromActor( Actor:LTActor )
		WedgeOffWithActor( Actor, 0.0, 1.0 )
	End Method
	
	
	
	Method PushFromTile( TileMap:LTTileMap, TileX:Int, TileY:Int )
		Local TileActor:LTActor = TileMap.GetTileTemplate( TileX, TileY )
		
		?debug
		L_Assert( TileActor <> Null, "Tile has no colliding shapes" )
		?
		
		Local CellXSize:Float = TileMap.GetCellXSize()
		Local CellYSize:Float = TileMap.GetCellYSize()
		PushFromTileActor( TileActor, TileMap.CornerX() + CellXSize * TileX, TileMap.CornerY() + CellYSize * TileY, CellXSize, CellYSize )
	End Method


	
	Method PushFromTileActor( TileActor:LTActor, DX:Float, DY:Float, XScale:Float, YScale:Float )
		Local PushingDX:Float, PushingDY:Float
		Select Shape
			Case L_Pivot
				Select TileActor.Shape
					Case L_Pivot
					Case L_Circle
					Case L_Rectangle
				End Select
			Case L_Circle
				Select TileActor.Shape
					Case L_Pivot
					Case L_Circle
						L_WedgingValuesOfCircleAndCircle( X, Y, XSize, TileActor.X * XScale + DX, TileActor.Y * YScale + DY, TileActor.XSize * XScale, PushingDX, PushingDY )
						L_Separate( Self, TileActor, PushingDX, PushingDY, 0.0, 1.0 )
					Case L_Rectangle
						L_WedgingValuesOfCircleAndRectangle( X, Y, XSize, TileActor.X * XScale + DX, TileActor.Y * YScale + DY, TileActor.XSize * XScale, TileActor.YSize * YScale, PushingDX, PushingDY )
						L_Separate( Self, TileActor, PushingDX, PushingDY, 0.0, 1.0 )
				End Select
			Case L_Rectangle
				Select TileActor.Shape
					Case L_Pivot
					Case L_Circle
						L_WedgingValuesOfCircleAndRectangle( TileActor.X * XScale + DX, TileActor.Y * YScale + DY, TileActor.XSize * XScale, X, Y, XSize, YSize, PushingDX, PushingDY )
						L_Separate( TileActor, Self, PushingDX, PushingDY, 1.0, 0.0 )
					Case L_Rectangle
						L_WedgingValuesOfRectangleAndRectangle( X, Y, XSize, YSize, TileActor.X * XScale + DX, TileActor.Y * YScale + DY, TileActor.XSize * XScale, TileActor.YSize * YScale, PushingDX, PushingDY )
						L_Separate( Self, TileActor, PushingDX, PushingDY, 0.0, 1.0 )
				End Select
		End Select
	End Method


	' ==================== Position ====================
	
	Method CornerX:Float()
 		Return X - 0.5 * XSize
 	End Method
	
	
	
	Method CornerY:Float()
 		Return Y - 0.5 * YSize
 	End Method

	
	
	Method DistanceToPoint:Float( PointX:Float, PointY:Float )
		Local DX:Float = X - PointX
		Local DY:Float = Y - PointY
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method DistanceToActor:Float( Actor:LTActor )
		Local DX:Float = X - Actor.X
		Local DY:Float = Y - Actor.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method IsAtPositionOfActor:Int( Actor:LTActor )
		If Actor.X = X And Actor.Y = Y Then Return True
	End Method
	
	
	
	Method SetCoords( NewX:Float, NewY:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		X = NewX
		Y = NewY
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method AlterCoords( DX:Float, DY:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		X :+ DX
		Y :+ DY
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method SetCornerCoords( NewX:Float, NewY:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		X = NewX + XSize * 0.5
		Y = NewY + YSize * 0.5
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method SetCoordsRelativeToActor( Actor:LTActor, NewX:Float, NewY:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		Local Angle:Float = DirectionToPoint( NewX, NewY ) + Actor.GetAngle()
		Local Radius:Float = Sqr( NewX * NewX + NewY * NewY )
		X = Actor.X + Radius * Cos( Angle )
		Y = Actor.Y + Radius * Sin( Angle )
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method JumpToActor( Actor:LTActor )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		X = Actor.X
		Y = Actor.Y
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method SetMouseCoords()
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method MoveTowardsActor( Actor:LTActor )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		Local Angle:Float = DirectionToActor( Actor )
		Local DX:Float = Cos( Angle ) * GetVelocity() * L_DeltaTime
		Local DY:Float = Sin( Angle ) * GetVelocity() * L_DeltaTime
		If Abs( DX ) >= Abs( X - Actor.X ) And Abs( DY ) >= Abs( Y - Actor.Y ) Then
			X = Actor.X
			Y = Actor.Y
		Else
			X :+ DX
			Y :+ DY
		End If
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method MoveForward()
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		X :+ Model.GetDX() * L_DeltaTime
		Y :+ Model.GetDY() * L_DeltaTime
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method MoveUsingWSAD()
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		Local DX:Float = KeyDown( Key_D ) - KeyDown( Key_A )
		Local DY:Float = KeyDown( Key_S ) - KeyDown( Key_W )
		If DX * DY Then
			DX :/ Sqr( 2 )
			DY :/ Sqr( 2 )
		End If
		X :+ DX * Model.GetVelocity() * L_DeltaTime
		Y :+ DY * Model.GetVelocity() * L_DeltaTime
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method PlaceBetweenActors( Actor1:LTActor, Actor2:LTActor, K:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		X = Actor1.X + ( Actor2.X - Actor1.X ) * K
		Y = Actor1.Y + ( Actor2.Y - Actor1.Y ) * K
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	' ==================== Size ====================

	Method SetSize( NewXSize:Float, NewYSize:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		XSize = NewXSize
		YSize = NewYSize

		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method SetDiameter( NewDiameter:Float )
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		XSize = NewDiameter
		YSize = NewDiameter
		
		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	
	
	Method CorrectYSize()
		Local ImageVisualizer:LTImageVisualizer = LTImageVisualizer( Visualizer )
		
		?debug
		L_Assert( ImageVisualizer <> Null, "Cannot correct YSize: visual is not of LTImageVisual type" )
		?
		
		If CollisionMap Then CollisionMap.RemoveActor( Self )
		
		YSize = XSize * ImageHeight( ImageVisualizer.Image.BMaxImage ) / ImageWidth( ImageVisualizer.Image.BMaxImage )

		Update()
		If CollisionMap Then CollisionMap.InsertActor( Self )
	End Method
	
	' ==================== Angle ====================
	
	Method GetAngle:Float()
		Return Model.GetAngle()
	End Method
	
	
	
	Method SetAngle:Float( NewAngle:Float )
		Model.SetAngle( NewAngle )
	End Method
	
	
	
	Method DirectAsActor( Actor:LTActor )
		Model.SetAngle( Actor.Model.GetAngle() )
	End Method
	
	
	
	Method Turn( TurningSpeed:Float )
		Model.AlterAngle( L_DeltaTime * TurningSpeed )
	End Method
	
	
	
	Method DirectionToPoint:Float( PointX:Float, PointY:Float )
		Return ATan2( PointY - Y, PointX - X )
	End Method
	
	
	
	Method DirectionToActor:Float( Actor:LTActor )
		Return ATan2( Actor.Y - Y, Actor.X - X )
	End Method
	
	
	
	Method DirectToActor( Actor:LTActor )
		Model.SetAngle( ATan2( Actor.Y - Y, Actor.X - X ) )
	End Method
	
	' ==================== Moving vector ====================
	
	Method GetDX:Float()
		Return Model.GetDX()
	End Method
	
	
	
	Method AlterDX( DDX:Float )
		Model.AlterDX( DDX )
	End Method
	
	
	
	Method SetDX( NewDX:Float )
		Model.SetDX( NewDX )
	End Method
	
	
	
	Method GetDY:Float()
		Return Model.GetDY()
	End Method
	
	
	
	Method AlterDY( DDY:Float )
		Model.AlterDY( DDY )
	End Method
	
	
	
	Method SetDY( NewDY:Float )
		Model.SetDY( NewDY )
	End Method
	
	
	
	Method AlterDXDY( DDX:Float, DDY:Float )
		Model.SetDXDY( DDX, DDY )
	End Method
	
	
	
	Method SetDXDY( NewDX:Float, NewDY:Float )
		Model.SetDXDY( NewDX, NewDY )
	End Method
	
	' ==================== Velocity ====================
	
	Method GetVelocity:Float()
		Return Model.GetVelocity()
	End Method
	
	
	
	Method SetVelocity:Float( NewVelocity:Float )
		Model.SetVelocity( NewVelocity )
	End Method
	
	
	
	Method GetAngularVelocity:Float()
		Return Model.GetAngularVelocity()
	End Method
	
	
	
	Method SetAngularVelocity:Float( NewAngularVelocity:Float )
		Model.SetAngularVelocity( NewAngularVelocity )
	End Method
	
	' ==================== Mass ====================
	
	Method GetMass:Float()
		Return Model.GetMass()
	End Method
	
	
	
	Method SetMass:Float( NewMass:Float )
		Model.SetMass( NewMass )
	End Method
	
	' ==================== Other ====================
	
	Method CloneActor:LTActor( DX:Float, DY:Float, XK:Float, YK:Float )
		Local Actor:LTActor = New LTActor
		Actor.X = DX + X * XK
		Actor.Y = DY + Y * YK
		Actor.XSize = XSize * XK
		Actor.YSize = YSize * YK
		Return Actor
	End Method

	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageIntAttribute( "shape", Shape )
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
		XMLObject.ManageFloatAttribute( "xsize", XSize, 1.0 )
		XMLObject.ManageFloatAttribute( "ysize", YSize, 1.0 )
		Model = LTModel( XMLObject.ManageObjectField( "model", Model ) )
		XMLObject.ManageIntAttribute( "frame", Frame )
	End Method
End Type





Type LTMoveActor Extends LTAction
	Field Actor:LTActor
	Field OldX:Float, OldY:Float
	Field NewX:Float, NewY:Float
	
	
	
	Function Create:LTMoveActor( Actor:LTActor, X:Float = 0, Y:Float = 0 )
		Local Action:LTMoveActor = New LTMoveActor
		Action.Actor = Actor
		Action.OldX = Actor.X
		Action.OldY = Actor.Y
		Action.NewX = X
		Action.NewY = Y
		Return Action
	End Function
	
	
	
	Method Do()
		Actor.SetCoords( NewX, NewY )
		L_CurrentUndoList.AddFirst( Self )
	End Method
	
	
	
	Method Undo()
		Actor.SetCoords( OldX, OldY )
		L_CurrentRedoList.AddFirst( Self )
	End Method
End Type