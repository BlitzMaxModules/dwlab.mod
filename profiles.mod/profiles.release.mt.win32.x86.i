ModuleInfo "Version: 1.0.0.1"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"
ModuleInfo "History: v1.0.0.1 (14.11.11)"
ModuleInfo "History: &nbsp; &nbsp; Fixed bug in LTScreenResolution.Get()."
ModuleInfo "History: v1.0 (09.10.11)"
ModuleInfo "History: &nbsp; &nbsp; Initial release."
import brl.blitz
import dwlab.frmwork
import maxgui.localization
import maxgui.drivers
import brl.audio
LTProfile^LTObject{
.Name$&
.Score%&
.Language$&
.AudioDriver$&
.VideoDriver$&
.FullScreen%&
.ScreenWidth%&
.ScreenHeight%&
.ColorDepth%&
.Frequency%&
.Keys:TList&
.SoundOn%&
.SoundVolume!&
.MusicOn%&
.MusicVolume!&
.MinGrainSize%&
.GrainXQuantity%&
.MinGrainYQuantity%&
.MaxGrainYQuantity%&
-New%()="_dwlab_profiles_LTProfile_New"
+InitSystem%()="_dwlab_profiles_LTProfile_InitSystem"
+CreateDefault:LTProfile(ProfileTypeID:TTypeID)="_dwlab_profiles_LTProfile_CreateDefault"
+GetLanguage:TMaxGuiLanguage(Name$)="_dwlab_profiles_LTProfile_GetLanguage"
-Apply%(Projects:LTProject&[]="bbEmptyArray",NewScreen%=1,NewVideoDriver%=1,NewAudioDriver%=1,NewLanguage%=1)="_dwlab_profiles_LTProfile_Apply"
-ChangeViewportResolution%(Width%,Height%)="_dwlab_profiles_LTProfile_ChangeViewportResolution"
-InitCamera%(Camera:LTCamera)="_dwlab_profiles_LTProfile_InitCamera"
-Clone:LTProfile()="_dwlab_profiles_LTProfile_Clone"
-Init%()="_dwlab_profiles_LTProfile_Init"
-Reset%()="_dwlab_profiles_LTProfile_Reset"
-Load%()="_dwlab_profiles_LTProfile_Load"
-Save%()="_dwlab_profiles_LTProfile_Save"
-SetAsCurrent%()="_dwlab_profiles_LTProfile_SetAsCurrent"
-XMLIO%(XMLObject:LTXMLObject)="_dwlab_profiles_LTProfile_XMLIO"
}="dwlab_profiles_LTProfile"
L_PlaySound:TChannel(Sound:TSound,Temporary%=1,Volume!=1!,Rate!=1!,Pan!=0!,Depth!=0!)="dwlab_profiles_L_PlaySound"
L_PlayMusic:TChannel(Sound:TSound,Temporary%=1,Volume!=1!,Rate!=1!,Pan!=0!,Depth!=0!)="dwlab_profiles_L_PlayMusic"
L_PlaySoundAndSetParameters:TChannel(Sound:TSound,Rate!=1!,Pan!=0!,Depth!=0!)="dwlab_profiles_L_PlaySoundAndSetParameters"
L_SetSoundVolume%(Channel:TChannel,Volume!)="dwlab_profiles_L_SetSoundVolume"
L_SetMusicVolume%(Channel:TChannel,Volume!)="dwlab_profiles_L_SetMusicVolume"
L_RefreshSounds%()="dwlab_profiles_L_RefreshSounds"
L_ClearSoundMaps%()="dwlab_profiles_L_ClearSoundMaps"
L_UnregisterChannel%(Channel:TChannel)="dwlab_profiles_L_UnregisterChannel"
LTVideoDriver^Object{
.Name$&
.Driver:TMax2DDriver&
-New%()="_dwlab_profiles_LTVideoDriver_New"
+Get:LTVideoDriver(Name$=$"")="_dwlab_profiles_LTVideoDriver_Get"
}="dwlab_profiles_LTVideoDriver"
LTFrequency^Object{
.Hertz%&
-New%()="_dwlab_profiles_LTFrequency_New"
+Add%(ColorDepth:LTColorDepth,Hertz%)="_dwlab_profiles_LTFrequency_Add"
+Get:LTFrequency(ColorDepth:LTColorDepth,Hertz%=0)="_dwlab_profiles_LTFrequency_Get"
}="dwlab_profiles_LTFrequency"
LTColorDepth^Object{
.Bits%&
.Frequencies:TList&
-New%()="_dwlab_profiles_LTColorDepth_New"
+Add%(Resolution:LTScreenResolution,Bits%,Hertz%)="_dwlab_profiles_LTColorDepth_Add"
+Get:LTColorDepth(Resolution:LTScreenResolution,Bits%=0)="_dwlab_profiles_LTColorDepth_Get"
}="dwlab_profiles_LTColorDepth"
LTScreenResolution^Object{
.Width%&
.Height%&
.ColorDepths:TList&
-New%()="_dwlab_profiles_LTScreenResolution_New"
+Add%(Width%,Height%,Bits%,Hertz%)="_dwlab_profiles_LTScreenResolution_Add"
+Get:LTScreenResolution(Width%=0,Height%=0)="_dwlab_profiles_LTScreenResolution_Get"
}="dwlab_profiles_LTScreenResolution"
L_CurrentProfile:LTProfile&=mem:p("dwlab_profiles_L_CurrentProfile")
L_ProjectWindow:TGadget&=mem:p("dwlab_profiles_L_ProjectWindow")
L_ProjectCanvas:TGadget&=mem:p("dwlab_profiles_L_ProjectCanvas")
L_XResolution%&=mem("dwlab_profiles_L_XResolution")
L_YResolution%&=mem("dwlab_profiles_L_YResolution")
L_ViewportCenterX%&=mem("dwlab_profiles_L_ViewportCenterX")
L_ViewportCenterY%&=mem("dwlab_profiles_L_ViewportCenterY")
L_Profiles:TList&=mem:p("dwlab_profiles_L_Profiles")
L_Languages:TList&=mem:p("dwlab_profiles_L_Languages")
L_AudioDrivers:TList&=mem:p("dwlab_profiles_L_AudioDrivers")
L_SoundChannels:TMap&=mem:p("dwlab_profiles_L_SoundChannels")
L_MusicChannels:TMap&=mem:p("dwlab_profiles_L_MusicChannels")
L_ChannelsList:TList&=mem:p("dwlab_profiles_L_ChannelsList")
L_VideoDrivers:TList&=mem:p("dwlab_profiles_L_VideoDrivers")
L_ScreenResolutions:TList&=mem:p("dwlab_profiles_L_ScreenResolutions")
