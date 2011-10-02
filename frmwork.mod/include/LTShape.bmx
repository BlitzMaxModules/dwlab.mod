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
Include "LTMap.bmx"
Include "LTLine.bmx"
Include "LTGraph.bmx"
Include "LTVisualizer.bmx"

Rem
bbdoc: Common object for item of game field.
End Rem
Type LTShape Extends LTObject
	Field Parameters:TList

	Rem
	bbdoc: X coordinate of the shape center in units.
	about: See also: #SetX, #SetCoords, #SetCornerCoords, #SetVouseCoords, #AlterCoords, #LeftX, #RightX, #DistanceTo, #JumpTo
	#PlaceBetween, #IsAtPositionOf, #LimitWith, #LimitHorizontallyWith, #LimitLeftWith, #LimitRightWith, #Move
	End Rem
	Field X:Double
	
	Rem
	bbdoc: Y coordinate of the shape center in units.
	about: See also: #SetY, #SetCoords, #SetCornerCoords, #SetVouseCoords, #AlterCoords, #TopY, #BottomY, #DistanceTo, #JumpTo
	#PlaceBetween, #IsAtPositionOf, #LimitWith, #LimitVerticallyWith, #LimitTopWith, #LimitBottomWith, #Move
	End Rem
	Field Y:Double
	
	Rem
	bbdoc: Shape width in units.
	about: See also: #SetWidth, #GetDiameter, #SetDiameter, 
	End Rem
	Field Width:Double = 1.0
	
	Rem
	bbdoc: Shape height in units.
	about: See also: #SetHeight, #CorrectHeight
	End Rem
	Field Height:Double = 1.0
	
	Rem
	bbdoc: Shape visualizer (object which displays this shape).
	about: See also: #LTVisualizer, #L_DefaultVisualizer, #LTDebugVisualizer, #L_DebugVisualizer
	End Rem
	Field Visualizer:LTVisualizer = L_DefaultVisualizer
	
	Rem
	bbdoc: Visibility flag.
	about: If False then shape will not be drawn.
	
	See also: #Draw, #DrawUsingVisualizer
	End Rem
	Field Visible:Int = True
	
	Rem
	bbdoc: Activity flag.
	about: If False then Act() method for shape will not be executed.
	
	See also: #Act
	End Rem
	Field Active:Int = True
	
	Rem
	bbdoc: Behavior models list.
	about: Standard Act() method will apply every behavior model in this list to the shape.
	
	See also: #LTBehaviorModel
	End Rem
	Field BehaviorModels:TList = New TList
	
	Rem
	bbdoc: Constant for horizontal collision type.
	about: See tutorial for additional info.
	
	See also: #CollisionsWithGroup, #CollisionsWithSprite, #CollisionsWithTileMap, #CollisionsWithSpriteMap, #CollisionsWithLine
	#HandleCollisionWithSprite, #HandleCollisionWithTile
	End Rem
	Const Horizontal:Int = 1
	
	Rem
	bbdoc: Constant for vertical collision type.
	about: See tutorial for additional info.
	
	See also: #CollisionsWithGroup, #CollisionsWithSprite, #CollisionsWithTileMap, #CollisionsWithSpriteMap, #CollisionsWithLine
	#HandleCollisionWithSprite, #HandleCollisionWithTile
	End Rem
	Const Vertical:Int = 2
	
	' ==================== Drawing ===================
	
	Rem
	bbdoc: Draws the shape.
	about: You can fill it with drawing commands for shape and its parts.
	
	See also: #DrawUsingVisualizer, #LTVisualizer, #Visible
	End Rem
	Method Draw()
	End Method
	
	
	
	Rem
	bbdoc: Draws the shape using another visualizer.
	about: You can fill it with drawing commands for shape and its parts using another visualizer.
	
	See also: #Draw, #LTVisualizer, #Visible
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
	about: See also: #X, #Width
	End Rem
	Method LeftX:Double()
 		Return X - 0.5 * Width
 	End Method
	
	
	
	Rem
	bbdoc: Top of the shape.
	returns: Y coordinate of shape top in units.
	about: See also: #Y, #Height
	End Rem
	Method TopY:Double()
 		Return Y - 0.5 * Height
 	End Method
	
	
	
	Rem
	bbdoc: Right side of the shape.
	returns: X coordinate of right shape side in units.
	about: See also: #X, #Width
	End Rem
	Method RightX:Double()
 		Return X + 0.5 * Width
 	End Method
	
	
	
	Rem
	bbdoc: Bottom of the shape
	returns: Y coordinate of shape bottom in units.
	about: See also: #Y, #Height
	End Rem
	Method BottomY:Double()
 		Return Y + 0.5 * Height
 	End Method

	
	
	Rem
	bbdoc: Distance to point.
	returns: Distance from the shape center to the point with given coordinates.
	about: See also: #DistanceTo
	End Rem
	Method DistanceToPoint:Double( PointX:Double, PointY:Double )
		Local DX:Double = X - PointX
		Local DY:Double = Y - PointY
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc: Distance to shape.
	returns: Distance from the shape center to center of another shape.
	about: See also: #DistanceToPoint
	End Rem
	Method DistanceTo:Double( Shape:LTShape )
		Local DX:Double = X - Shape.X
		Local DY:Double = Y - Shape.Y
		Return Sqr( DX * DX + DY * DY )
	End Method
	
	
	
	Rem
	bbdoc: Checks if the shape is at position of another shape.
	returns: True if shape center has same coordinates as another shape center. 
	about: See also: #X, #Y
	End Rem
	Method IsAtPositionOf:Int( Shape:LTShape )
		If Shape.X = X And Shape.Y = Y Then Return True
	End Method
	
	
	
	Rem
	bbdoc: Sets X coordinate of the shape.
	about: It's better to use this method instead of equating X field to new value.
	
	See also: #X
	End Rem
	Method SetX( NewX:Double )
		SetCoords( NewX, Y )
	End Method
	
	
	
	Rem
	bbdoc: Sets X coordinate of the shape.
	about: It's better to use this method instead of equating X field to new value.
	
	See also: #Y
	End Rem
	Method SetY( NewY:Double )
		SetCoords( X, NewY )
	End Method
	
	
	Rem
	bbdoc: Sets coordinates of the shape.
	about: It's better to use this method instead of equating X and Y fields to new values.
	
	See also: #X, #Y, #SetCornerCoords, #AlterCoords, #SetMouseCoords
	End Rem
	Method SetCoords( NewX:Double, NewY:Double )
		X = NewX
		Y = NewY
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Alter coordinates of the shape.
	about: Given values will be added to the coordinates. It's better to use this method instead of incrementing X and Y fields manually.
	
	See also: #SetCoords, #SetCornerCoords, #SetMouseCoords
	End Rem
	Method AlterCoords( DX:Double, DY:Double )
		SetCoords( X + DX, Y + DY )
	End Method
	
	
	
	Rem
	bbdoc: Sets top-left corner coordinates of the shape.
	about: After this operation top-left corner of the shape will be at given coordinates.
	
	See also: #SetCoords, #AlterCoords, #SetMouseCoords
	End Rem
	Method SetCornerCoords( NewX:Double, NewY:Double )
		SetCoords( NewX + Width * 0.5, NewY + Height * 0.5 )
	End Method
	
	
	
	Rem
	bbdoc: Moves shape to another one.
	about: Center coordinates of the shape will be equated to corresponding center coordinates of given shape.
	
	See also: #IsAtPositionOf, #SetCoords
	End Rem
	Method JumpTo( Shape:LTShape )
		SetCoords( Shape.X , Shape.Y )
	End Method
	
	
	
	Rem
	bbdoc: Moves shape to mouse position.
	about: Mouse coordinates will be transformed to field coordinates using current camera. Then shape coordinates will be equated to these.
	
	See also: #SetCoords
	End Rem
	Method SetMouseCoords()
		Local NewX:Double, NewY:Double
		L_CurrentCamera.ScreenToField( MouseX(), MouseY(), NewX, NewY )
		SetCoords( NewX, NewY )
	End Method
	
	
	
	Method SetCoordsRelativeTo( Sprite:LTSprite, NewX:Double, NewY:Double )
		Local SpriteAngle:Double = DirectionToPoint( NewX, NewY ) + Sprite.Angle
		Local Radius:Double = Sqr( NewX * NewX + NewY * NewY )
		SetCoords( Sprite.X + Radius * Cos( SpriteAngle ), Sprite.Y + Radius * Sin( SpriteAngle ) )
	End Method
	
	
	
	Method PositionOnTileMap( TileMap:LTTileMap, TileX:Double, TileY:Double )
		X = TileMap.LeftX() + ( TileX + 0.5 ) * TileMap.GetTileWidth()
		Y = TileMap.TopY() + ( TileY + 0.5 ) * TileMap.GetTileHeight()
	End Method
	
	
	
	Rem
	bbdoc: Moves the shape.
	about: The shape will be moved with given horizontal and vertical speed per second.
	End Rem
	Method Move( DX:Double, DY:Double )
		SetCoords( X + DX * L_DeltaTime, Y + DY * L_DeltaTime )
	End Method
	
	
	
	Rem
	bbdoc: Moves the shape with given velocity towards shape.
	about: See also: #MoveForward
	End Rem
	Method MoveTowards( Shape:LTShape, Velocity:Double )
		MoveTowardsPoint( Shape.X, Shape.Y, Velocity )
	End Method
	
	
	
	Rem
	bbdoc: Moves the shape with given velocity towards shape.
	about: See also: #MoveForward
	End Rem
	Method MoveTowardsPoint( DestinationX:Double, DestinationY:Double, Velocity:Double )
		Local Angle:Double = DirectionToPoint( DestinationX, DestinationY )
		Local DX:Double = Cos( Angle ) * Velocity * L_DeltaTime
		Local DY:Double = Sin( Angle ) * Velocity * L_DeltaTime
		If Abs( DX ) >= Abs( X - DestinationX ) And Abs( DY ) >= Abs( Y - DestinationY ) Then
			SetCoords( DestinationX, DestinationY )
		Else
			SetCoords( X + DX, Y + DY )
		End If
	End Method
	
	
	
	Rem
	bbdoc: Places the shape between two another shapes.
	about: K parameter is in 0...1 interval.
	<ul>
	<li> 0 shifts shape to the center of first given shape.
	<li> 1 shifts shape to the center of the second given shape.
	<li> 0.5 shifts shape to the middle between given shapes centers.
	</ul>
	End Rem
	Method PlaceBetween( Shape1:LTShape, Shape2:LTShape, K:Double )
		SetCoords( Shape1.X + ( Shape2.X - Shape1.X ) * K, Shape1.Y + ( Shape2.Y - Shape1.Y ) * K )
	End Method
	
	
	
	Rem
	bbdoc: Allowing moving the shape around with given velocity with WSAD keys.
	about: See also: #MoveUsingArrows, #MoveUsingKeys, #Move
	End Rem
	Method MoveUsingWSAD( Velocity:Double )
		MoveUsingKeys( Key_W, Key_S, Key_A, Key_D, Velocity )
	End Method
	
	
	
	Rem
	bbdoc: Allowing moving the shape around with given velocity with Arrow keys.
	about: See also: #MoveUsingWSAD, #MoveUsingKeys, #Move
	End Rem
	Method MoveUsingArrows( Velocity:Double )
		MoveUsingKeys( Key_Up, Key_Down, Key_Left, Key_Right, Velocity )
	End Method
	
	
	
	Rem
	bbdoc: Allowing moving the shape around with with given keys and velocity.
	about: See also: #MoveUsingArrows, #MoveUsingWSAD, #Move
	End Rem
	Method MoveUsingKeys( KUp:Int, KDown:Int, KLeft:Int, KRight:Int, Velocity:Double )
		Local DX:Double = KeyDown( KRight ) - KeyDown( KLeft )
		Local DY:Double = KeyDown( KDown ) - KeyDown( KUp )
		
		Local X1:Double, Y1:Double, X2:Double, Y2:Double
		L_CurrentCamera.ScreenToField( 0, 0, X1, Y1 )
		L_CurrentCamera.ScreenToField( DX, DY, X2, Y2 )
		
		If X1 = X2 And Y1 = Y2 Then Return
		
		Local K:Double = Velocity / L_Distance( X2 - X1, Y2 - Y1 )
		SetCoords( X + ( X2 - X1 ) * K * L_DeltaTime, Y + ( Y2 - Y1 ) * K * L_DeltaTime )
	End Method
	
	
	
	Rem
	bbdoc: Applies parallax effect for shape depending on current camera size and position relative to given shape.
	End Rem
	Method Parallax( Shape:LTShape )
		Local DX:Double = Shape.Width - L_CurrentCamera.Width
		Local DY:Double = Shape.Height - L_CurrentCamera.Height
		SetCoords( Shape.LeftX() + 0.5 * Width + ( L_CurrentCamera.LeftX() - Shape.LeftX() ) * ( Shape.Width - Width ) / DX,..
			Shape.TopY() + 0.5 * Height + ( L_CurrentCamera.TopY() - Shape.TopY() ) * ( Shape.Height - Height ) / DY )
	End Method
	
	' ==================== Limiting ====================
	
	Rem
	bbdoc: Limits shape with given rectangular shape.
	about: If the shape is outside given shape, it will be moved inside it. If the shape is larger than given shape, it will be moved to the center of given shape.
	
	See also: #LimitHorizontallyWith, #LimitVerticallyWith, #LimitLeftWith, #LimitRightWith, #LimitTopWith, #LimitBottomWith
	End Rem
	Method LimitWith( Rectangle:LTShape )
		LimitHorizontallyWith( Rectangle )
		LimitVerticallyWith( Rectangle )
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Limits left side of the shape with left side of given rectangular shape.
	about: If the left side X coordinate of shape is less than left side X coordinate of given shape, left side of the shape will be equated to left side of given shape.
	
	See also: #LimitWith, #LimitHorizontallyWith, #LimitVerticallyWith, #LimitRightWith, #LimitTopWith, #LimitBottomWith
	End Rem
	Method LimitLeftWith( Rectangle:LTShape )
		If LeftX() < Rectangle.LeftX() Then SetX( Rectangle.LeftX() + 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Limits top of the shape with top of given rectangular shape.
	about: If the top Y coordinate of shape is less than top Y coordinate of given shape, top of the shape will be equated to the top of given shape.
	
	See also: #LimitWith, #LimitHorizontallyWith, #LimitVerticallyWith, #LimitLeftWith, #LimitRightWith, #LimitBottomWith
	End Rem
	Method LimitTopWith( Rectangle:LTShape )
		If TopY() < Rectangle.TopY() Then SetY( Rectangle.TopY() + 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Limits right side of the shape with right side of given rectangular shape.
	about: If the right side X coordinate of shape is more than right side X coordinate of given shape, right side of the shape will be equated to right side of given shape.
	
	See also: #LimitWith, #LimitHorizontallyWith, #LimitVerticallyWith, #LimitLeftWith, #LimitTopWith, #LimitBottomWith
	End Rem
	Method LimitRightWith( Rectangle:LTShape )
		If RightX() > Rectangle.RightX() Then SetX( Rectangle.RightX() - 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Limits bottom of the shape with bottom of given rectangular shape.
	about: If the bottom Y coordinate of shape is more than bottom Y coordinate of given shape, bottom of the shape will be equated to the bottom of given shape.
	
	See also: #LimitWith, #LimitHorizontallyWith, #LimitVerticallyWith, #LimitLeftWith, #LimitRightWith, #LimitTopWith
	End Rem
	Method LimitBottomWith( Rectangle:LTShape )
		If BottomY() > Rectangle.BottomY() Then SetY( Rectangle.BottomY() - 0.5 * Width )
	End Method
	
	
	
	Rem
	bbdoc: Keeps shape within limits of given shape horizontally.
	about: See also: #LimitWith, #LimitVerticallyWith, #LimitLeftWith, #LimitRightWith, #LimitTopWith, #LimitBottomWith
	End Rem
	Method LimitHorizontallyWith( Rectangle:LTShape )
		Local X1:Double = Min( Rectangle.X, Rectangle.LeftX() + 0.5 * Width )
		Local X2:Double = Max( Rectangle.X, Rectangle.RightX() - 0.5 * Width )
		SetX( L_LimitDouble( X, X1, X2 ) )
	End Method
	
	
	
	Rem
	bbdoc: Keeps shape within limits of given shape vertically.
	about: See also: #LimitWith, #LimitHorizontallyWith, #LimitLeftWith, #LimitRightWith, #LimitTopWith, #LimitBottomWith
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
	about: See also: #DirectionTo
	End Rem
	Method DirectionToPoint:Double( PointX:Double, PointY:Double )
		Return ATan2( PointY - Y, PointX - X )
	End Method
	
	
	
	Rem
	bbdoc: Direction to shape.
	returns: Angle between vector from the center of this shape to center of given shape and X axis.
	about: See also: #DirectionToPoint
	End Rem
	Method DirectionTo:Double( Shape:LTShape )
		Return ATan2( Shape.Y - Y, Shape.X - X )
	End Method
	
	' ==================== Size ====================

	Rem
	bbdoc: Sets the width of the shape.
	about: It's better to use this method instead of equating Width field to new value.
	
	See also: #Width, #GetDiameter, #SetDiameter, #SetHeight, #SetSize
	End Rem
	Method SetWidth( NewWidth:Double )	
		SetSize( NewWidth, Height )
	End Method
	
	
	
	Rem
	bbdoc: Sets the height of the shape.
	about: It's better to use this method instead of equating Height field to new value.
	
	See also: #Height, #SetWidth, #SetSize
	End Rem
	Method SetHeight( NewHeight:Double )	
		SetSize( Width, NewHeight )
	End Method
	
	
	
	Rem
	bbdoc: Sets the size of the shape.
	about: It's better to use this method instead of equating Width and Height fields to new values.
	
	See also: #Width, #Height, #SetWidth, #SetHeight
	End Rem
	Method SetSize( NewWidth:Double, NewHeight:Double )
		Width = NewWidth
		Height = NewHeight
		Update()
	End Method
	
	
	
	Rem
	bbdoc: Returns diameter of circular shape.
	returns: Width field of the shape.
	about: See also: #SetDiameter
	End Rem
	Method GetDiameter:Double()
		Return Width
	End Method
	
	
	
	Rem
	bbdoc: Sets the diameter of the shape.
	about: See also: #GetDiameter
	End Rem
	Method SetDiameter( NewDiameter:Double )
		SetSize( NewDiameter, NewDiameter )
	End Method
	
	
	
	Rem
	bbdoc: Corrects height to display shape image with no distortion.
	about: After this operation ratio of width to height will be the same as ratio of image width to image height.
	
	See also: #Height, #SetHeight, #Visualizer
	End Rem
	Method CorrectHeight()
		Local Image:LTImage = Visualizer.Image
		SetSize( Width, Width * ImageHeight( Image.BMaxImage ) / ImageWidth( Image.BMaxImage ) )
	End Method
	
	
	
	Rem
	bbdoc: Returns shape facing.
	returns: Shape facing
	about: 
	<ul>
	<li> Returns -1.0 if shape is facing left (LeftFacing constant) 
	<li> Returns +1.0 if shape is facing right (RightFacing constant).
	</ul>
	Equal to the sign of visualizer XScale field.
	
	See also: #SetFacing, #XScale
	End Rem
	Method GetFacing:Double()
		Return Sgn( Visualizer.XScale )
	End Method
	
	
	
	Const LeftFacing:Double = -1.0
	Const RightFacing:Double = 1.0
	
	Rem
	bbdoc: Sets the facing of a shape.
	about: Use LeftFacing and RightFacing constants.
	See also: #GetFacing, #XScale
	End Rem
	Method SetFacing( NewFacing:Double )
		Visualizer.XScale = Abs( Visualizer.XScale ) * NewFacing
	End Method
	
	' ==================== Behavior models ===================
	
	Rem
	bbdoc: Attaches behavior model to the shape.
	about: Model will be initialized and activated if necessary.
	
	See also: #LTBehaviorModel, #Activate
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
	about: See also: #LTBehaviorModel
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
	
	See also: #LTBehaviorModel, #Activate
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
	
	See also: #LTBehaviorModel, #Deactivate
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
	
	See also: #LTBehaviorModel, #Activate
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
	
	See also: #LTBehaviorModel, #Deactivate
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
	
	See also: #LTBehaviorModel, #Activate, #Deactivate
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
	
	See also: #LTBehaviorModel, #Deactivate
	End Rem
	Method RemoveModel( TypeName:String )
		Local TypeID:TTypeId = L_GetTypeID( TypeName )
		For Local Model:LTBehaviorModel = EachIn BehaviorModels
			If TTypeId.ForObject( Model ) = TypeID Then
				Model.Remove( Self )
			End If
		Next
	End Method
	
	
	
	Rem
	bbdoc: Shows all behavior models attached to shape with their status.
	End Rem
	Method ShowModels:Int( Y:Int = 0, Shift:String = "" )
		If BehaviorModels.IsEmpty() Then Return Y
		DrawText( Shift + GetTitle() + ":", 0, Y )
	    Y :+ 16
	    For Local Model:LTBehaviorModel = Eachin BehaviorModels
	      DrawText( Shift + TTypeID.ForObject( Model ).Name() + ": " + Model.Active, 8, Y )
	      Y :+ 16
	    Next
		Return Y
	End Method
	
	' ==================== Windowed Visualizer ====================
	
	Rem
	bbdoc: Limits sprite displaying by window with given parameters.
	about: These parameters forms a rectangle on game field which will be viewport for displaying the sprite.
	All sprite parts which are outside this rectangle will not be displayed.
	
	See also: #LimitByWindowShape, #RemoveWindowLimit
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
	
	See also: #LimitByWindow, #RemoveWindowLimit
	End Rem
	Method LimitByWindowShape( Shape:LTShape )
		LimitByWindow( Shape.X, Shape.Y, Shape.Width, Shape.Height )
	End Method
	
	
	
	Rem
	bbdoc: Removes window limit.
	about: After executing this method the sprite will be displayed as usual.
	
	See also: #LimitByWindow, #LimitByWindowShape
	End Rem
	Method RemoveWindowLimit()
		Visualizer = LTWindowedVisualizer( Visualizer ).Visualizer
	End Method
	
	' ==================== Parameters ===================	
	
	Rem
	bbdoc: Retrieves value of object's parameter with given name.
	returns: Value of object's parameter with given name.
	about: See also: #GetTitle, #GetName
	End Rem
	Method GetParameter:String( Name:String )
		If Not Parameters Then Return ""
		For Local Parameter:LTParameter = Eachin Parameters
			If Parameter.Name = Name Then Return Parameter.Value
		Next
	End Method
	
	
	
	Method GetTitle:String()
		Return L_TitleGenerator.GetTitle( Self )
	End Method
	
	
	
	Method GetClassTitle:String()
	End Method
	
	
	Rem
	bbdoc: Retrieves name of object.
	returns: Value of object's parameter "name".
	about: See also: #GetParameter, #GetTitle
	End Rem
	Method GetName:String()
		Return GetParameter( "name" )
	End Method
	
	' ==================== Cloning ===================
	
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
		If Parameters Then
			Shape.Parameters = New TList
			For Local Parameter:LTParameter = Eachin Parameters
				Local NewParameter:LTParameter = New LTParameter
				NewParameter.Name = Parameter.Name
				NewParameter.Value = Parameter.Value
				Shape.Parameters.AddLast( NewParameter )
			Next 
		Else
			Shape.Parameters = Null
		End If
		If Visualizer Then Shape.Visualizer = Visualizer.Clone()
		Shape.X = X
		Shape.Y = Y
		Shape.Width = Width
		Shape.Height = Height
		Shape.Visible = Visible
		Shape.Active = Active
	End Method
	
	' ==================== Management ===================
	
	Rem
	bbdoc: Initialization method of the sprite.
	about: Fill it with shape initialization commands. This method will be executed after loading the layer which have this shape inside.
	End Rem
	Method Init()
	End Method
	
	
	
	Rem
	bbdoc: Acting method of the shape.
	about: Fill it with the shape acting commands. By default this method applies all behavior models of the shape to the shape, so if
	you want to have this action inside your own Act() method, use Super.Act() command.
	See also: #LTBehaviorModel, #ApplyTo, #Watch
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
		
		XMLObject.ManageListField( "parameters", Parameters )
		XMLObject.ManageDoubleAttribute( "x", X )
		XMLObject.ManageDoubleAttribute( "y", Y )
		XMLObject.ManageDoubleAttribute( "width", Width, 1.0 )
		XMLObject.ManageDoubleAttribute( "height", Height, 1.0 )
		XMLObject.ManageIntAttribute( "visible", Visible, 1 )
		XMLObject.ManageIntAttribute( "active", Active, 1 )
		Visualizer = LTVisualizer( XMLObject.ManageObjectField( "visualizer", Visualizer ) )
	End Method
End Type





Type LTParameter Extends LTObject
	Field Name:String
	Field Value:String
	
	
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "name", Name )
		XMLObject.ManageStringAttribute( "value", Value )
	End Method
End Type





Global L_TitleGenerator:LTTitleGenerator = New LTTitleGenerator

Type LTTitleGenerator
	Method GetTitle:String( Shape:LTShape )
		Local Title:String = Shape.GetParameter( "name" )
		If Title Then Return Title
		Title = Shape.GetParameter( "class" )
		If Title Then Return Title
		Return Shape.GetClassTitle()
	End Method
End Type