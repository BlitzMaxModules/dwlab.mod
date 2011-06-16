Type TPauseSign Extends LTPause

	Field x:Int, y:Int
	Field image:TImage
	Field r%=255, g%=255, b%=255
	Field state:Int = DECREASE
	Field scale:Float
	Field scale_step:Float
	Field Initialized:Int
	
	Const KEYPRESSED:Int = 0
	Const DECREASE:Int = 1 
	Const INCREASE:Int = 2
	Const CALCULATE:Int = 3
	Const CHECK:Int = 4
	
	Field max_scale:Float = 5.0
	Field min_scale:Float = 0.5
	
	Method Init()
		image = LoadImage( "PauseSign\PauseSign.png")
		If Not image Then L_Error( "Can't find image" )
		MidHandleImage( image )
		x = GraphicsWidth() * 0.5
		y = GraphicsHeight() * 0.5
		Initialized = True
	End Method
	
	Method update:Int()
		If Not Initialized Then Init()
		
		Select state
		
			Case KEYPRESSED
			
				If KeyHit( Key ) Then state = INCREASE 
				
			Case DECREASE
			
				scale = max_scale
				scale_step = -0.3
				state = CALCULATE
				
			Case INCREASE
			
				scale = min_scale
				scale_step = +0.3
				state = CALCULATE
				
			Case	CALCULATE
					
				scale :+ scale_step 
				state = CHECK
				
			Case CHECK

				If scale >= max_scale
					state = DECREASE
					Remove()						
				Else If scale <= min_scale 
					state = KEYPRESSED
				Else
					state = CALCULATE
				End If
											
		End Select		
			
	End Method
	
	Method render()
		If Not Initialized Then Return
		SetColor(0,0,0)
		SetAlpha(0.5)
		DrawRect(0,0,GraphicsWidth(),GraphicsHeight())
		
		SetScale(scale,scale)
		SetColor(r,g,b)
		SetAlpha(1.0)
		DrawImage(image,x,y)
	End Method
End Type

