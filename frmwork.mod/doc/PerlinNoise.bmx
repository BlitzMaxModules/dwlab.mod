SuperStrict

Framework brl.basic
Import dwlab.frmwork

L_InitGraphics()

Const MapSize:Int = 256

Local DoubleMap:LTDoubleMap = New LTDoubleMap
DoubleMap.SetResolution( MapSize, MapSize )

Local Frequency:Int = 16
Local Amplitude:Double = 0.25
Local DAmplitude:Double = 0.5
Local Layers:Int = 4
Local Blur:Int = False

Repeat
	Cls
	DoubleMap.PerlinNoise( Frequency, Frequency, Amplitude, DAmplitude, Layers )
	Local Pixmap:TPixmap = DoubleMap.ToNewPixmap()
	DrawPixmap( Pixmap, 400 - 0.5 * PixmapWidth( Pixmap ), 300 - 0.5 * PixmapHeight( Pixmap ) )		
	DrawText( "Starting frequency: " + Frequency + " ( +/- to change )", 0, 0 )
	DrawText( "Starting amplitude: " + L_TrimDouble( Amplitude ) + " ( left / right arrow to change )", 0, 16 )
	DrawText( "Starting amplitude increment: " + L_TrimDouble( DAmplitude ) + " ( up / down arrow to change )", 0, 32 )
	DrawText( "Layers quantity: " + Layers + " ( page up / page down arrow to change )", 0, 48 )
	Flip

	Repeat
		If KeyHit( Key_NumAdd ) Then
			If Frequency < 256 Then Frequency :* 2
			Exit
		ElseIf KeyHit( Key_NumSubtract ) Then
			If Frequency > 1 Then Frequency :/ 2
			Exit
		ElseIf KeyHit( Key_Left ) Then
			If Amplitude > 0.05 Then Amplitude :/ 2
			Exit
		ElseIf KeyHit( Key_Right ) Then
			If Amplitude < 1.0 Then Amplitude :* 2
			Exit
		ElseIf KeyHit( Key_Down ) Then
			If DAmplitude > 0.05 Then DAmplitude :/ 2
			Exit
		ElseIf KeyHit( Key_Up ) Then
			If DAmplitude < 2.0 Then DAmplitude :* 2
			Exit
		ElseIf KeyHit( Key_PageUp ) Then
			If Layers < 8 Then Layers :+ 1
			Exit
		ElseIf KeyHit( Key_PageDown ) Then
			If Layers > 1 Then Layers :- 1
			Exit
		End If
	Until KeyDown( Key_Escape )
Until KeyDown( Key_Escape )
