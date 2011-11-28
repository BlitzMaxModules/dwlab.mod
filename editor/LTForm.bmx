
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
		Return AddGadget( Text, 0, L_FieldHeight, Width, 0, LTFormGadget.Label, Style ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds button gadget to the current row of the form.
	returns: Button gadget.
	EndRem
	Method AddButton:TGadget( Text:String, Width:Int, Style:Int = Button_Push )
		Return AddGadget( Text, Width, L_FieldHeight, 0, 0, LTFormGadget.Button, Style ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds canvas to the current row of the form.
	returns: New canvas.
	EndRem
	Method AddCanvas:TGadget( Width:Int, Height:Int )
		Return AddGadget( "", Width, Height, 0, 0, LTFormGadget.Canvas, 0 ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds label with text field gadget to the current row of the form.
	returns: Text field gadget.
	EndRem
	Method AddTextField:TGadget( LabelText:String, LabelWidth:Int, TextFieldWidth:Int = 56, TextFieldStyle:Int = 0 )
		Return AddGadget( LabelText, TextFieldWidth, L_FieldHeight, LabelWidth, 0, LTFormGadget.TextField, TextFieldStyle ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds label with combo box gadget to the current row of the form.
	returns: Combo box gadget.
	EndRem
	Method AddComboBox:TGadget( LabelText:String, LabelWidth:Int, ComboBoxWidth:Int = 56, ComboBoxStyle:Int = 0 )
		Return AddGadget( LabelText, ComboBoxWidth, L_FieldHeight, LabelWidth, 0, LTFormGadget.ComboBox, ComboBoxStyle ).Gadget
	End Method
	
	
	
	Rem
	bbdoc: Adds label with slider and text field gadget to the current row of the form.
	returns: Text field gadget.
	about: Slider gadget will be passed through Slider variable.
	EndRem
	Method AddSliderWidthTextField( Slider:TGadget Var, TextField:TGadget Var, LabelText:String, LabelWidth:Int, SliderWidth:Int = 56, TextFieldWidth:Int = 56, SliderStyle:Int = Slider_Trackbar | Slider_Horizontal )
		Local FormGadget:LTFormGadget = AddGadget( LabelText, TextFieldWidth, L_FieldHeight, LabelWidth, SliderWidth, LTFormGadget.SliderWithTextField, SliderStyle )
		Slider = FormGadget.SliderGadget
		TextField = FormGadget.Gadget
	End Method
	
	
	
	Method AddGadget:LTFormGadget( LabelText:String, Width:Int, Height:Int, LabelWidth:Int, SliderWidth:Int, GadgetType:Int, Style:Int )
		Local FormGadget:LTFormGadget = New LTFormGadget
		If X > Margins Then X :+ HorizontalCellSpacing
		
		If LabelText Then
			Local LabelStyle:Int = Label_Right
			If GadgetType = LTFormGadget.Label Then LabelStyle = Style
			FormGadget.LabelGadget = CreateLabel( LabelText, X, Y, LabelWidth, 16, Gadget, LabelStyle )
			FormGadget.LabelX = X
			FormGadget.LabelY = Y + 0.5 * ( Height - 16 )
			X :+ LabelWidth + L_LabelIndent
		End If
		
		Select GadgetType
			Case LTFormGadget.Button
				FormGadget.Gadget = CreateButton( LabelText, X, Y, Width, Height, Gadget, Style )
			Case LTFormGadget.Canvas
				FormGadget.Gadget = CreateCanvas( X, Y, Width, Height, Gadget, Style )
			Case LTFormGadget.TextField
				FormGadget.Gadget = CreateTextField( X, Y, Width, Height, Gadget, Style )
			Case LTFormGadget.ComboBox
				FormGadget.Gadget = CreateComboBox( X, Y, Width, Height, Gadget, Style	)
			Case LTFormGadget.SliderWithTextField
				FormGadget.SliderGadget = CreateSlider( X, Y, SliderWidth, Height, Gadget, Style )
				SetSliderRange( FormGadget.SliderGadget, 0, 100 )
				FormGadget.SliderX = X
				X :+ SliderWidth + L_LabelIndent
				FormGadget.Gadget = CreateTextField( X, Y, Width, Height, Gadget )
		End Select
		FormGadget.X = X
		FormGadget.Y = Y
		X :+ Width
		
		FormGadget.GadgetType = GadgetType
		CurrentHorizontalList.AddLast( FormGadget )
		CurrentHeight = Max( CurrentHeight, Height )
		Return FormGadget
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
			For Local FormGadget:LTFormGadget = Eachin HorizontalList
				Select HorizontalList.Alignment
					Case LTAlign.ToLeft
						MoveGadgets( FormGadget, 0 )
					Case LTAlign.ToCenter
						MoveGadgets( FormGadget, 0.5 * DWidth )
					Case LTAlign.ToRight
						MoveGadgets( FormGadget, DWidth )
					Case LTAlign.Stretch
						MoveGadgets( FormGadget, Floor( DX ), Floor( DWidth2 ) )
						DX :+ DWidth2
				End Select
			Next
		Next
	End Method
	
	
	
	Method MoveGadgets( FormGadget:LTFormGadget, DX:Int, DWidth:Int = 0 )
		If FormGadget.LabelGadget Then MoveGadget( FormGadget.LabelGadget, FormGadget.LabelX + DX, FormGadget.LabelY )
		If FormGadget.SliderGadget Then 
			MoveGadget( FormGadget.SliderGadget, FormGadget.SliderX + DX, FormGadget.Y, DWidth )
			MoveGadget( FormGadget.Gadget, FormGadget.X + DX + DWidth, FormGadget.Y )
		ElseIf FormGadget.Gadget Then
			MoveGadget( FormGadget.Gadget, FormGadget.X + DX, FormGadget.Y, DWidth )
		End If
	End Method
	
	
	
	Method MoveGadget( Gadget:TGadget, X:Int, Y:Int, DWidth:Int = 0 )
		SetGadgetShape( Gadget, X, Y, Gadget.GetWidth() + DWidth, Gadget.GetHeight() )
	End Method
End Type