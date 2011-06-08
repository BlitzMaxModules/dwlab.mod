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

Function SelectTileset( TileMap:LTTileMap )
	Local Window:TGadget = CreateWindow( "{{W_SelectTileset}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
	Local Form:LTForm = LTForm.Create( Window )
	Form.NewLine()
	Local TilesetComboBox:TGadget = Form.AddComboBox( "{{L_Tileset}}", 84, 150 )
	Local AddImageButton:TGadget = Form.AddButton( "{{B_Add}}", 64 )
	Local ModifyImageButton:TGadget = Form.AddButton( "{{B_Modify}}", 64 )
	Local RemoveImageButton:TGadget = Form.AddButton( "{{B_Remove}}", 64 )
	Form.NewLine()
	Local TilesetCanvas:TGadget = Form.AddCanvas( 480, 480 )
	Form.NewLine()
	Local OKButton:TGadget, CancelButton:TGadget
	AddOKCancelButtons( Form, OKButton, CancelButton )

	Repeat
		SetGraphics( CanvasGraphics( TilesetCanvas ) )
		Flip( False )
		SetGraphics( CanvasGraphics( Editor.MainCanvas ) )
	
		WaitEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Exit
					Case CancelButton
						Exit
				End Select
			Case Event_WindowClose
				Exit
		End Select
	Forever
	FreeGadget( Window )
End Function