SuperStrict

Framework brl.basic
Import dwlab.frmwork

For Local N:Int = 1 To 10
	If L_IsPowerOf2( N ) Then
		Print( N + " is power of 2" )
	Else
		Print( N + " is not power of 2" )
	End If
Next

Rem output
1 is power of 2
2 is power of 2
3 is not power of 2
4 is power of 2
5 is not power of 2
6 is not power of 2
7 is not power of 2
8 is power of 2
9 is not power of 2
10 is not power of 2
EndRem