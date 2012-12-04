'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type TAddTemplate Extends LTProject
	Global Instance:TAddTemplate = New TAddTemplate

	Field Window:TGadget
	Field StringField:TGadget
	Field ReplaceButton:TGadget
	Field SelectionField:TGadget
	Field OKButton:TGadget, CancelButton:TGadget
	
	
	
	Method Init()
		Window = CreateWindow( LocalizeString( "{{Add template}}" ), 0, 0, 0, 0, Editor.Window, Window_Titlebar | Window_ClientCoords )
		Local Form:LTForm = LTForm.Create( Window )
		Form.NewLine()
		StringField = Form.AddTextField( "Name", 50, 300 )
		ActivateGadget( StringField )
		Form.NewLine()
		ReplaceButton = Form.AddButton( "Replace template", 150 )
		SelectionField = Form.AddComboBox( "", 0, 150 )
		AddOKCancelButtons( Form, OKButton, CancelButton )
	End Method
	
	
	
	Method OnEvent()
		Select EventID()
			Case Event_GadgetAction
				Select EventSource()
					Case OKButton, ReplaceButton
						Local Template:LTSpriteTemplate = LTSpriteTemplate.FromSprites( Editor.SelectedShapes, Editor.World, , ..
								LTSprite.InsteadOf )
						If Template Then
							If EventSource() = OKButton Then
								Local Name:String = GadgetText( StringField )
								If Name Then
									Template.Name = Name
									L_EditorData.ShapeTypes.AddLast( Template )
								End If
							Else
								Local ExistentTemplate:LTSpriteTemplate = LTSpriteTemplate( GadgetItemExtra( SelectionField, ..
										SelectedGadgetItem( SelectionField ) ) )
								If ExistentTemplate Then
									ExistentTemplate.Sprites = Template.Sprites
								Else
									Return
								End If
							End If
							Editor.RefreshProjectManager()
							Editor.SetChanged()
						End If
						Exiting = True
					Case CancelButton
						Exiting = True
				End Select
		End Select
	End Method
	
	
	
	Method Render()
		Editor.Render()
	End Method
	
	
	
	Method DeInit()
		FreeGadget( Window )
	End Method
End Type
