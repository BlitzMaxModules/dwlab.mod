SuperStrict

Type TFrame
	Field Pixmap:TPixmap
	Field XOffset:Int, YOffset:Int
EndType

Local Frames:TList = New TList

Local LeftSide:Int = 0
Local RightSide:Int = 0
Local TopSide:Int = 0
Local BottomSide:Int = 0


Local Dir:Int = ReadDir( CurrentDir() )
Local Format:Int
Local Empty:Int = -1

Repeat
	Local FileName:String = NextFile( Dir )
	If Not FileName Then Exit
	if ExtractExt( FileName ).ToLower() <> "frm" Then Continue
	Local File:TStream = ReadFile( FileName )
	
	Local Frame:TFrame = New TFrame
	Frame.Pixmap = LoadPixmap( StripExt( FileName ) + ".bmp" )
	If Empty = -1 Then Empty = ReadPixel( Frame.Pixmap, 0, 0 )
	DebugLog StripExt( FileName ) + ".bmp"
	Format = PixmapFormat( Frame.Pixmap )
	SeekStream( File, 11 )
	Frame.XOffset = ReadByte( File )
	If Frame.XOffset >= 127 Then Frame.XOffset :- 256
	SeekStream( File, 23 )
	Frame.YOffset = ReadByte( File )
	If Frame.YOffset >= 127 Then Frame.YOffset :- 256
	Frames.AddLast( Frame )
	DebugLog Frame.XOffset + ", " + Frame.YOffset
	
	LeftSide = Max( LeftSide, 0.5 * PixmapWidth( Frame.Pixmap ) + Frame.XOffset )
	RightSide = Max( RightSide, 0.5 * PixmapWidth( Frame.Pixmap ) - Frame.XOffset )
	TopSide = Max( TopSide, PixmapHeight( Frame.Pixmap ) - Frame.YOffset )
	BottomSide = Max( BottomSide, Frame.YOffset )
Forever

LeftSide = 48
RightSide = 48
TopSide = 144
BottomSide = 48

DebugLog LeftSide + ", " + TopSide
DebugLog RightSide + ", " + BottomSide

Local Width:Int = LeftSide + RightSide
Local Height:Int = TopSide + BottomSide
DebugLog Width + ", " + Height

Local Canvas:TPixmap = CreatePixmap( Width * 16, Height * 11, PF_BGRA8888 )

Local Num:Int = 1
For Local Frame:TFrame = Eachin Frames
	Canvas.Paste( Frame.Pixmap, ( Num Mod 16 ) * Width + LeftSide - 0.5 * PixmapWidth( Frame.Pixmap ) + Frame.XOffset, ..
			Floor( Num / 16 ) * Height + TopSide - PixmapHeight( Frame.Pixmap ) + Frame.YOffset )
	Num :+ 1
Next

For Local Y:Int = 0 Until PixmapHeight( Canvas )
	For Local X:Int = 0 Until PixmapWidth( Canvas )
		If ReadPixel( Canvas, X, Y ) = Empty Then WritePixel( Canvas, X, Y, Empty & $FFFFFF )
	Next
Next

SavePixmapPNG( Canvas, "objects.png" )