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
	Field X:Float
	Field Y:Float
	Field XSize:Float = 1.0
	Field YSize:Float = 1.0
	Field Model:LTModel = L_DefaultModel
	Field Frame:Int
	
	
	
	Method New()
		If L_DefaultModelTypeID Then Model = LTModel( L_DefaultModelTypeID.NewObject() )
	End Method
	
	' ==================== Drawing ===================	
	
	Method Draw()
		Visual.DrawUsingActor( Self )
	End Method
	
	
	
	Method DrawUsingVisual( Vis:LTVisual )
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
						Return L_PivotWithPivot( Self, Actor )
					Case L_Circle
						Return L_PivotWithCircle( Self, Actor )
					Case L_Rectangle
						Return L_PivotWithRectangle( Self, Actor )
				End Select
			Case L_Circle
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithCircle( Actor, Self )
					Case L_Circle
						Return L_CircleWithCircle( Self, Actor )
					Case L_Rectangle
						Return L_CircleWithRectangle( Self, Actor )
				End Select
			Case L_Rectangle
				Select Actor.Shape
					Case L_Pivot
						Return L_PivotWithRectangle( Actor, Self )
					Case L_Circle
						Return L_CircleWithRectangle( Actor, Self )
					Case L_Rectangle
						Return L_RectangleWithRectangle( Self, Actor )
				End Select
		End Select
	End Method
	
	
	
	Method CollidesWithLine:Int( Line:LTLine )
		Select Shape
			Case L_Pivot
				'Return L_PivotWithLine( Self, Line )
			Case L_Circle
				Return L_CircleWithLine( Self, Line )
			Case L_Rectangle
				'Return L_RectangleWithLine( Self, Line )
		End Select
	End Method
	
	' ==================== Pushing ====================
	
	Method Push( Shape:LTShape, SelfMass:Float, ShapeMass:Float )
		Shape.PushActor( Self, ShapeMass, SelfMass )
	End Method


	
	Method PushActor( Actor:LTActor, SelfMass:Float, ActorMass:Float )
		Select Shape
			Case L_Pivot
				Select Actor.Shape
					Case L_Pivot
						'L_PushPivotWithPivot( Self, Actor, SelfMass, ActorMass )
					Case L_Circle
						'L_PushPivotWithCircle( Self, Actor, SelfMass, ActorMass )
					Case L_Rectangle
						'L_PushPivotWithRectangle( Self, Actor, SelfMass, ActorMass )
				End Select
			Case L_Circle
				Select Actor.Shape
					Case L_Pivot
						'L_PushPivotWithCircle( Actor, Self, Mass1, SelfMass )
					Case L_Circle
						L_PushCircleWithCircle( Self, Actor, SelfMass, ActorMass )
					Case L_Rectangle
						L_PushCircleWithRectangle( Self, Actor, SelfMass, ActorMass )
				End Select
			Case L_Rectangle
				Select Actor.Shape
					Case L_Pivot
						'L_PushPivotWithRectangle( Actor, Self, ActorMass, SelfMass )
					Case L_Circle
						L_PushCircleWithRectangle( Actor, Self, ActorMass, SelfMass )
					Case L_Rectangle
						L_PushRectangleWithRectangle( Self, Actor, SelfMass, ActorMass )
				End Select
		End Select
	End Method

	' ==================== Position ====================
	
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
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Method SetCoordsRelativeToActor( Actor:LTActor, NewX:Float, NewY:Float )
		Local Angle:Float = DirectionToPoint( NewX, NewY ) + Actor.GetAngle()
		Local Radius:Float = Sqr( NewX * NewX + NewY * NewY )
		X = Actor.X + Radius * Cos( Angle )
		Y = Actor.Y + Radius * Sin( Angle )
		Update()
	End Method
	
	
	
	Method JumpToActor( Actor:LTActor )
		X = Actor.X
		Y = Actor.Y
		Update()
	End Method
	
	
	
	Method SetMouseCoords()
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), X, Y )
		Update()
	End Method
	
	
	
	Method MoveTowardsActor( Actor:LTActor )
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
	End Method
	
	
	
	Method MoveForward()
		X :+ Model.GetDX() * L_DeltaTime
		Y :+ Model.GetDY() * L_DeltaTime
	End Method
	
	
	
	Method MoveUsingWSAD()
		Local DX:Float = KeyDown( Key_D ) - KeyDown( Key_A )
		Local DY:Float = KeyDown( Key_S ) - KeyDown( Key_W )
		If DX * DY Then
			DX :/ Sqr(2)
			DY :/ Sqr(2)
		End If
		X :+ DX * Model.GetVelocity() * L_DeltaTime
		Y :+ DY * Model.GetVelocity() * L_DeltaTime
		Update()
	End Method
	
	
	
	Method PlaceBetweenActors( Actor1:LTActor, Actor2:LTActor, K:Float )
		X = Actor1.X + ( Actor2.X - Actor1.X ) * K
		Y = Actor1.Y + ( Actor2.Y - Actor1.Y ) * K
	End Method
	
	' ==================== Size ====================

	Method SetSize( NewXSize:Float, NewYSize:Float )
		XSize = NewXSize
		YSize = NewYSize
	End Method
	
	
	
	Method SetDiameter( NewDiameter:Float )
		XSize = NewDiameter
		YSize = NewDiameter
	End Method
	
	
	
	Method CorrectYSize()
		Local ImageVisual:LTImageVisual = LTImageVisual( Visual )
		
		?debug
		L_Assert( ImageVisual <> Null, "Cannot correct YSize: visual is not of LTImageVisual type" )
		?
		
		YSize = XSize * ImageHeight( ImageVisual.Image.BMaxImage ) / ImageWidth( ImageVisual.Image.BMaxImage )
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
		XMLObject.ManageFloatAttribute( "x", X )
		XMLObject.ManageFloatAttribute( "y", Y )
		XMLObject.ManageFloatAttribute( "xsize", XSize, 1.0 )
		XMLObject.ManageFloatAttribute( "ysize", YSize, 1.0 )
		Model = LTModel( XMLObject.ManageObjectField( "model", Model ) )
	End Method
End Type