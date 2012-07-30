ModuleInfo "Version: 1.0"
ModuleInfo "Author: Matt Merkulov"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Modserver: DWLAB"
import brl.blitz
import dwlab.frmwork
import brl.directsoundaudio
import brl.oggloader
TErrorSoundPlayer^TSoundPlayer{
-New%()="_dwlab_audiodrivers_TErrorSoundPlayer_New"
-Delete%()="_dwlab_audiodrivers_TErrorSoundPlayer_Delete"
-PlayErrorSound%()="_dwlab_audiodrivers_TErrorSoundPlayer_PlayErrorSound"
}="dwlab_audiodrivers_TErrorSoundPlayer"
