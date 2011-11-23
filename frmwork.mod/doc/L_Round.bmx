SuperStrict

Framework brl.basic
Import dwlab.frmwork

For Local N:Double = 0 To 3.1 Step 0.3
	Print "L_Round( " + L_TrimDouble( N ) + " ) = " + L_Round( N )
Next

Rem output
L_Round( 0 ) = 0
L_Round( 0.3 ) = 0
L_Round( 0.6 ) = 1
L_Round( 0.9 ) = 1
L_Round( 1.2 ) = 1
L_Round( 1.5 ) = 2
L_Round( 1.8 ) = 2
L_Round( 2.1 ) = 2
L_Round( 2.4 ) = 2
L_Round( 2.7 ) = 3
L_Round( 3 ) = 3
EndRem