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
	Local EditWindow:TGadget = CreateWindow( "{{W_ImageProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( EditWindow )
	Form.NewLine()
	Local XCellsTextField:TGadget = Form.AddTextField( "{{L_HorizontalCellDivision}}", 165 )
	Local YCellsTextField:TGadget = Form.AddTextField( "{{L_VerticalCellDivision}}", 165 )
	Form.NewLine()
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
								Image.Init()
								Editor.SetChanged()
								FreeGadget( EditWindow )
								Return True
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