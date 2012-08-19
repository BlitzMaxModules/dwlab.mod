'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Type LTFrequency
	Field Hertz:Int
	
	Function Add( ColorDepth:LTColorDepth, Hertz:Int )
		Local Frequency:LTFrequency = New LTFrequency
		Frequency.Hertz = Hertz
		ColorDepth.Frequencies.AddLast( Frequency )
	End Function
	
	Function Get:LTFrequency( ColorDepth:LTColorDepth, Hertz:Int = 0 )
		Local MaxFrequency:LTFrequency = Null
		For Local Frequency:LTFrequency = Eachin ColorDepth.Frequencies
			If Frequency.Hertz = Hertz Then Return Frequency
			If Not MaxFrequency Then
				MaxFrequency = Frequency
			ElseIf Frequency.Hertz > MaxFrequency.Hertz Then
				MaxFrequency = Frequency
			End If
		Next
		Return MaxFrequency
	End Function
End Type