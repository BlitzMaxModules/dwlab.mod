SuperStrict

Framework brl.basic

Import dwlab.frmwork
Import brl.bmploader
Import brl.pngloader

L_InitGraphics( 1024, 1000 )
SetClsColor 0, 4, 8

Global X:Int
Global Y:Int

AddPack( "blanks" )
AddPack( "cultivat" )
AddPack( "barn" )
AddPack( "plane" )
AddPack( "u_ext02" )
AddPack( "u_wall02" )
AddPack( "u_disec2" )
AddPack( "u_bits" )
AddPack( "ufo1" )
Save( "farm" )

AddPack( "blanks" )
AddPack( "roads" )
AddPack( "urbits" )
AddPack( "urban" )
AddPack( "frnture" )
AddPack( "lightnin" )
AddPack( "u_ext02" )
AddPack( "u_wall02" )
AddPack( "u_oper2" )
AddPack( "u_bits" )
Save( "city" )

AddPack( "blanks" )
AddPack( "forest" )
AddPack( "avenger" )
AddPack( "u_ext02" )
AddPack( "u_wall02" )
AddPack( "u_disec2" )
AddPack( "u_bits" )
Save( "forest" )


'[ "avenger", "barn", "cultivat", "desert", "forest", "frniture", "jungle", "lightnin", "mount", "plane", "polar", "roads", "ufo1", "urban", "urbits" ]

Function AddPack( Prefix:String )	
	DebugLog( Prefix + ": " + ( X / 32 + Y / 10 ) )
	Local Digits:Int = 1
	If FileType( Prefix + "00.bmp" ) = 1 Then Digits = 2
	If FileType( Prefix + "000.bmp" ) = 1 Then Digits = 3
	Local N:Int = 0
	Repeat
		Local FileName:String = Prefix + L_FirstZeroes( N, Digits ) + ".bmp"
		If Not FileType( FileName ) Then N:+1; Continue
		
		DrawImage( LoadImage( FileName ), X, Y )
		
		X :+ 32
		If X = 512 Then
			X = 0
			Y :+ 40
		End If
		N :+ 1
	Until N >= 10 ^ Digits
End Function	



Function Save( Name:String )
	Flip
	SavePixmapPNG( MaskPixmap( GrabPixmap( 0, 0, 512, Y + 40 * ( X > 0 ) ), 0, 4, 8 ), Name + ".png", 9 )
	Cls
	X = 0
	Y = 0
End Function