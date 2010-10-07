SuperStrict

Framework brl.filesystem
Import brl.system
Import brl.retro

Local DirPath:String = RequestDir$( "Select directory to process" )
Local Dir:Int = ReadDir( DirPath )
Local OutFile:TStream = WriteFile( RequestFile( "Select file to write data to", "bmx", True, DirPath ) )
WriteLine( OutFile, "Type TGame Extends TProject" )
Repeat
	Local FileName:String = NextFile( Dir )
	If Not Filename Then Exit
	Select Right( FileName, 4 ).ToLower()
		Case ".ogg", ".wav"
			WriteLine( OutFile, "~tField " + FileName[ ..Len( Filename ) - 4 ] + "Sound:LTSound = LTSound.FromFile( ~q" + Filename + "~q )" )
		Case ".bmp", ".png", ".jpg"
			WriteLine( OutFile, "~tField " + FileName[ ..Len( Filename ) - 4 ] + "Image:LTImage = LTImage.FromFile( ~q" + Filename + "~q )" )
	End Select
Forever

WriteLine( OutFile, "End Type" )
CloseFile( OutFile )