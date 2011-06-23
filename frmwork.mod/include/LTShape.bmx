'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTShape Extends LTObject
	Field X:Double
	Field Y:Double
	Field Width:Double = 1.0
	Field Height:Double = 1.0
	Field Visualizer:LTVisualizer = L_DefaultVisualizer
	Field Visible:Int = True
	Field Active:Int = True
	Field BehaviorModels:TList = New TList
	
	Const Horizontal:Int = 0
	Const Vertical:Int = 1
	
	' ==================== Drawing ===================
	
	Method Draw()
	End Method
	
	
	
	Method DrawUsingVisualizer( Vis:LTVisualizer )
	End Method
	
	' ==================== Collisions ===================
	
	Method SpriteGroupCollisions( Sprite:LTSprite, CollisionType:Int )
	End Method
	
	
	
	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
	End Method
	
	' ==================== Position ====================
	
	Method LeftX:Double()
 		Return X - 0.5 * Width
 	End Method
	
	
	
	Method TopY:Double()
 		Return Y - 0.5 * Height
 	End Method
	
	
	
	Method RightX:Double()
 		Return X + 0.5 * Width
 	End Method
	
	
	
	Method BottomY:Double()
 		Return Y + 0.5 * Height
 	End Method

	
	
	Method DistanceToPoint:Double( PointX:Double, PointY:Double )
		Local DX:Double = X - PointX
		Local DY:Double = Y - PointY
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method DistanceTo:Double( Shape:LTShape )
		Local DX:Double = X - Shape.X
		Local DY:Double = Y - Shape.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Method IsAtPositionOf:Int( Shape:LTShape )
		If Shape.X = X And Shape.Y = Y Then Return True
	End Method
	
	
	
	Method SetX( NewX:Double )
		SetCoords( NewX, Y )
	End Method
	
	
	
	Method SetY( NewY:Double )
		SetCoords( X, NewY )
	End Method
	
	
	Method SetCoords( NewX:Double, NewY:Double )
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Method AlterCoords( DX:Double, DY:Double )
		SetCoords( X + DX, Y + DY )
	End Method
	
	
	
	Method SetCornerCoords( NewX:Double, NewY:Double )
		SetCoords( NewX + Width * 0.5, NewY + Height * 0.5 )
	End Method
	
	
	
	Method JumpTo( Shape:LTShape )
		SetCoords( Shape.X , Shape.Y )
	End Method
	
	
	
	Method SetMouseCoords()
		Local NewX:Double, NewY:Double
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), NewX, NewY )
		SetCoords( NewX, NewY )
	End Method
	
	
	
	Method Move( DX:Double, DY:Double )
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
	
	
	
	Method PlaceBetween( Shape1:LTShape, Shape2:LTShape, K:Double )
		SetCoords( Shape1.X + ( Shape2.X - Shape1.X ) * K, Shape1.Y + ( Shape2.Y - Shape1.Y ) * K )
	End Method
	
	' ==================== Limiting ====================
	
	Method LimitWith( Rectangle:LTShape )
		LimitHorizontallyWith( Rectangle, False )
		LimitVerticallyWith( Rectangle, False )
		Update()
	End Method
	
	
	
	Method LimitLeftWith( Rectangle:LTShape, UpdateFlag:Int = True )
		If LeftX() < Rectangle.LeftX() Then
			X = Rectangle.LeftX() + 0.5 * Width
			If UpdateFlag Then Update()
		End If
	End Method
	
	
	
	Method LimitTopWith( Rectangle:LTShape, UpdateFlag:Int = True )
		If TopY() < Rectangle.TopY() Then
			Y = Rectangle.TopY() + 0.5 * Width
			If UpdateFlag Then Update()
		End If
	End Method
	
	
	
	Method LimitRightWith( Rectangle:LTShape, UpdateFlag:Int = True )
		If RightX() > Rectangle.RightX() Then
			X = Rectangle.RightX() - 0.5 * Width
			If UpdateFlag Then Update()
		End If
	End Method
	
	
	
	Method LimitBottomWith( Rectangle:LTShape, UpdateFlag:Int = True )
		If BottomY() > Rectangle.BottomY() Then
			Y = Rectangle.BottomY() - 0.5 * Width
			If UpdateFlag Then Update()
		End If
	End Method
	
	
	
	Method LimitHorizontallyWith( Rectangle:LTShape, UpdateFlag:Int = True )
		Local X1:Double = Min( Rectangle.X, Rectangle.LeftX() + 0.5 * Width )
		Local X2:Double = Max( Rectangle.X, Rectangle.RightX() - 0.5 * Width )
		X = L_LimitDouble( X, X1, X2 )
	End Method
	
	
	
	Method LimitVerticallyWith( Rectangle:LTShape, UpdateFlag:Int = True )
		Local Y1:Double = Min( Rectangle.Y, Rectangle.TopY() + 0.5 * Height )
		Local Y2:Double = Max( Rectangle.Y, Rectangle.BottomY() - 0.5 * Height )
		Y = L_LimitDouble( Y, Y1, Y2 )
	End Method
	
	' ==================== Angle ====================
	
	Method DirectionToPoint:Double( PointX:Double, PointY:Double )
		Return ATan2( PointY - Y, PointX - X )
	End Method
	
	
	
	Method DirectionTo:Double( Shape:LTShape )
		Return ATan2( Shape.Y - Y, Shape.X - X )
	End Method
	
	' ==================== Size ====================

	Method SetWidth( NewWidth:Double )	
		SetSize( NewWidth, Height )
	End Method
	
	
	
	Method SetHeight( NewHeight:Double )	
		SetSize( Width, NewHeight )
	End Method
	
	
	
	Method SetSize( NewWidth:Double, NewHeight:Double )
		Width = NewWidth
		Height = NewHeight
		Update()
	End Method
	
	
	
	Method GetDiameter:Double()
		Return Width
	End Method
	
	
	
	Method SetDiameter( NewDiameter:Double )
		SetSize( NewDiameter, NewDiameter )
	End Method
	
	
	
	Method CorrectHeight()
		Local Image:LTImage = Visualizer.GetImage()
		
		?debug
		If Not Image Then L_Error( "Cannot correct Height: visual is not of LTImageVisual type" )
		?
		
		SetSize( Width, Width * ImageHeight( Image.BMaxImage ) / ImageWidth( Image.BMaxImage ) )
	End Method
	
	
	
	Method GetFacing:Double()
		Return Sgn( Visualizer.XScale )
	End Method
	
	
	
	Const LeftFacing:Double = -1.0
	Const RightFacing:Double = 1.0
	
	Method SetFacing( NewFacing:Double )
		Visualizer.XScale = Abs( Visualizer.XScale ) * NewFacing
	End Method
	
	' ==================== Behavior models ===================
	
	Method AttachModel( Model:LTBehaviorModel, Activated:Int = True )
		Model.Init( Self )
		Model.Link = BehaviorModels.AddLast( Model )
		If Activated Then
			Model.Activate( Self )
			Model.Active = True
		End If
	End Method
	
	
	
	Method FindModel:LTBehaviorModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If TTypeID.ForObject( Model ) = TypeID Then Return Model
		Next
	End Method
	
	
	
	Method ActivateAllModels()
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If Not Model.Active Then
				Model.Activate( Self )
				Model.Active = True
			End If
		Next
	End Method
	
	
	
	Method DeactivateAllModels()
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If Model.Active Then
				Model.Deactivate( Self )
				Model.Active = False
			End If
		Next
	End Method
	
	
	
	Method ActivateModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If TTypeID.ForObject( Model ) = TypeID And Not Model.Active Then
				Model.Activate( Self )
				Model.Active = True
			End If
		Next
	End Method
	
	
	
	Method DeactivateModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If TTypeID.ForObject( Model ) = TypeID And Model.Active Then
				Model.Deactivate( Self )
				Model.Active = False
			End If
		Next
	End Method
	
	
	
	Method ToggleModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If TTypeID.ForObject( Model ) = TypeID Then
				If Model.Active Then
					Model.Deactivate( Self )
					Model.Active = False
				Else
					Model.Activate( Self )
					Model.Active = True
				End If
			End If
		Next
	End Method
	
	
	
	Method RemoveModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = Eachin BehaviorModels
			If TTypeID.ForObject( Model ) = TypeID Then
				Model.Remove( Self )
			End If
		Next
	End Method
	
	' ==================== Windowed Visualizer ====================
	
	Method LimitByWindow( X:Double, Y:Double, Width:Double, Height:Double )
		Local NewVisualizer:LTWindowedVisualizer = New LTWindowedVisualizer
		NewVisualizer.Viewport = New LTShape
		NewVisualizer.Viewport.X = X
		NewVisualizer.Viewport.Y = Y
		NewVisualizer.Viewport.Width = Width
		NewVisualizer.Viewport.Height = Height
		NewVisualizer.Visualizer = Visualizer
		Visualizer = NewVisualizer
	End Method
	
	
	
	Method LimitByWindowShape( Shape:LTShape )
		LimitByWindow( Shape.X, Shape.Y, Shape.Width, Shape.Height )
	End Method
	
	
	
	Method RemoveWindowLimit()
		Visualizer = LTWindowedVisualizer( Visualizer ).Visualizer
	End Method
	
	' ==================== Other ===================
	
	Method Init()
	End Method
	
	
	
	Method CopyTo( Shape:LTShape )
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
		If Active Then
			For Local Model:LTBehaviorModel = Eachin BehaviorModels
				If Model.Active Then
					Model.ApplyTo( Self )
				Else
					Model.Watch( Self )
				End If
			Next
		End If
	End Method
	

	
	Method Update()
	End Method
	
	
	
	Method Destroy()
	End Method
	
	' ==================== Saving / loading ====================
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		
		XMLObject.ManageDoubleAttribute( "x", X )
		XMLObject.ManageDoubleAttribute( "y", Y )
		XMLObject.ManageDoubleAttribute( "width", Width, 1.0 )
		XMLObject.ManageDoubleAttribute( "height", Height, 1.0 )
		XMLObject.ManageIntAttribute( "visible", Visible, 1 )
		XMLObject.ManageIntAttribute( "active", Active, 1 )
		Visualizer = LTVisualizer( XMLObject.ManageObjectField( "visualizer", Visualizer ) )
	End Method
End Type





Type LTMoveShape Extends LTAction
	Field Shape:LTShape
	Field OldX:Double, OldY:Double
	Field NewX:Double, NewY:Double
	
	
	
	Function Create:LTMoveShape( Shape:LTShape, X:Double = 0, Y:Double = 0 )
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