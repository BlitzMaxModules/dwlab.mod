SuperStrict

Framework brl.basic

Import dwlab.frmwork
Import brl.bmploader
Import brl.pngloader

L_InitGraphics( 1024, 1000 )
SetClsColor 4, 4, 12
Cls

Global X:Int
Global Y:Int
Global Num:Int

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
AddPack( "frniture" )
AddPack( "lightnin" )
AddPack( "u_ext02" )
AddPack( "u_wall02" )
AddPack( "u_oper2" )
AddPack( "u_bits" )
Save( "city" )

AddPack( "blanks" )
AddPack( "jungle" )
AddPack( "avenger" )
AddPack( "u_ext02" )
AddPack( "u_wall02" )
AddPack( "u_disec2" )
AddPack( "u_bits" )
Save( "jungle" )


'[ "avenger", "barn", "cultivat", "desert", "forest", "frniture", "jungle", "lightnin", "mount", "plane", "polar", "roads", "ufo1", "urban", "urbits" ]

Function AddPack( Prefix:String )	
	DebugLog( Prefix + ": " + Num )
	Local Digits:Int = 1
	If FileType( Prefix + "00.bmp" ) = 1 Then Digits = 2
	If FileType( Prefix + "000.bmp" ) = 1 Then Digits = 3
	Local N:Int = 0
	Repeat
		Local FileName:String = Prefix + L_FirstZeroes( N, Digits ) + ".bmp"
		If Not FileType( FileName ) Then N :+ 1; Continue
		
		Select Filename.ToLower() 
			Case "lightnin43.bmp"
				DrawImage( LoadImage( "lightnin42.bmp" ), X, Y - 12 )
			Case "avenger61.bmp", "plane62.bmp"
				DrawImage( LoadImage( "avenger61.bmp" ), X, Y - 16 )
			Case "avenger62.bmp", "plane63.bmp"
				DrawImage( LoadImage( "avenger61.bmp" ), X, Y - 8 )
			Case "avenger63.bmp", "plane64.bmp"
				DrawImage( LoadImage( "avenger61.bmp" ), X, Y )
			Case "avenger64.bmp"
				DrawImage( LoadImage( "avenger64.bmp" ), X, Y - 7 )
			Default
				DrawImage( LoadImage( FileName ), X, Y )
		End Select
		
		X :+ 32
		If X = 512 Then
			X = 0
			Y :+ 40
		End If
		N :+ 1
		Num :+ 1
	Until N >= 10 ^ Digits
End Function	



Function Save( Name:String )
	Flip
	SavePixmapPNG( MaskPixmap( GrabPixmap( 0, 0, 512, Y + 40 * ( X > 0 ) ), 4, 4, 12 ), Name + ".png", 9 )
	Cls
	X = 0
	Y = 0
	Num = 0
End Function