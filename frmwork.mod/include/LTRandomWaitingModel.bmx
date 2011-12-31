'
' Digital Wizard's Lab - game development framework
' Copyright (C) 2010, Matt Merkulov
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the license.txt
' file distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'

Rem
bbdoc: This model is for waiting random period of time in some interval.
about: Same as LTFixedWaitingModel, but you can specify interval in which time period will be selected.
End Rem
Type LTRandomWaitingModel Extends LTTemporaryModel
	Field TimeFrom:Double, TimeTo:Double

	Function Create:LTRandomWaitingModel( TimeFrom:Double, TimeTo:Double )
		Local Model:LTRandomWaitingModel = New LTRandomWaitingModel
		Model.TimeFrom = TimeFrom
		Model.TimeTo = TimeTo
		Return Model
	End Function
	
	Method Init( Shape:LTShape )
		Super.Init( Shape )
		Period = Rnd( TimeFrom, TimeTo )
	End Method
End Type