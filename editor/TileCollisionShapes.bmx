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
	Field SelectedCollisionShape:LTSprite
	Field Cursor:LTSprite = New LTSprite
	Field TileSet:LTTileSet
	Field TileNum:Int
	Field Visualizer:LTVisualizer = New LTVisualizer
	Field GridCellXDiv:Int = 16
	Field GridCellYDiv:Int = 16
	Field GridActive:Int = True

	Field ShapeComboBox:TGadget
	Field XField:TGadget
	Field YField:TGadget
	Field WidthField:TGadget
	Field HeightField:TGadget

	Field CreateCollisionShape:TCreateCollisionShape = New TCreateCollisionShape
	Field MoveCollisionShape:TMoveCollisionShape = New TMoveCollisionShape
	Field ResizeCollisionShape:TResizeCollisionShape = New TResizeCollisionShape
	
			
	
	Method Edit()
		If Not TileSet Then
			Notify( "N_SelectTileset" )
			Return
		End If
		
		Local Image:LTImage = TileSet.Image
		If Not Image Then
			Notify( "N_SelectImage" )
			Return
		End If
		
		Local Window:TGadget =CreateWindow( "{{W_TileCollisionShapesEditor}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( Window )
		Form.NewLine()
		ShapeComboBox = Form.AddComboBox( "{{L_Shape}}", Editor.LabelWidth, 200 )
		Form.NewLine()
		XField = Form.AddTextField( "{{L_X}}", Editor.LabelWidth )
		YField = Form.AddTextField( "{{L_Y}}", Editor.LabelWidth )
		Form.NewLine()
		WidthField = Form.AddTextField( "{{L_Width}}", Editor.LabelWidth )
		HeightField = Form.AddTextField( "{{L_Height}}", Editor.LabelWidth )
		Form.NewLine()
		Local TileCanvas:TGadget = Form.AddCanvas( 128, 128 )
		Local TilesetCanvas:TGadget = Form.AddCanvas( ImageCanvasSize, ImageCanvasSize )
		Form.NewLine()
		Local GridSettingsButton:TGadget = Form.AddButton( "{{M_GridSettings}}", 128 )
		Local CloseButton:TGadget = Form.AddButton( "{{B_Close}}", 64 )
		Form.Finalize()
		
		L_CurrentCamera = LTCamera.Create( 128, 128, 128.0 )
		L_CurrentCamera.SetCoords( 0.5, 0.5 )
		
		Local Size:Double = L_CurrentCamera.DistScreenToField( 8.0 )
		Cursor.ShapeType = LTSprite.Circle
		Cursor.SetSize( Size, Size )
	
		Visualizer.Alpha = 0.5
		Visualizer.SetColorFromRGB( 1.0, 0.0, 1.0 )
		
		Local MouseIsOver:TGadget
		
		Repeat
			SetGraphics( CanvasGraphics( TileCanvas ) )
			SetBlend( AlphaBlend )
			Cls
			
			SetScale( 128.0 / ImageWidth( TileSet.Image.BMaxImage ), 128.0 / ImageHeight( TileSet.Image.BMaxImage ) )
			DrawImage( TileSet.Image.BMaxImage, 64, 64, TileNum )
			SetScale( 1.0, 1.0 )
			
			CollisionShape = TileSet.CollisionShape[ TileNum ]
			If CollisionShape Then CollisionShape.DrawUsingVisualizer( Visualizer )
			If SelectedCollisionShape Then SelectedCollisionShape.DrawUsingVisualizer( Editor.MarchingAnts )
			
			Flip( False )
	
			Local OldTileNum:Int = TileNum
			TileNum = PrintImageToCanvas( TImage( Editor.BigImages.ValueForKey( Image ) ), TilesetCanvas, Image.XCells, Image.YCells, TileNum, MouseIsOver = TilesetCanvas, TileSet )
			If OldTileNum <> TileNum Then
				SelectedCollisionShape = Null
				RefreshFields()
			End If
	
			If MouseIsOver = TileCanvas Then
				Cursor.SetMouseCoords()
				CollisionGroup = LTGroup( CollisionShape )
				CollisionShapeUnderCursor = Null
				Local Sprite:LTSprite = LTSprite( CollisionShape )
				If Sprite Then
					If Cursor.CollidesWithSprite( Sprite ) Then CollisionShapeUnderCursor = Sprite
				ElseIf CollisionGroup Then
					For Sprite = Eachin CollisionGroup
						If Cursor.CollidesWithSprite( Sprite ) Then
							CollisionShapeUnderCursor = Sprite
							Exit
						End If
					Next
				End If
				
				
				If SelectedCollisionShape And KeyHit( Key_Delete ) Then DeleteShape()
				
				CreateCollisionShape.Execute()
				MoveCollisionShape.Execute()
				ResizeCollisionShape.Execute()
			End If
			
			PollEvent()
			Select EventID()
				Case Event_MouseEnter
					Select EventSource()
						Case TileCanvas
							ActivateGadget( TileCanvas )
							DisablePolledInput()
							EnablePolledInput( TileCanvas )
							MouseIsOver = TileCanvas
						Case TilesetCanvas
							ActivateGadget( TilesetCanvas )
							DisablePolledInput()
							EnablePolledInput( TilesetCanvas )
							MouseIsOver = TilesetCanvas
					End Select
				Case Event_GadgetAction
					Select EventSource()
						Case ShapeComboBox
							If SelectedCollisionShape Then
								SelectedCollisionShape.ShapeType = SelectedGadgetItem( ShapeComboBox )
								Select SelectedCollisionShape.ShapeType
									Case LTSprite.Pivot
										SelectedCollisionShape.SetSize( 0.0, 0.0 )
									Case LTSprite.Circle
										Local Size:Double = Min( SelectedCollisionShape.Width, SelectedCollisionShape.Height )
										SelectedCollisionShape.SetSize( Size, Size )
								End Select
								If SelectedCollisionShape.ShapeType <> LTSprite.Pivot Then
									If SelectedCollisionShape.Width = 0.0 Or SelectedCollisionShape.Height = 0.0 Then DeleteShape()
								End If
							End If
						Case XField
							If SelectedCollisionShape Then
								SelectedCollisionShape.X = GadgetText( XField ).ToDouble()
								If SelectedCollisionShape.LeftX() < 0.0 Then SelectedCollisionShape.X = 0.5 * SelectedCollisionShape.Width
								If SelectedCollisionShape.RightX() > 1.0 Then SelectedCollisionShape.X = 1.0 - 0.5 * SelectedCollisionShape.Width
							End If
						Case YField
							If SelectedCollisionShape Then
								SelectedCollisionShape.Y = GadgetText( YField ).ToDouble()
								If SelectedCollisionShape.TopY() < 0.0 Then SelectedCollisionShape.Y = 0.5 * SelectedCollisionShape.Height
								If SelectedCollisionShape.BottomY() > 1.0 Then SelectedCollisionShape.Y = 1.0 - 0.5 * SelectedCollisionShape.Height
							End If
						Case WidthField
							If SelectedCollisionShape Then
								SelectedCollisionShape.Width = GadgetText( WidthField ).ToDouble()
								If SelectedCollisionShape.LeftX() < 0.0 Then SelectedCollisionShape.Width = 2.0 * SelectedCollisionShape.X
								If SelectedCollisionShape.RightX() > 1.0 Then SelectedCollisionShape.Width = 2.0 * ( 1.0 - SelectedCollisionShape.X )
							End If
						Case HeightField
							If SelectedCollisionShape Then
								SelectedCollisionShape.Height = GadgetText( HeightField ).ToDouble()
								If SelectedCollisionShape.TopY() < 0.0 Then SelectedCollisionShape.Height = 2.0 * SelectedCollisionShape.Y
								If SelectedCollisionShape.BottomY() > 1.0 Then SelectedCollisionShape.Height = 2.0 * ( 1.0 - SelectedCollisionShape.Y )
							End If
						Case GridSettingsButton
							GridSettings()
						Case CloseButton
							Exit
					End Select
				Case Event_WindowClose
					Exit
			End Select
		Forever
		
		FreeGadget( Window )
	End Method
	
	
	
	Method DeleteShape()
		If CollisionGroup Then
			CollisionGroup.Children.Remove( SelectedCollisionShape )
			If CollisionGroup.Children.Count() = 1 Then TileSet.CollisionShape[ TileNum ] = LTShape( CollisionGroup.Children.First() )
		Else
			TileSet.CollisionShape[ TileNum ] = Null
		End If
		SelectedCollisionShape = Null
		Editor.SetChanged()
		RefreshFields()
	End Method
	
	
	
	Method RefreshFields()
		ClearGadgetItems( ShapeComboBox )
		If SelectedCollisionShape Then
			Editor.FillShapeComboBox( ShapeComboBox )
			SelectGadgetItem( ShapeComboBox, SelectedCollisionShape.ShapeType )
			SetGadgetText( XField, L_TrimDouble( SelectedCollisionShape.X ) )
			SetGadgetText( YField, L_TrimDouble( SelectedCollisionShape.Y ) )
			SetGadgetText( WidthField, L_TrimDouble( SelectedCollisionShape.Width ) )
			SetGadgetText( HeightField, L_TrimDouble( SelectedCollisionShape.Height ) )
		Else
			SetGadgetText( XField, "" )
			SetGadgetText( YField, "" )
			SetGadgetText( WidthField, "" )
			SetGadgetText( HeightField, "" )
		End If
	End Method
	
	
	
	
	
	Method GridSettings()
		Local GridSettingsWindow:TGadget = CreateWindow( "{{W_GridSettings}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( GridSettingsWindow )
		Form.NewLine()
		Local VerticalDivField:TGadget = Form.AddTextField( "{{L_VerticalCellDivision}}", 200 )
		Form.NewLine()
		Local HorizontalDivField:TGadget = Form.AddTextField( "{{L_HorizontalCellDivision}}", 200 )
		Form.NewLine()
		Local ActiveCheckBox:TGadget = Form.AddButton( "{{L_GridActive}}", 120, Button_CheckBox )
		Form.NewLine()
		Local OKButton:TGadget = Form.AddButton( "{{B_OK}}", 80, Button_OK )
		Form.Finalize()
		
		SetGadgetText( VerticalDivField, GridCellXDiv )
		SetGadgetText( HorizontalDivField, GridCellYDiv )
		SetButtonState( ActiveCheckBox, GridActive )
		
		Repeat
			PollEvent()
			Select EventID()
				Case Event_GadgetAction
					Select EventSource()
						Case OKButton
							Local NewCellXDiv:Double = TextFieldText( VerticalDivField ).ToInt()
							Local NewCellYDiv:Double = TextFieldText( HorizontalDivField ).ToInt()
							If NewCellXDiv > 0 And NewCellYDiv > 0 Then
								GridCellXDiv = NewCellXDiv
								GridCellYDiv = NewCellYDiv
								GridActive = ButtonState( ActiveCheckBox )
								Exit
							Else
								Notify( "Cell divisions must be more than 0", True )
							End If
					End Select
				Case Event_WindowClose
					Exit
			End Select
		Forever
		FreeGadget( GridSettingsWindow )
	End Method
End Type






Type TCreateCollisionShape Extends LTDrag
	Field StartingX:Double, StartingY:Double
	Field CollisionShape:LTSprite

	
	
	Method DraggingConditions:Int()
		If Not TileCollisionShapes.CollisionShapeUnderCursor And Not TileCollisionShapes.ResizeCollisionShape.DraggingState Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 2 )
	End Method
	
	
	
	Method StartDragging()
		CollisionShape = New LTSprite
		CollisionShape.Visualizer = Null
		CollisionShape.JumpTo( TileCollisionShapes.Cursor )
		CollisionShape.SetSize( 0.0, 0.0 )
		StartingX = 1.0 * Int( TileCollisionShapes.Cursor.X * TileCollisionShapes.GridCellXDiv ) / TileCollisionShapes.GridCellXDiv
		StartingY = 1.0 * Int( TileCollisionShapes.Cursor.Y * TileCollisionShapes.GridCellYDiv ) / TileCollisionShapes.GridCellYDiv
		
		If TileCollisionShapes.CollisionGroup Then
			TileCollisionShapes.CollisionGroup.AddLast( CollisionShape )
		ElseIf TileCollisionShapes.CollisionShape Then
			Local Group:LTGroup = New LTGroup
			Group.AddLast( TileCollisionShapes.CollisionShape )
			Group.AddLast( CollisionShape )
			TileCollisionShapes.TileSet.CollisionShape[ TileCollisionShapes.TileNum ] = Group
		Else
			TileCollisionShapes.TileSet.CollisionShape[ TileCollisionShapes.TileNum ] = CollisionShape
		End If
		TileCollisionShapes.SelectedCollisionShape = CollisionShape
		
		Editor.SetChanged()
	End Method
	
	
	
	Method Dragging()
		Local CursorX:Double = TileCollisionShapes.Cursor.X
		Local CursorY:Double = TileCollisionShapes.Cursor.Y
		If TileCollisionShapes.GridActive Then
			CursorX = 1.0 * Int( CursorX * TileCollisionShapes.GridCellXDiv ) / TileCollisionShapes.GridCellXDiv
			CursorY = 1.0 * Int( CursorY * TileCollisionShapes.GridCellYDiv ) / TileCollisionShapes.GridCellYDiv
		End If
		CollisionShape.SetSize( Abs( StartingX - CursorX ), Abs( StartingY - CursorY ) )
		CollisionShape.SetCornerCoords( Min( StartingX, CursorX ), Min( StartingY, CursorY ) )
		TileCollisionShapes.RefreshFields()
	End Method
	
	
	
	Method EndDragging()
		If CollisionShape.Width = 0.0 Or CollisionShape.Height = 0.0 Then TileCollisionShapes.DeleteShape()
	End Method
End Type




Type TMoveCollisionShape Extends LTDrag
	Field LeftX:Double, TopY:Double
	Field CollisionShape:LTSprite
	
	
	
	Method DraggingConditions:Int()
		If TileCollisionShapes.CollisionShapeUnderCursor Then Return True
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 1 )
	End Method
	
	
	
	Method StartDragging()
		CollisionShape = TileCollisionShapes.CollisionShapeUnderCursor
		LeftX = CollisionShape.LeftX() - TileCollisionShapes.Cursor.X
		TopY = CollisionShape.TopY() - TileCollisionShapes.Cursor.Y
		TileCollisionShapes.SelectedCollisionShape = CollisionShape
		Editor.SetChanged()
	End Method
	
	
	
	Method Dragging()
		Local NewLeftX:Double = LeftX + TileCollisionShapes.Cursor.X
		Local NewTopY:Double = TopY + TileCollisionShapes.Cursor.Y
		If NewLeftX < 0.0 Then NewLeftX = 0
		If NewTopY < 0.0 Then NewTopY = 0
		If NewLeftX + CollisionShape.Width > 1.0 Then NewLeftX = 1.0 - CollisionShape.Width
		If NewTopY + CollisionShape.Height > 1.0 Then NewTopY = 1.0 - CollisionShape.Height
		If TileCollisionShapes.GridActive Then
			NewLeftX = 1.0 * Int( NewLeftX * TileCollisionShapes.GridCellXDiv ) / TileCollisionShapes.GridCellXDiv
			NewTopY = 1.0 * Int( NewTopY * TileCollisionShapes.GridCellYDiv ) / TileCollisionShapes.GridCellYDiv
		End If
		CollisionShape.SetCornerCoords( NewLeftX, NewTopY )
		TileCollisionShapes.RefreshFields()
	End Method
End Type





Type TResizeCollisionShape Extends LTDrag
	Field DX:Double, DY:Double
	Field CollisionShape:LTSprite
	
	
	
	Method DraggingConditions:Int()
		If TileCollisionShapes.CollisionShapeUnderCursor And Not TileCollisionShapes.CreateCollisionShape.DraggingState Then
			If TileCollisionShapes.CollisionShapeUnderCursor.ShapeType <> LTSprite.Pivot Then Return True
		End If
	End Method
	
	
	
	Method DragKey:Int()
		Return MouseDown( 2 )
	End Method
	
	
	
	Method StartDragging()
		CollisionShape = TileCollisionShapes.CollisionShapeUnderCursor
		DX = CollisionShape.Width - TileCollisionShapes.Cursor.X
		DY = CollisionShape.Height - TileCollisionShapes.Cursor.Y
		TileCollisionShapes.SelectedCollisionShape = CollisionShape
		Editor.SetChanged()
	End Method
	
	
	
	Method Dragging()
		Local NewWidth:Double = L_LimitDouble( DX + TileCollisionShapes.Cursor.X, 0.0, 1.0 )
		Local NewHeight:Double = L_LimitDouble( DY + TileCollisionShapes.Cursor.Y, 0.0, 1.0 )
		If CollisionShape.LeftX() + NewWidth > 1.0 Then NewWidth = 1.0 - CollisionShape.LeftX()
		If CollisionShape.TopY() + NewHeight > 1.0 Then NewHeight = 1.0 - CollisionShape.TopY()
		If TileCollisionShapes.GridActive Then
			NewWidth = 1.0 * Int( NewWidth * TileCollisionShapes.GridCellXDiv ) / TileCollisionShapes.GridCellXDiv
			NewHeight = 1.0 * Int( NewHeight * TileCollisionShapes.GridCellYDiv ) / TileCollisionShapes.GridCellYDiv
		End If
		If CollisionShape.ShapeType = LTSprite.Circle Then
			NewWidth = Min( NewWidth, NewHeight )
			NewHeight = NewWidth
		End If
		CollisionShape.SetCoords( CollisionShape.LeftX() + 0.5 * NewWidth, CollisionShape.TopY() + 0.5 * NewHeight )
		CollisionShape.SetSize( NewWidth, NewHeight )
		TileCollisionShapes.RefreshFields()
	End Method
	
	
	
	Method EndDragging()
		If CollisionShape.Width = 0.0 Or CollisionShape.Height = 0.0 Then TileCollisionShapes.DeleteShape()
	End Method
End Type