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
LTProfile^dwlab.frmwork.LTObject{
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
.Keys:brl.linkedlist.TList&
.SoundOn%&
.SoundVolume!&
.MusicOn%&
.MusicVolume!&
-New%()="_dwlab_profiles_LTProfile_New"
-Delete%()="_dwlab_profiles_LTProfile_Delete"
+InitSystem%()="_dwlab_profiles_LTProfile_InitSystem"
+CreateDefault:LTProfile(ProfileTypeID:brl.reflection.TTypeID)="_dwlab_profiles_LTProfile_CreateDefault"
+GetLanguage:maxgui.localization.TMaxGuiLanguage(Name$)="_dwlab_profiles_LTProfile_GetLanguage"
-Apply%(Projects:dwlab.frmwork.LTProject&[]="bbEmptyArray",NewScreen%=1,NewVideoDriver%=1,NewAudioDriver%=1,NewLanguage%=1)="_dwlab_profiles_LTProfile_Apply"
-InitCamera%(Camera:dwlab.frmwork.LTCamera)="_dwlab_profiles_LTProfile_InitCamera"
-Clone:LTProfile()="_dwlab_profiles_LTProfile_Clone"
-Init%()="_dwlab_profiles_LTProfile_Init"
-Reset%()="_dwlab_profiles_LTProfile_Reset"
-Load%()="_dwlab_profiles_LTProfile_Load"
-Save%()="_dwlab_profiles_LTProfile_Save"
-XMLIO%(XMLObject:dwlab.frmwork.LTXMLObject)="_dwlab_profiles_LTProfile_XMLIO"
}="dwlab_profiles_LTProfile"
L_PlaySound:brl.audio.TChannel(Sound:brl.audio.TSound,Temporary%=1,Volume!=1!,Rate!=1!,Pan!=0!,Depth!=0!)="dwlab_profiles_L_PlaySound"
L_PlayMusic:brl.audio.TChannel(Sound:brl.audio.TSound,Temporary%=1,Volume!=1!,Rate!=1!,Pan!=0!,Depth!=0!)="dwlab_profiles_L_PlayMusic"
L_PlaySoundAndSetParameters:brl.audio.TChannel(Sound:brl.audio.TSound,Rate!=1!,Pan!=0!,Depth!=0!)="dwlab_profiles_L_PlaySoundAndSetParameters"
L_SetSoundVolume%(Channel:brl.audio.TChannel,Volume!)="dwlab_profiles_L_SetSoundVolume"
L_SetMusicVolume%(Channel:brl.audio.TChannel,Volume!)="dwlab_profiles_L_SetMusicVolume"
L_RefreshSounds%()="dwlab_profiles_L_RefreshSounds"
L_ClearSoundMaps%()="dwlab_profiles_L_ClearSoundMaps"
L_UnregisterChannel%(Channel:brl.audio.TChannel)="dwlab_profiles_L_UnregisterChannel"
LTVideoDriver^brl.blitz.Object{
.Name$&
.Driver:brl.max2d.TMax2DDriver&
-New%()="_dwlab_profiles_LTVideoDriver_New"
-Delete%()="_dwlab_profiles_LTVideoDriver_Delete"
+Get:LTVideoDriver(Name$=$"")="_dwlab_profiles_LTVideoDriver_Get"
}="dwlab_profiles_LTVideoDriver"
LTFrequency^brl.blitz.Object{
.Hertz%&
-New%()="_dwlab_profiles_LTFrequency_New"
-Delete%()="_dwlab_profiles_LTFrequency_Delete"
+Add%(ColorDepth:LTColorDepth,Hertz%)="_dwlab_profiles_LTFrequency_Add"
+Get:LTFrequency(ColorDepth:LTColorDepth,Hertz%=0)="_dwlab_profiles_LTFrequency_Get"
}="dwlab_profiles_LTFrequency"
LTColorDepth^brl.blitz.Object{
.Bits%&
.Frequencies:brl.linkedlist.TList&
-New%()="_dwlab_profiles_LTColorDepth_New"
-Delete%()="_dwlab_profiles_LTColorDepth_Delete"
+Add%(Resolution:LTScreenResolution,Bits%,Hertz%)="_dwlab_profiles_LTColorDepth_Add"
+Get:LTColorDepth(Resolution:LTScreenResolution,Bits%=0)="_dwlab_profiles_LTColorDepth_Get"
}="dwlab_profiles_LTColorDepth"
LTScreenResolution^brl.blitz.Object{
.Width%&
.Height%&
.ColorDepths:brl.linkedlist.TList&
-New%()="_dwlab_profiles_LTScreenResolution_New"
-Delete%()="_dwlab_profiles_LTScreenResolution_Delete"
+Add%(Width%,Height%,Bits%,Hertz%)="_dwlab_profiles_LTScreenResolution_Add"
+Get:LTScreenResolution(Width%=0,Height%=0)="_dwlab_profiles_LTScreenResolution_Get"
}="dwlab_profiles_LTScreenResolution"
L_CurrentProfile:LTProfile&=mem:p("dwlab_profiles_L_CurrentProfile")
L_ProjectWindow:maxgui.maxgui.TGadget&=mem:p("dwlab_profiles_L_ProjectWindow")
L_CameraWidth!&=mem:d("dwlab_profiles_L_CameraWidth")
L_Profiles:brl.linkedlist.TList&=mem:p("dwlab_profiles_L_Profiles")
L_Languages:brl.linkedlist.TList&=mem:p("dwlab_profiles_L_Languages")
L_AudioDrivers:brl.linkedlist.TList&=mem:p("dwlab_profiles_L_AudioDrivers")
L_SoundChannels:brl.map.TMap&=mem:p("dwlab_profiles_L_SoundChannels")
L_MusicChannels:brl.map.TMap&=mem:p("dwlab_profiles_L_MusicChannels")
L_ChannelsList:brl.linkedlist.TList&=mem:p("dwlab_profiles_L_ChannelsList")
L_VideoDrivers:brl.linkedlist.TList&=mem:p("dwlab_profiles_L_VideoDrivers")
L_ScreenResolutions:brl.linkedlist.TList&=mem:p("dwlab_profiles_L_ScreenResolutions")
