import brl.blitz
import brl.directsoundaudio
LTChannelPack^brl.blitz.Object{
.Channel:brl.audio.TChannel&[]&
.ChannelsQuantity%&
-New%()="_dwlab_sound_LTChannelPack_New"
-Delete%()="_dwlab_sound_LTChannelPack_Delete"
+Create:LTChannelPack(ChannelsQuantity%)="_dwlab_sound_LTChannelPack_Create"
-Play%(Sound:brl.audio.TSound,Volume!=-1!,Rate!=1!)="_dwlab_sound_LTChannelPack_Play"
}="dwlab_sound_LTChannelPack"
