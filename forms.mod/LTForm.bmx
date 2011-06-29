
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: Space between label and field in pixels
EndRem
Global L_LabelIndent:Int = 3

Rem
bbdoc: Field height in pixels.
EndRem
Global L_FieldHeight:Int = 22

Rem
bbdoc: Form constructor class.
EndRem
Type LTForm
	Field Gadget:TGadget
	Field Margins:Int
	Field HorizontalCellSpacing:Int
	Field VerticalCellSpacing:Int
	Field VerticalList:TList = New TList
	
	Field CurrentHorizontalList:LTHorizontalList
	Field MaxWidth:Int
	Field CurrentHeight:Int
	Field X:Int, Y:Int

	
	
	Rem
	bbdoc: Creates new form with specified window/panel, margins and spacing.
	returns: New form.
	EndRem
	Function Create:LTForm( Gadget:TGadget, Margins:Int = 8, HorizontalCellSpacing:Int = 8, VerticalCellSpacing:Int = 8 )
		Local Form:LTForm = New LTForm
		Form.Gadget = Gadget
		Form.Margins = Margins
		Form.HorizontalCellSpacing = HorizontalCellSpacing
		Form.VerticalCellSpacing = VerticalCellSpacing
		Form.Y = Margins
		Return Form
	End Function
	
	
	
	Rem
	bbdoc: Adds new row of gadgets with specifield alignment to the form.
	EndRem
	Method NewLine( Alignment:Int = LTAlign.ToCenter )
		If CurrentHorizontalList Then
			CurrentHorizontalList.TotalWidth = X - Margins
			Y :+ CurrentHeight + VerticalCellSpacing
			MaxWidth = Max( MaxWidth, CurrentHorizontalList.TotalWidth )
			VerticalList.AddLast( CurrentHorizontalList )
		End If
		X = Margins
		CurrentHeight = 0
		CurrentHorizontalList = New LTHorizontalList
		CurrentHorizontalList.Alignment = Alignment
	End Method
	
	
	
	Rem
	bbdoc: Adds label gadget to the current row of the form.
	returns: Label gadget.
	EndRem
	Method AddLabel:TGadget( Text:String, Width:Int, Style:Int = Label_Right )
		Return AddGadget( Text, 0, L_FieldHeight, Width, 0, LTGadget.Label, Style ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds button gadget to the current row of the form.
	returns: Button gadget.
	EndRem
	Method AddButton:TGadget( Text:String, Width:Int, Style:Int = Button_Push )
		Return AddGadget( Text, Width, L_FieldHeight, 0, 0, LTGadget.Button, Style ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds canvas to the current row of the form.
	returns: New canvas.
	EndRem
	Method AddCanvas:TGadget( Width:Int, Height:Int )
		Return AddGadget( "", Width, Height, 0, 0, LTGadget.Canvas, 0 ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds label with text field gadget to the current row of the form.
	returns: Text field gadget.
	EndRem
	Method AddTextField:TGadget( LabelText:String, LabelWidth:Int, TextFieldWidth:Int = 56, TextFieldStyle:Int = 0 )
		Return AddGadget( LabelText, TextFieldWidth, L_FieldHeight, LabelWidth, 0, LTGadget.TextField, TextFieldStyle ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds label with combo box gadget to the current row of the form.
	returns: Combo box gadget.
	EndRem
	Method AddComboBox:TGadget( LabelText:String, LabelWidth:Int, ComboBoxWidth:Int = 56, ComboBoxStyle:Int = 0 )
		Return AddGadget( LabelText, ComboBoxWidth, L_FieldHeight, LabelWidth, 0, LTGadget.ComboBox, ComboBoxStyle ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds label with slider and text field gadget to the current row of the form.
	returns: Text field gadget.
	about: Slider gadget will be passed through Slider variable.
	EndRem
	Method AddSliderWidthTextField( Slider:TGadget Var, TextField:TGadget Var, LabelText:String, LabelWidth:Int, SliderWidth:Int = 56, TextFieldWidth:Int = 56, SliderStyle:Int = Slider_Trackbar | Slider_Horizontal )
		Local LabGadget:LTGadget = AddGadget( LabelText, TextFieldWidth, L_FieldHeight, LabelWidth, SliderWidth, LTGadget.SliderWithTextField, SliderStyle )
		Slider = LabGadget.SliderGadget
		TextField = LabGadget.Gadget
	End Method
	
	
	
	Method AddGadget:LTGadget( LabelText:String, Width:Int, Height:Int, LabelWidth:Int, SliderWidth:Int, GadgetType:Int, Style:Int )
		Local LabGadget:LTGadget = New LTGadget
		If X > Margins Then X :+ HorizontalCellSpacing
		
		If LabelText Then
			Local LabelStyle:Int = Label_Right
			If GadgetType = LTGadget.Label Then LabelStyle = Style
			LabGadget.LabelGadget = CreateLabel( LabelText, X, Y, LabelWidth, 16, Gadget, LabelStyle )
			LabGadget.LabelX = X
			LabGadget.LabelY = Y + 0.5 * ( Height - 16 )
			X :+ LabelWidth + L_LabelIndent
		End If
		
		Select GadgetType
			Case LTGadget.Button
				LabGadget.Gadget = CreateButton( LabelText, X, Y, Width, Height, Gadget, Style )
			Case LTGadget.Canvas
				LabGadget.Gadget = CreateCanvas( X, Y, Width, Height, Gadget, Style )
			Case LTGadget.TextField
				LabGadget.Gadget = CreateTextField( X, Y, Width, Height, Gadget, Style )
			Case LTGadget.ComboBox
				LabGadget.Gadget = CreateComboBox( X, Y, Width, Height, Gadget, Style	)
			Case LTGadget.SliderWithTextField
				LabGadget.SliderGadget = CreateSlider( X, Y, SliderWidth, Height, Gadget, Style )
				SetSliderRange( LabGadget.SliderGadget, 0, 100 )
				LabGadget.SliderX = X
				X :+ SliderWidth + L_LabelIndent
				LabGadget.Gadget = CreateTextField( X, Y, Width, Height, Gadget )
		End Select
		LabGadget.X = X
		LabGadget.Y = Y
		X :+ Width
		
		LabGadget.GadgetType = GadgetType
		CurrentHorizontalList.AddLast( LabGadget )
		CurrentHeight = Max( CurrentHeight, Height )
		Return LabGadget
	End Method
	
	
	
	Rem
	bbdoc: Finalizes the form.
	about: Execute this method after finishing adding gadgets to the form. They will be moved and aligned.
	You can specify form shift and center flag (if it will be set to True then form window will be centered relative to the screen.
	EndRem
	Method Finalize( Center:Int = True, FormDX:Int = 0, FormDY:Int = 0 )
		NewLine()
		Local Width:Int = Margins * 2 + MaxWidth + FormDX
		Local Height:Int = Y + FormDY
		If Center Then
			SetGadgetShape( Gadget, 0.5 * ( ClientWidth( Desktop() ) - Width ), 0.5 * ( ClientHeight( Desktop() ) - Height ), Width, Height )
		Else
			SetGadgetShape( Gadget, Gadget.GetXPos(), Gadget.GetYPos(), Width, Height )
		End If
		
		For Local HorizontalList:LTHorizontalList = Eachin VerticalList
			Local DWidth:Int = MaxWidth - HorizontalList.TotalWidth
			Local DWidth2:Double = 1.0 * DWidth / HorizontalList.Count()
			Local DX:Double = 0
			For Local LabGadget:LTGadget = Eachin HorizontalList
				Select HorizontalList.Alignment
					Case LTAlign.ToLeft
						MoveGadgets( LabGadget, 0 )
					Case LTAlign.ToCenter
						MoveGadgets( LabGadget, 0.5 * DWidth )
					Case LTAlign.ToRight
						MoveGadgets( LabGadget, DWidth )
					Case LTAlign.Stretch
						MoveGadgets( LabGadget, Floor( DX ), Floor( DWidth2 ) )
						DX :+ DWidth2
				End Select
			Next
		Next
	End Method
	
	
	
	Method MoveGadgets( LabGadget:LTGadget, DX:Int, DWidth:Int = 0 )
		If LabGadget.LabelGadget Then MoveGadget( LabGadget.LabelGadget, LabGadget.LabelX + DX, LabGadget.LabelY )
		If LabGadget.SliderGadget Then 
			MoveGadget( LabGadget.SliderGadget, LabGadget.SliderX + DX, LabGadget.Y, DWidth )
			MoveGadget( LabGadget.Gadget, LabGadget.X + DX + DWidth, LabGadget.Y )
		ElseIf LabGadget.Gadget Then
			MoveGadget( LabGadget.Gadget, LabGadget.X + DX, LabGadget.Y, DWidth )
		End If
	End Method
	
	
	
	Method MoveGadget( Gadget:TGadget, X:Int, Y:Int, DWidth:Int = 0 )
		SetGadgetShape( Gadget, X, Y, Gadget.GetWidth() + DWidth, Gadget.GetHeight() )
	End Method
End Type