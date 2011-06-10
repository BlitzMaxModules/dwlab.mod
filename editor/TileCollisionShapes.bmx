'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Global TileCollisionShapes:TTileCollisionShapes = New TTileCollisionShapes

Type TTileCollisionShapes
	Field CollisionGroup:LTGroup
	Field CollisionShape:LTShape
	Field CollisionShapeUnderCursor:LTSprite
	Field Cursor:LTSprite = New LTSprite
	Field TileSet:LTTileSet
	Field TileNum:Int
	Field Visualizer:LTVisualizer = New LTVisualizer

	Field CreateCollisionShape:TCreateCollisionShape = New TCreateCollisionShape
	Field MoveCollisionShape:TMoveCollisionShape = New TMoveCollisionShape
	Field ResizeCollisionShape:TResizeCollisionShape = New TResizeCollisionShape
	
			
	
	Method Edit( TileMap:LTTileMap )
		TileSet = TileMap.TileSet
		If Not TileSet Then
			Notify( "L_SelectTileset" )
			Return
		End If
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then
			Notify( "L_SelectImage" )
			Return
		End If
		
		Local Window:TGadget =CreateWindow( Title, 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( Window )
		Form.NewLine()
		Local ShapeComboBox:TGadget = Form.AddComboBox( "{{L_Shape}}", 100 )
		Form.NewLine()
		Local XField:TGadget = Form.AddTextField( "{{L_X}}", 80 )
		Local YField:TGadget = Form.AddTextField( "{{L_Y}}", 80 )
		Form.NewLine()
		Local WidthField:TGadget = Form.AddTextField( "{{L_Width}}", 80 )
		Local HeightField:TGadget = Form.AddTextField( "{{L_Height}}", 80 )
		Form.NewLine()
		Local TileCanvas:TGadget = Form.AddCanvas( 128, 128 )
		Local TilesetCanvas:TGadget = Form.AddCanvas( ImageCanvasSize, ImageCanvasSize )
		Form.NewLine()
		Local CloseButton:TGadget = Form.AddButton( "L_Close", 64 )
		Form.Finalize()
		
		L_CurrentCamera = LTCamera.Create( 128, 128, 128.0 )
		L_CurrentCamera.SetCoords( 0.5, 0.5 )
		
		Local Size:Float = L_CurrentCamera.DistScreenToField( 8.0 )
		Cursor.ShapeType = LTSprite.Circle
		Cursor.SetSize( Size, Size )
	
		Visualizer.Alpha = 0.5
		Visualizer.SetColorFromRGB( 1.0, 0.0, 1.0 )
		
		Repeat
			SetGraphics( CanvasGraphics( TileCanvas ) )
			Cls
			
			CollisionShape = TileSet.CollisionShape[ TileNum ]
			If CollisionShape Then CollisionShape.DrawUsingVisualizer( Visualizer )
			
			Flip( False )
	
			TileNum = PrintImageToCanvas( TImage( Editor.BigImages.ValueForKey( Image ) ), TilesetCanvas, Image.XCells, Image.YCells, TileNum )
	
			DisablePolledInput()
			EnablePolledInput( TileCanvas )
			
			CollisionGroup = LTGroup( Shape )
			SpriteUnderCursor = Null
			Local Sprite:LTSprite = LTSprite( Shape )
			If Sprite Then
				If Cursor.CollidesWithSprite( Sprite ) Then SpriteUnderCursor = Sprite
			ElseIf CollisionGroup Then
				For Sprite = Eachin CollisionGroup
					If Cursor.CollidesWithSprite( Sprite ) Then
						SpriteUnderCursor = Sprite
						Exit
					End If
				Next
			End If
			
			CreateCollisionShape.Execute()
			MoveCollisionShape.Execute()
			ResizeCollisionShape.Execute()
			
			DisablePolledInput()
			EnablePolledInput( TileSetCanvas )
			
			WaitEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case OKButton
							Local NewWidth:Int = TextFieldText( WidthField ).ToInt()
							Local NewHeight:Int = TextFieldText( HeightField ).ToInt()
							
							If NewWidth >= 0 And NewHeight >= 0 Then
								Width = NewWidth
								Height = NewHeight
								FreeGadget( Window )
								Return True
							Else
								Notify( LocalizeString( "{{N_ParametersMustBeMoreThanZero}}" ), True )
							End If
						Case CloseButton
							Exit
					End Select
				Case Event_WindowClose
					Exit
			End Select
		Forever
		
		FreeGadget( Window )
	End Method
End Function






Type TCreateCollisionShape Extends LTDrag
	Field StartingX:Float, StartingY:Float
	Field CollisionShape:LTSprite

	
	
	Method DraggingConditions:Int()
		If Not CollisionShapeUnderCursor And Not TileCollisionShapes.ResizeCollisionShape.DraggingState Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 2 )
	End Method
	
	
	
	Method StartDragging()
		CollisonShape = New LTSprite
		StartingX = TileCollisionShapes.Cursor.X
		StartingY = TileCollisionShapes.Cursor.Y
		If TileCollisionShapes.CollisionGroup Then
			TileCollisionShapes.CollisionGroup.AddLast( CollisonShape )
		ElseIf TileCollisionShapes.CollisionShape Then
			TileCollisionShapes.CollisionGroup = New LTGroup
			TileCollisionShapes.CollisionGroup.AddLast( TileCollisionShapes.CollisionShape )
			TileCollisionShapes.CollisionGroup.AddLast( CollisonShape )
			TileCollisionShapes.TileSet.CollisionShape[ TileCollisionShapes.TileNum ] = TileCollisionShapes.CollisionGroup
		Else
			TileCollisionShapes.TileSet.CollisionShape[ TileCollisionShapes.TileNum ] = CollisonShape
		End If
	End Method
	
	
	
	Method Dragging()
		CollisonShape.SetCoords( 0.5 * ( StartingX + TileCollisionShapes.Cursor.X ), 0.5 * ( StartingY - TileCollisionShapes.Cursor.Y ) )
		CollisonShape.SetSize( Abs( StartingX - TileCollisionShapes.Cursor.X ), Abs( StartingY - TileCollisionShapes.Cursor.Y ) )
	End Method
End Type




Type TMoveCollisionShape Extends LTDrag
	Field StartingX:Float, StartingY:Float
	Field CollisionShape:LTSprite

	
	
	Method DraggingConditions:Int()
		If CollisionShapeUnderCursor Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method
	
	
	
	Method StartDragging()
		StartingDX = TileCollisionShapes.Cursor.X
		StartingDY = TileCollisionShapes.Cursor.Y
	End Method
	
	
	
	Method Dragging()
		CollisonShape.SetCoords( 0.5 * ( StartingX + TileCollisionShapes.Cursor.X ), 0.5 * ( StartingY - TileCollisionShapes.Cursor.Y ) )
	End Method
End Type





Type TResizeCollisionShape Extends LTDrag
End Type
