'
' Digital Wizard's Lab world editor
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Attribution-NonCommercial-ShareAlike 3.0 License terms, as
' specified in the license2.txt file distributed with this
' code, or available from
' http://creativecommons.org/licenses/by-nc-sa/3.0/
'

Global Simulator:TSimulator = New TSimulator

Type TSimulator Extends LTProject
	Field Layer:LTLayer
	
	
	
	Method CreateShape:LTShape( Shape:LTShape )
		Return Shape.Clone()
	End Method
	
	
	
	Method Init()
		LoadAndInitLayer( Layer, LTLayer( Editor.SelectedShape ) )
		LTBox2DPhysics.InitWorld( Layer )
		 = 
		Pan = TPan.Create( 
	End Method
	
	
	
	Method Logic()
		LTBox2DPhysics.Logic()
	End Method
End Type