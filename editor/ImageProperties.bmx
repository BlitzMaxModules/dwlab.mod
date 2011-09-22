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

Function ImageProperties:Int( Image:LTImage )
	Local RasterFrame:LTRasterFrame = LTRasterFrame( Image )

	Local EditWindow:TGadget = CreateWindow( "{{W_ImageProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( EditWindow )
	Form.NewLine()
	Local XCellsTextField:TGadget = Form.AddTextField( "{{L_HorizontalCellDivision}}", 165 )
	Local YCellsTextField:TGadget = Form.AddTextField( "{{L_VerticalCellDivision}}", 165 )
	Form.NewLine()
	
	Local LeftTextField:TGadget, TopTextField:TGadget, RightTextField:TGadget, BottomTextField:TGadget
	If RasterFrame Then 
		LeftTextField = Form.AddTextField( "{{L_LeftBorder}}", 120 )
		TopTextField = Form.AddTextField( "{{L_TopBorder}}", 120 )
		Form.NewLine()
		RightTextField = Form.AddTextField( "{{L_RightBorder}}", 120 )
		BottomTextField = Form.AddTextField( "{{L_BottomBorder}}", 120 )
		Form.NewLine()
		
		SetGadgetText( LeftTextField, RasterFrame.LeftBorder )
		SetGadgetText( RightTextField, RasterFrame.RightBorder )
		SetGadgetText( TopTextField, RasterFrame.TopBorder )
		SetGadgetText( BottomTextField, RasterFrame.BottomBorder )
	End If
	
	Local ImageCanvas:TGadget = Form.AddCanvas( 480, 480 )
	Form.NewLine()
	Local ReloadImageButton:TGadget = Form.AddButton( "{{B_ReloadImage}}", 200 )
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )

	Local BMaxImage:TImage = TImage( Editor.BigImages.ValueForKey( Image ) )
	If Not BMaxImage Then BMaxImage = Image.BMaxImage
	
	Local Filename:String = Image.Filename
	
	SetGadgetText( XCellsTextField, Image.XCells )
	SetGadgetText( YCellsTextField, Image.YCells )
		
	Repeat
		Editor.Render()
	
		Local XCells:Int = TextFieldText( XCellsTextField ).ToInt()
		Local YCells:Int = TextFieldText( YCellsTextField ).ToInt()
		
		PrintImageToCanvas( BMaxImage, ImageCanvas, XCells, YCells )
		
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case ReloadImageButton
						Filename = RequestFile( LocalizeString( "{{D_SelectImage}}" ), "Image files:png,jpg,bmp" )
						Filename = L_ChopFilename( Filename )
						If Filename Then
							Local LoadedImage:TImage = LoadImage( Filename )
							If LoadedImage Then
								BMaxImage = LoadedImage
							Else
								Notify( LocalizeString( "{{N_CannotLoadImage}}" ) )
							End If
						End If
					Case OKButton
						If XCells > 0 And YCells > 0 Then
							If BMaxImage.Width Mod XCells = 0 And BMaxImage.Height Mod YCells = 0 Then
								If Image.BMaxImage <> BMaxImage Then
									Image.Filename = Filename
									Image.BMaxImage = BMaxImage
									Editor.BigImages.Insert( Image, BMaxImage )
									Editor.RealPathsForImages.Insert( Image, RealPath( Filename ) )
								End If
								Image.XCells = XCells
								Image.YCells = YCells
								Local Error:String = ""
								If RasterFrame Then
									Local LeftBorder:Int = LeftTextField.GetText().ToInt()
									Local RightBorder:Int = RightTextField.GetText().ToInt()
									Local TopBorder:Int = TopTextField.GetText().ToInt()
									Local BottomBorder:Int = BottomTextField.GetText().ToInt()
									If LeftBorder <= 0 Or RightBorder <= 0 Or TopBorder <= 0 Or BottomBorder <= 0 Then Error = "LessThanZero"
									If LeftBorder + RightBorder >= BMaxImage.Width / XCells Or TopBorder + BottomBorder >= BMaxImage.Height / YCells Then
										Error = "BordersAreTooLarge"
									End If
									If Error Then
										Notify( LocalizeString( "{{N_" + Error + "}}" ) )
									Else
										RasterFrame.LeftBorder = LeftBorder
										RasterFrame.RightBorder = RightBorder
										RasterFrame.TopBorder = TopBorder
										RasterFrame.BottomBorder = BottomBorder
									End If
								End If
								
								If Not Error Then
									Image.Init()	
									Editor.SetChanged()
									FreeGadget( EditWindow )
									Return True
								End If
							Else
								Notify( LocalizeString( "{{N_ImageDivideable}}" ), True )
							End If
						Else
							Notify( LocalizeString( "{{N_ParametersMustBeMoreThanZero}}" ), True )
						End If
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	FreeGadget( EditWindow )
	Return False
End Function