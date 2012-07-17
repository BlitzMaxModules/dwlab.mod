ModuleInfo "Version: 1.0.6"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"
ModuleInfo "History: &nbsp; &nbsp; "
ModuleInfo "History: v1.0.6.2 (02.06.12)"
ModuleInfo "History: &nbsp; &nbsp; LTGUIProject is rewritten to correspond changed structure of LTProject class and now contains no duplicated code."
ModuleInfo "History: &nbsp; &nbsp; Slider is converted to the single gadget."
ModuleInfo "History: v1.0.6.1 (01.06.12)"
ModuleInfo "History: &nbsp; &nbsp; Added underlined spaces to parameters' names."
ModuleInfo "History: v1.0.6 (31.05.12)"
ModuleInfo "History: &nbsp; &nbsp; Changed halign/valign parameters to texthalign/textvalign."
ModuleInfo "History: &nbsp; &nbsp; Added OnClose() event method to LTWindow."
ModuleInfo "History: v1.0.5 (30.03.12)"
ModuleInfo "History: &nbsp; &nbsp; Now there's also vertical align parameter (valign), horizontal now 'halign'."
ModuleInfo "History: &nbsp; &nbsp; Added textdx, textdy, textshift label parameters for shifting text from alignment point."
ModuleInfo "History: &nbsp; &nbsp; Added pressingdx, pressingdy, pressingshift label parameters for defining of shifting button contents upon pressing."
ModuleInfo "History: &nbsp; &nbsp; Added textcolor label parameter for specifying text color in hex form."
ModuleInfo "History: v1.0.4.1 (29.12.11)"
ModuleInfo "History: &nbsp; &nbsp; Switched Name and Class parameters in FindWindow() and LoadWindow() methods."
ModuleInfo "History: v1.0.4 (21.11.11)"
ModuleInfo "History: &nbsp; &nbsp; Added multi-line labels support."
ModuleInfo "History: v1.0.3 (14.11.11)"
ModuleInfo "History: &nbsp; &nbsp; Added mouse wheel actions to GUI buttons list."
ModuleInfo "History: &nbsp; &nbsp; Sliders now can be moved by mouse wheel."
ModuleInfo "History: &nbsp; &nbsp; Label icon class is changed to LTSprite."
ModuleInfo "History: v1.0.2 (14.11.11)"
ModuleInfo "History: &nbsp; &nbsp; Added keys flushing while loading or closing window."
ModuleInfo "History: v1.0.1 (12.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Added optional percentage showing to the slider."
ModuleInfo "History: &nbsp; &nbsp; Rewrote gadget positioning in different-sized screens system."
ModuleInfo "History: &nbsp; &nbsp; Added parameter to align top, bottom or center of window bounds to corresponding side of the camera."
ModuleInfo "History: v1.0 (09.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."
import brl.blitz
import dwlab.frmwork
import maxgui.localization
LTGUIProject^LTProject{
.Windows:TList&
.Locked%&
-New%()="_dwlab_gui_LTGUIProject_New"
-LoadWindow:LTWindow(World:LTWorld,Class$=$"",Name$=$"",Add%=1)="_dwlab_gui_LTGUIProject_LoadWindow"
-ReloadWindows%()="_dwlab_gui_LTGUIProject_ReloadWindows"
-FindWindow:LTWindow(Class$=$"",Name$=$"")="_dwlab_gui_LTGUIProject_FindWindow"
-CloseWindow%(Window:LTWindow="bbNullObject")="_dwlab_gui_LTGUIProject_CloseWindow"
-WindowsLogic%()="_dwlab_gui_LTGUIProject_WindowsLogic"
-WindowsRender%()="_dwlab_gui_LTGUIProject_WindowsRender"
}="dwlab_gui_LTGUIProject"
LTWindow^LTLayer{
.World:LTWorld&
.Project:LTGUIProject&
.MouseOver:TMap&
.Modal%&
-New%()="_dwlab_gui_LTWindow_New"
-Draw%()="_dwlab_gui_LTWindow_Draw"
-Act%()="_dwlab_gui_LTWindow_Act"
-OnButtonPress%(Gadget:LTGadget,ButtonAction:LTButtonAction)="_dwlab_gui_LTWindow_OnButtonPress"
-OnButtonUnpress%(Gadget:LTGadget,ButtonAction:LTButtonAction)="_dwlab_gui_LTWindow_OnButtonUnpress"
-OnButtonDown%(Gadget:LTGadget,ButtonAction:LTButtonAction)="_dwlab_gui_LTWindow_OnButtonDown"
-OnButtonUp%(Gadget:LTGadget,ButtonAction:LTButtonAction)="_dwlab_gui_LTWindow_OnButtonUp"
-OnMouseOver%(Gadget:LTGadget)="_dwlab_gui_LTWindow_OnMouseOver"
-OnMouseOut%(Gadget:LTGadget)="_dwlab_gui_LTWindow_OnMouseOut"
-OnClose%()="_dwlab_gui_LTWindow_OnClose"
-Save%()="_dwlab_gui_LTWindow_Save"
-DeInit%()="_dwlab_gui_LTWindow_DeInit"
}="dwlab_gui_LTWindow"
LTCheckBox^LTButton{
-New%()="_dwlab_gui_LTCheckBox_New"
-OnMouseOut%()="_dwlab_gui_LTCheckBox_OnMouseOut"
-OnButtonPress%(ButtonAction:LTButtonAction)="_dwlab_gui_LTCheckBox_OnButtonPress"
-OnButtonDown%(ButtonAction:LTButtonAction)="_dwlab_gui_LTCheckBox_OnButtonDown"
-OnButtonUp%(ButtonAction:LTButtonAction)="_dwlab_gui_LTCheckBox_OnButtonUp"
}="dwlab_gui_LTCheckBox"
LTButton^LTLabel{
.State%&
.Focus%&
.PressingDX!&
.PressingDY!&
-New%()="_dwlab_gui_LTButton_New"
-Init%()="_dwlab_gui_LTButton_Init"
-Draw%()="_dwlab_gui_LTButton_Draw"
-SetFrame%(Sprite:LTSprite)="_dwlab_gui_LTButton_SetFrame"
-GetDX!()="_dwlab_gui_LTButton_GetDX"
-GetDY!()="_dwlab_gui_LTButton_GetDY"
-GetClassTitle$()="_dwlab_gui_LTButton_GetClassTitle"
-OnMouseOver%()="_dwlab_gui_LTButton_OnMouseOver"
-OnMouseOut%()="_dwlab_gui_LTButton_OnMouseOut"
-OnButtonDown%(ButtonAction:LTButtonAction)="_dwlab_gui_LTButton_OnButtonDown"
-OnButtonUp%(ButtonAction:LTButtonAction)="_dwlab_gui_LTButton_OnButtonUp"
}="dwlab_gui_LTButton"
LTLabel^LTGadget{
.Text$&
.Icon:LTSprite&
.IconDX!&
.IconDY!&
.TextVisualizer:LTVisualizer&
.HAlign%&
.VAlign%&
.TextDX!&
.TextDY!&
-New%()="_dwlab_gui_LTLabel_New"
-GetClassTitle$()="_dwlab_gui_LTLabel_GetClassTitle"
-Init%()="_dwlab_gui_LTLabel_Init"
-Draw%()="_dwlab_gui_LTLabel_Draw"
-GetDX!()="_dwlab_gui_LTLabel_GetDX"
-GetDY!()="_dwlab_gui_LTLabel_GetDY"
-Activate%()="_dwlab_gui_LTLabel_Activate"
-Deactivate%()="_dwlab_gui_LTLabel_Deactivate"
}="dwlab_gui_LTLabel"
LTTextField^LTGadget{
.Text$&
.LeftPart$&
.RightPart$&
.MaxSymbols%&
-New%()="_dwlab_gui_LTTextField_New"
-Init%()="_dwlab_gui_LTTextField_Init"
-Draw%()="_dwlab_gui_LTTextField_Draw"
-GetClassTitle$()="_dwlab_gui_LTTextField_GetClassTitle"
-OnButtonPress%(ButtonAction:LTButtonAction)="_dwlab_gui_LTTextField_OnButtonPress"
}="dwlab_gui_LTTextField"
LTListBox^LTGadget{
.ListType%&
.Items:TList&
.ItemSize!&
.Shift!&
-New%()="_dwlab_gui_LTListBox_New"
-GetClassTitle$()="_dwlab_gui_LTListBox_GetClassTitle"
-Init%()="_dwlab_gui_LTListBox_Init"
-Draw%()="_dwlab_gui_LTListBox_Draw"
-GetItemSprite:LTSprite(Num%)="_dwlab_gui_LTListBox_GetItemSprite"
-DrawItem%(Item:Object,Num%,Sprite:LTSprite)="_dwlab_gui_LTListBox_DrawItem"
-OnButtonPress%(ButtonAction:LTButtonAction)="_dwlab_gui_LTListBox_OnButtonPress"
-OnButtonPressOnItem%(ButtonAction:LTButtonAction,Item:Object,Num%)="_dwlab_gui_LTListBox_OnButtonPressOnItem"
}="dwlab_gui_LTListBox"
LTSlider^LTGadget{
Moving%=0
Filling%=1
.Position!&
.Size!&
.SliderType%&
.SelectionType%&
.MouseWheelValue!&
.ListBox:LTListBox&
.Slider:LTSprite&
.Dragging%&
.StartingX!&
.StartingY!&
.StartingPosition!&
.ListBoxSize!&
.ContentsSize!&
.ShowPercent%&
-New%()="_dwlab_gui_LTSlider_New"
-GetClassTitle$()="_dwlab_gui_LTSlider_GetClassTitle"
-Init%()="_dwlab_gui_LTSlider_Init"
-Draw%()="_dwlab_gui_LTSlider_Draw"
-Act%()="_dwlab_gui_LTSlider_Act"
-OnButtonDown%(ButtonAction:LTButtonAction)="_dwlab_gui_LTSlider_OnButtonDown"
-OnButtonUnpress%(ButtonAction:LTButtonAction)="_dwlab_gui_LTSlider_OnButtonUnpress"
}="dwlab_gui_LTSlider"
LTGadget^LTSprite{
Horizontal%=0
Vertical%=1
.TextSize!&
-New%()="_dwlab_gui_LTGadget_New"
-Init%()="_dwlab_gui_LTGadget_Init"
-OnButtonPress%(ButtonAction:LTButtonAction)="_dwlab_gui_LTGadget_OnButtonPress"
-OnButtonUnpress%(ButtonAction:LTButtonAction)="_dwlab_gui_LTGadget_OnButtonUnpress"
-OnButtonDown%(ButtonAction:LTButtonAction)="_dwlab_gui_LTGadget_OnButtonDown"
-OnButtonUp%(ButtonAction:LTButtonAction)="_dwlab_gui_LTGadget_OnButtonUp"
-OnMouseOver%()="_dwlab_gui_LTGadget_OnMouseOver"
-OnMouseOut%()="_dwlab_gui_LTGadget_OnMouseOut"
}="dwlab_gui_LTGadget"
L_Window:LTWindow&=mem:p("dwlab_gui_L_Window")
L_ActiveTextField:LTTextField&=mem:p("dwlab_gui_L_ActiveTextField")
L_GUICamera:LTCamera&=mem:p("dwlab_gui_L_GUICamera")
L_TextSize!&=mem:d("dwlab_gui_L_TextSize")
L_LeftMouseButton:LTButtonAction&=mem:p("dwlab_gui_L_LeftMouseButton")
L_RightMouseButton:LTButtonAction&=mem:p("dwlab_gui_L_RightMouseButton")
L_MiddleMouseButton:LTButtonAction&=mem:p("dwlab_gui_L_MiddleMouseButton")
L_MouseWheelDown:LTButtonAction&=mem:p("dwlab_gui_L_MouseWheelDown")
L_MouseWheelUp:LTButtonAction&=mem:p("dwlab_gui_L_MouseWheelUp")
L_Enter:LTButtonAction&=mem:p("dwlab_gui_L_Enter")
L_Esc:LTButtonAction&=mem:p("dwlab_gui_L_Esc")
L_CharacterLeft:LTButtonAction&=mem:p("dwlab_gui_L_CharacterLeft")
L_CharacterRight:LTButtonAction&=mem:p("dwlab_gui_L_CharacterRight")
L_DeletePreviousCharacter:LTButtonAction&=mem:p("dwlab_gui_L_DeletePreviousCharacter")
L_DeleteNextCharacter:LTButtonAction&=mem:p("dwlab_gui_L_DeleteNextCharacter")
L_GUIButtons:TList&=mem:p("dwlab_gui_L_GUIButtons")
