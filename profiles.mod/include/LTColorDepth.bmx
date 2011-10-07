'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Include "LTFrequency.bmx"

Type LTColorDepth
	Field Bits:Int
	Field Frequencies:TList = New TList
	
	Function Add( Resolution:LTScreenResolution, Bits:Int, Hertz:Int )
		For Local ColorDepth:LTColorDepth = Eachin Resolution.ColorDepths
			If ColorDepth.Bits = Bits Then
				LTFrequency.Add( ColorDepth, Hertz )
				Return
			End If
		Next
		
		Local ColorDepth:LTColorDepth = New LTColorDepth
		ColorDepth.Bits = Bits
		Resolution.ColorDepths.AddLast( ColorDepth )
		LTFrequency.Add( ColorDepth, Hertz )
	End Function
	
	Function Get:LTColorDepth( Resolution:LTScreenResolution, Bits:Int = 0 )
		Local MaxDepth:LTColorDepth = Null
		For Local Depth:LTColorDepth = Eachin Resolution.ColorDepths
			If Depth.Bits = Bits Then Return Depth
			If Not MaxDepth Then
				MaxDepth = Depth
			ElseIf Depth.Bits > MaxDepth.Bits Then
				MaxDepth = Depth
			End If
		Next
		Return MaxDepth
	End Function
End Type