'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Common object for item of game field.
End Rem
Type LTShape Extends LTObject
	Rem
	bbdoc: X coordinate of the shape center in units.
	End Rem
	Field X:Double
	
	Rem
	bbdoc: Y coordinate of the shape center in units.
	End Rem
	Field Y:Double
	
	Rem
	bbdoc: Shape width in units.
	End Rem
	Field Width:Double = 1.0
	
	Rem
	bbdoc: Shape height in units.
	End Rem
	Field Height:Double = 1.0
	
	Rem
	bbdoc: Shape visualizer (object which displays this shape).
	End Rem
	Field Visualizer:LTVisualizer = L_DefaultVisualizer
	
	Rem
	bbdoc: Visibility flag.
	about: If False then shape will not be drawn.
	End Rem
	Field Visible:Int = True
	
	Rem
	bbdoc: Activity flag.
	about: If False then Act() method for shape will not be executed.
	End Rem
	Field Active:Int = True
	
	Rem
	bbdoc: Behavior models list.
	about: Standard Act() method will apply every behavior model in this list to the shape.
	End Rem
	Field BehaviorModels:TList = New TList
	
	Rem
	bbdoc: Constant for horizontal collision type.
	about: See tutorial for additional info.
	End Rem
	Const Horizontal:Int = 1
	
	Rem
	bbdoc: Constant for vertical collision type.
	about: See tutorial for additional info.
	End Rem
	Const Vertical:Int = 2
	
	' ==================== Drawing ===================
	
	Rem
	bbdoc: Draws the shape.
	about: You can fill it with drawing commands for shape and its parts.
	End Rem
	Method Draw()
	End Method
	
	
	
	Rem
	bbdoc: Draws the shape using another visualizer.
	about: You can fill it with drawing commands for shape and its parts using another visualizer.
	End Rem
	Method DrawUsingVisualizer( Vis:LTVisualizer )
	End Method
	
	' ==================== Collisions ===================
	
	Method SpriteGroupCollisions( Sprite:LTSprite, CollisionType:Int )
	End Method
	
	
	
	Method TileShapeCollisionsWithSprite( Sprite:LTSprite, DX:Double, DY:Double, XScale:Double, YScale:Double, TileMap:LTTileMap, TileX:Int, TileY:Int, CollisionType:Int )
	End Method
	
	' ==================== Position ====================
	
	Rem
	bbdoc: Left side of the shape.
	returns: X coordinate of left shape side in units.
	End Rem
	Method LeftX:Double()
 		Return X - 0.5 * Width
 	End Method
	
	
	
	Rem
	bbdoc: Top of the shape.
	returns: Y coordinate of shape top in units.
	End Rem
	Method TopY:Double()
 		Return Y - 0.5 * Height
 	End Method
	
	
	
	Rem
	bbdoc: Right side of the shape.
	returns: X coordinate of right shape side in units.
	End Rem
	Method RightX:Double()
 		Return X + 0.5 * Width
 	End Method
	
	
	
	Rem
	bbdoc: Bottom of the shape
	returns: Y coordinate of shape bottom in units.
	End Rem
	Method BottomY:Double()
 		Return Y + 0.5 * Height
 	End Method

	
	
	Rem
	bbdoc: Distance to point.
	returns: Distance from the shape center to the point with given coordinates.
	End Rem
	Method DistanceToPoint:Double( PointX:Double, PointY:Double )
		Local DX:Double = X - PointX
		Local DY:Double = Y - PointY
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc: Distance to shape.
	returns: Distance from the shape center to center of another shape.
	End Rem
	Method DistanceTo:Double( Shape:LTShape )
		Local DX:Double = X - Shape.X
		Local DY:Double = Y - Shape.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc: Checks if the shape is at position of another shape.
	returns: True if shape center has same coordinates as another shape center. 
	End Rem
	Method IsAtPositionOf:Int( Shape:LTShape )
		If Shape.X = X And Shape.Y = Y Then Return True
	End Method
	
	
	
	Rem
	bbdoc: Sets X coordinate of the shape.
	about: It's better to use this method instead of equating X field to new value.
	End Rem
	Method SetX( NewX:Double )
		SetCoords( NewX, Y )
	End Method
	
	
	
	Rem
	bbdoc: Sets X coordinate of the shape.
	about: It's better to use this method instead of equating X field to new value.
	End Rem
	Method SetY( NewY:Double )
		SetCoords( X, NewY )
	End Method
	
	
	Rem
	bbdoc: Sets coordinates of the shape.
	about: It's better to use this method instead of equating X and Y fields to new values.
	End Rem
	Method SetCoords( NewX:Double, NewY:Double )
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Alter coordinates of the shape.
	about: Given values will be added to the coordinates. It's better to use this method instead of incrementing X and Y fields manually.
	End Rem
	Method AlterCoords( DX:Double, DY:Double )
		SetCoords( X + DX, Y + DY )
	End Method
	
	
	
	Rem
	bbdoc: Sets top-left corner coordinates of the shape.
	about: After this operation top-left corner of the shape will be at given coordinates.
	End Rem
	Method SetCornerCoords( NewX:Double, NewY:Double )
		SetCoords( NewX + Width * 0.5, NewY + Height * 0.5 )
	End Method
	
	
	
	Rem
	bbdoc: Moves shape to another one.
	about: Center coordinates of the shape will be equated to corresponding center coordinates of given shape.
	End Rem
	Method JumpTo( Shape:LTShape )
		SetCoords( Shape.X , Shape.Y )
	End Method
	
	
	
	Rem
	bbdoc: Moves shape to mouse position.
	about: Mouse coordinates will be transformed to field coordinates using current camera. Then shape coordinates will be equated to these.
	End Rem
	Method SetMouseCoords()
		Local NewX:Double, NewY:Double
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), NewX, NewY )
		SetCoords( NewX, NewY )
	End Method
	
	
	
	Rem
	bbdoc: Moves the shape.
	about: The shape will be moved with given horizontal and vertical speed per second.
	End Rem
	Method Move( DX:Double, DY:Double )
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
	
	
	
	Rem
	bbdoc: Places the shape between two another.
	about: K parameter is in 0...1 interval.
	[
	* 0 shifts shape to the center of first given shape.
	* 1 shifts shape to the center of the second given shape.
	* 0.5 shifts shape to the middle between given shapes centers.
	]
	End Rem
	Method PlaceBetween( Shape1:LTShape, Shape2:LTShape, K:Double )
		SetCoords( Shape1.X + ( Shape2.X - Shape1.X ) * K, Shape1.Y + ( Shape2.Y - Shape1.Y ) * K )
	End Method
	
	' ==================== Limiting ====================
	
	Rem
	bbdoc: Limits shape with given rectangular shape.
	about: If the shape is outside given shape, it will be moved inside it. If the shape is larger than given shape, it will be moved to the center of given shape.
	End Rem
	Method LimitWith( Rectangle:LTShape )
		LimitHorizontallyWith( Rectangle )
		LimitVerticallyWith( Rectangle )
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Limits left side of the shape with left side of given rectangular shape.
	about: If the left side X coordinate of shape is less than left side X coordinate of given shape, left side of the shape will be equated to left side of given shape.
	End Rem
	Method LimitLeftWith( Rectangle:LTShape )
		If LeftX() < Rectangle.LeftX() Then SetX( Rectangle.LeftX() + 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Limits top of the shape with top of given rectangular shape.
	about: If the top Y coordinate of shape is less than top Y coordinate of given shape, top of the shape will be equated to the top of given shape.
	End Rem
	Method LimitTopWith( Rectangle:LTShape )
		If TopY() < Rectangle.TopY() Then SetY( Rectangle.TopY() + 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Limits right side of the shape with right side of given rectangular shape.
	about: If the right side X coordinate of shape is more than right side X coordinate of given shape, right side of the shape will be equated to right side of given shape.
	End Rem
	Method LimitRightWith( Rectangle:LTShape )
		If RightX() > Rectangle.RightX() Then SetX( Rectangle.RightX() - 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Limits bottom of the shape with bottom of given rectangular shape.
	about: If the bottom Y coordinate of shape is more than bottom Y coordinate of given shape, bottom of the shape will be equated to the bottom of given shape.
	End Rem
	Method LimitBottomWith( Rectangle:LTShape )
		If BottomY() > Rectangle.BottomY() Then SetY( Rectangle.BottomY() - 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Keeps shape within limits of given shape horizontally.
	about: 
	End Rem
	Method LimitHorizontallyWith( Rectangle:LTShape )
		Local X1:Double = Min( Rectangle.X, Rectangle.LeftX() + 0.5 * Width )
		Local X2:Double = Max( Rectangle.X, Rectangle.RightX() - 0.5 * Width )
		SetX( L_LimitDouble( X, X1, X2 ) )
	End Method
	
	
	
	Rem
	bbdoc: Keeps shape within limits of given shape vertically.
	End Rem
	Method LimitVerticallyWith( Rectangle:LTShape )
		Local Y1:Double = Min( Rectangle.Y, Rectangle.TopY() + 0.5 * Height )
		Local Y2:Double = Max( Rectangle.Y, Rectangle.BottomY() - 0.5 * Height )
		SetY( L_LimitDouble( Y, Y1, Y2 ) )
	End Method
	
	' ==================== Angle ====================
	
	Rem
	bbdoc: Direction to the point.
	returns: Angle between vector from the center of the shape to the point with given coordinates and X axis.
	about: 
	End Rem
	Method DirectionToPoint:Double( PointX:Double, PointY:Double )
		Return ATan2( PointY - Y, PointX - X )
	End Method
	
	
	
	Rem
	bbdoc: Direction to shape.
	returns: Angle between vector from the center of this shape to center of given shape and X axis.
	about: 
	End Rem
	Method DirectionTo:Double( Shape:LTShape )
		Return ATan2( Shape.Y - Y, Shape.X - X )
	End Method
	
	' ==================== Size ====================

	Rem
	bbdoc: Sets the width of the shape.
	about: It's better to use this method instead of equating Width field to new value.
	End Rem
	Method SetWidth( NewWidth:Double )	
		SetSize( NewWidth, Height )
	End Method
	
	
	
	Rem
	bbdoc: Sets the height of the shape.
	about: It's better to use this method instead of equating Height field to new value.
	End Rem
	Method SetHeight( NewHeight:Double )	
		SetSize( Width, NewHeight )
	End Method
	
	
	
	Rem
	bbdoc: Sets the size of the shape.
	about: It's better to use this method instead of equating Width and Height fields to new values.
	End Rem
	Method SetSize( NewWidth:Double, NewHeight:Double )
		Width = NewWidth
		Height = NewHeight
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Returns diameter of circular shape.
	returns: Width field of the shape.
	End Rem
	Method GetDiameter:Double()
		Return Width
	End Method
	
	
	
	Rem
	bbdoc: Sets the diameter of the shape.
	End Rem
	Method SetDiameter( NewDiameter:Double )
		SetSize( NewDiameter, NewDiameter )
	End Method
	
	
	
	Rem
	bbdoc: Corrects height to display shape image with no distortion.
	about: Works only for shapes with image visualizer. After this operation ratio of width to height will be the same as ratio of image width to image height.
	End Rem
	Method CorrectHeight()
		Local Image:LTImage = Visualizer.GetImage()
		
		?debug
		If Not Image Then L_Error( "Cannot correct Height: visual is not of LTImageVisual type" )
		?
		
		SetSize( Width, Width * ImageHeight( Image.BMaxImage ) / ImageWidth( Image.BMaxImage ) )
	End Method
	
	
	
	Rem
	bbdoc: Returns shape facing.
	returns: -1.0 if shape is facing left (LeftFacing constant) 
	+1.0 if shape is facing right (RightFacing constant).
	about: Equal to the sign of visualizer XScale field.
	End Rem
	Method GetFacing:Double()
		Return Sgn( Visualizer.XScale )
	End Method
	
	
	
	Const LeftFacing:Double = -1.0
	Const RightFacing:Double = 1.0
	
	Rem
	bbdoc: Sets the facing of a shape.
	about: Use LeftFacing and RightFacing constants.
	End Rem
	Method SetFacing( NewFacing:Double )
		Visualizer.XScale = Abs( Visualizer.XScale ) * NewFacing
	End Method
	
	' ==================== Behavior models ===================
	
	Rem
	bbdoc: Attaches behavior model to the shape.
	about: Model will be initialized and activated if necessary.
	End Rem
	Method AttachModel( Model:LTBehaviorModel, Activated:Int = True )
		Model.Init( Self )
		Model.Link = BehaviorModels.AddLast( Model )
		If Activated Then
			Model.Activate( Self )
			Model.Active = True
		End If
	End Method
	
	
	
	Rem
	bbdoc: Finds behavior model by its class name.
	returns: First behavior model with the class of given name.
	End Rem
	Method FindModel:LTBehaviorModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID Then Return Model
		Next
	End Method
	
	
	
	Rem
	bbdoc: Activates all behavior models of the shape.
	about: Executes Activate() method of all deactivated models and set their Active field to True.
	End Rem
	Method ActivateAllModels()
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If Not Model.Active Then
				Model.Activate( Self )
				Model.Active = True
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Deactivates all behavior models of the shape.
	about: Executes Deactivate() method of all activated models and set their Active field to False.
	End Rem
	Method DeactivateAllModels()
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If Model.Active Then
				Model.Deactivate( Self )
				Model.Active = False
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Activates shape behavior models of class with given name.
	about: Executes Activate() method of all inactive models of class with given name and set their Active field to True.
	End Rem
	Method ActivateModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID And Not Model.Active Then
				Model.Activate( Self )
				Model.Active = True
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Deactivates shape behavior models of class with given name.
	about: Executes Deactivate() method of all active models of class with given name and set their Active field to False.
	End Rem
	Method DeactivateModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID And Model.Active Then
				Model.Deactivate( Self )
				Model.Active = False
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Toggles activity of shape behavior models of class with given name.
	about: Executes Activate() method of all inactive and Deactivate() method of all active models of class with given name and toggles their Active field.
	End Rem
	Method ToggleModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID Then
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
	
	
	
	Rem
	bbdoc: Removes all shape behavior models of class with given name.
	about: Active models will be deactivated before removal.
	End Rem
	Method RemoveModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID Then
				Model.Remove( Self )
			End If
		Next
	End Method
	
	' ==================== Windowed Visualizer ====================
	
	Rem
	bbdoc: Limits sprite displaying by window with given parameters.
	about: These parameters forms a rectangle on game field which will be viewport for displaying the sprite.
	All sprite parts which are outside this rectangle will not be displayed.
	End Rem
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
	
	
	
	Rem
	bbdoc: Limits sprite displaying by given rectangular shape.
	about: All sprite parts which are outside this rectangle will not be displayed.
	End Rem
	Method LimitByWindowShape( Shape:LTShape )
		LimitByWindow( Shape.X, Shape.Y, Shape.Width, Shape.Height )
	End Method
	
	
	
	Rem
	bbdoc: Removes window limit.
	about: After executing this method the sprite will be displayed as usual.
	End Rem
	Method RemoveWindowLimit()
		Visualizer = LTWindowedVisualizer( Visualizer ).Visualizer
	End Method
	
	' ==================== Other ===================
	
	Rem
	bbdoc: Initialiation method of the sprite.
	about: Fill it with shape initialization commands. This method will be executed after loading the layer which have this shape inside.
	End Rem
	Method Init()
	End Method
	
	
	
	Rem
	bbdoc: Clones the shape.
	returns: Clone of the shape.
	End Rem
	Method Clone:LTShape()
		Local NewShape:LTShape = New LTShape
		CopyTo( NewShape )
		Return NewShape
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
	
	
	
	Rem
	bbdoc: Acting method of the shape.
	about: Fill it with the shape acting commands. By default this method applies all behavior models of the shape to the shape, so if
	you want to have this action inside your own Act() method, use Super.Act() command.
	End Rem
	Method Act()
		If Active Then
			For Local Model:LTBehaviorModel = EachIn BehaviorModels
				If Model.Active Then
					Model.ApplyTo( Self )
				Else
					Model.Watch( Self )
				End If
			Next
			
			?debug
			If LTSprite( Self )
				L_SpriteActed = True
				L_SpritesActed :+ 1
			End If
			?
		End If
	End Method
	

	
	Rem
	bbdoc: Method for updating shape.
	about: It will be called after changing coordinates or size. You can add your shape updating commands here, but don't forget to add Super.Update() command as well.
	End Rem
	Method Update()
	End Method
	
	
	
	Rem
	bbdoc: Method for destruction of the shape.
	about: Fill it with commands for removing shape from layers, lists, maps, etc.
	End Rem
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