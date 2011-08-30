'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Global SpriteMapProperties:TSpriteMapProperties = New TSpriteMapProperties
Type TSpriteMapProperties Extends LTProject
	Field SpriteMap:LTSpriteMap
	Field Succeeded:Int
	
	Field EditWindow:TGadget
	Field XQuantityTextField:TGadget
	Field YQuantityTextField:TGadget
	Field CellWidthTextField:TGadget
	Field CellHeightTextField:TGadget
	Field LeftMarginTextField:TGadget
	Field TopMarginTextField:TGadget
	Field RightMarginTextField:TGadget
	Field BottomMarginTextField:TGadget
	Field SortedCheckBox:TGadget
	Field PivotModeCheckBox:TGadget
	Field OKButton:TGadget, CancelButton:TGadget
	
	
	
	Method Init()
		EditWindow = CreateWindow( "{{W_SpriteMapProperties}}", 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( EditWindow )
		Form.NewLine()
		XQuantityTextField = Form.AddTextField( "{{L_HorizontalCells}}", 165 )
		YQuantityTextField = Form.AddTextField( "{{L_VerticalCells}}", 165 )
		Form.NewLine()
		CellWidthTextField = Form.AddTextField( "{{L_CellWidth}}", 165 )
		CellHeightTextField = Form.AddTextField( "{{L_CellHeight}}", 165 )
		Form.NewLine()
		LeftMarginTextField = Form.AddTextField( "{{L_LeftMargin}}", 165 )
		TopMarginTextField = Form.AddTextField( "{{L_TopMargin}}", 165 )
		Form.NewLine()
		RightMarginTextField = Form.AddTextField( "{{L_RightMargin}}", 165 )
		BottomMarginTextField = Form.AddTextField( "{{L_BottomMargin}}", 165 )
		Form.NewLine()
		SortedCheckBox = Form.AddButton( "{{L_Sorted}}", 250, Button_CheckBox )
		Form.NewLine()
		PivotModeCheckBox = Form.AddButton( "{{L_PivotMode}}", 250, Button_CheckBox )
		AddOKCancelButtons( Form, OKButton, CancelButton )
	
		SetGadgetText( XQuantityTextField, SpriteMap.XQuantity )
		SetGadgetText( YQuantityTextField, SpriteMap.YQuantity )
		SetGadgetText( CellWidthTextField, L_TrimDouble( SpriteMap.CellWidth ) )
		SetGadgetText( CellHeightTextField, L_TrimDouble( SpriteMap.CellHeight ) )
		SetGadgetText( LeftMarginTextField, L_TrimDouble( SpriteMap.LeftMargin ) )
		SetGadgetText( TopMarginTextField, L_TrimDouble( SpriteMap.TopMargin ) )
		SetGadgetText( RightMarginTextField, L_TrimDouble( SpriteMap.RightMargin ) )
		SetGadgetText( BottomMarginTextField, L_TrimDouble( SpriteMap.BottomMargin ) )
		SetButtonState( SortedCheckBox, SpriteMap.Sorted )
		SetButtonState( PivotModeCheckBox, SpriteMap.PivotMode )
		
		Succeeded = False
	End Method
	
	
	
	Method Logic()
		PollEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton
						Local XQuantity:Int = L_ToPowerOf2( TextFieldText( XQuantityTextField ).ToInt() )
						Local YQuantity:Int = L_ToPowerOf2( TextFieldText( YQuantityTextField ).ToInt() )
						
						Local CellWidth:Double = TextFieldText( CellWidthTextField ).ToDouble()
						Local CellHeight:Double = TextFieldText( CellHeightTextField ).ToDouble()
						
						Local Sorted:Int = ButtonState( SortedCheckBox )
						Local PivotMode:Int = ButtonState( PivotModeCheckBox )

						if CellWidth > 0.0 And CellHeight > 0.0 Then
							If SpriteMap.XQuantity <> XQuantity Or SpriteMap.YQuantity <> YQuantity Or SpriteMap.CellWidth <> CellWidth..
									Or SpriteMap.CellHeight <> CellHeight Or SpriteMap.Sorted <> Sorted Or SpriteMap.PivotMode <> PivotMode Then
								Local Sprites:TMap = SpriteMap.GetSprites()
								SpriteMap.SetResolution( XQuantity, YQuantity )
								SpriteMap.CellWidth = CellWidth
								SpriteMap.CellHeight = CellHeight
								SpriteMap.Sorted = Sorted
								SpriteMap.PivotMode = PivotMode
								
								SpriteMap.Clear()
								For Local Sprite:LTSprite = Eachin Sprites.Keys()
									SpriteMap.InsertSprite( Sprite )
								Next
							End If
							
							SpriteMap.LeftMargin = TextFieldText( LeftMarginTextField ).ToDouble()
							SpriteMap.TopMargin = TextFieldText( TopMarginTextField ).ToDouble()
							SpriteMap.RightMargin = TextFieldText( RightMarginTextField ).ToDouble()
							SpriteMap.BottomMargin = TextFieldText( BottomMarginTextField ).ToDouble()
							
							Exiting = True
							Succeeded = True
						Else
							Notify( LocalizeString( "{{N_CellSizeMoreThanZero}}" ) );
						End If
					Case CancelButton
						Exiting = True
				End Select
			Case Event_WindowClose
				Exiting = True
		End Select
	End Method
	
	
	
	Method DeInit()
		FreeGadget( EditWindow )
	End Method
	
	
	
	Method Set:Int( NewSpriteMap:LTSpriteMap )
		SpriteMap = NewSpriteMap
		Execute()
		Return Succeeded
	End Method
End Type