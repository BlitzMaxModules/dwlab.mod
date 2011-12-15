SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Const MapSize:Int = 128

L_InitGraphics()

Local SourceMap:LTDoubleMap = LTDoubleMap.Create( MapSize, MapSize )
SourceMap.DrawCircle( MapSize * 0.375, MapSize * 0.375, MapSize * 0.35, 0.6 )
Draw( SourceMap.ToNewImage(), "Source map" )

Local TargetMap:LTDoubleMap = LTDoubleMap.Create( MapSize, MapSize )
TargetMap.DrawCircle( MapSize * 0.625, MapSize * 0.625, MapSize * 0.35, 0.8 )
Draw( TargetMap.ToNewImage(), "Target map" )

Local DoubleMap:LTDoubleMap = LTDoubleMap.Create( MapSize, MapSize )
DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Add )
DoubleMap.Limit()
Draw( DoubleMap.ToNewImage(), "Adding source map to target map" )

DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Multiply )
Draw( DoubleMap.ToNewImage(), "Multiplying source map with target map" )

DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Maximum )
Draw( DoubleMap.ToNewImage(), "Maximum of source map and target map" )

DoubleMap.Paste( TargetMap )
DoubleMap.Paste( SourceMap, 0, 0, LTDoubleMap.Minimum )
Draw( DoubleMap.ToNewImage(), "Minimum of source map and target map" )

SetScale( 4.0, 4.0 )
Local Image:LTImage = SourceMap.ToNewImage( LTDoubleMap.Red )
TargetMap.PasteToImage( Image, 0, 0, 0, LTDoubleMap.Green )
Draw( Image, "Pasting maps to different color channels" )


Function Draw( Image:LTImage, Text:String )
	SetScale ( 4.0, 4.0 )
	DrawImage( Image.BMaxImage, 400, 300 )
	SetScale( 1.0, 1.0 )
	DrawText( Text, 0, 0 )
	Flip
	Waitkey
	Cls
End Function