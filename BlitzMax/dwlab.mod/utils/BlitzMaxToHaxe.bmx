SuperStrict

Import bah.regex

Global IdentifierChanges:TMap = New TMap
For Local Pair:String[] = Eachin [ ..
	[ "Byte", "Int" ], ..
	[ "Short", "Int" ], ..
	[ "Int", "Int" ], ..
	[ "Long", "Int" ], ..
	[ "Float", "Float" ], ..
	[ "Double", "Float" ], ..
	[ "Object", "Object" ], ..
	[ "String", "String" ], ..
	[ "Find", "indexOf" ], ..
	[ "Split", "split" ], ..
	[ "ToLower", "toLowerCase" ], ..
	[ "ToUpper", "toUpperCase" ], ..
	[ "TList", "List" ], ..
	[ "AddFirst", "push" ], ..
	[ "AddLast", "add" ], ..
	[ "Remove", "remove" ], ..
	[ "First", "first" ], ..
	[ "Last", "last" ], ..
	[ "Clear", "clear" ], ..
	[ "TMap", "Hash" ], ..
	[ "Contains", "exists" ], ..
	[ "ValueForKey", "get" ], ..
	[ "Insert", "set" ], ..
	[ "And", "&&" ], ..
	[ "Or", "||" ], ..
	[ "Not", "!" ], ..
	[ "Max", "max" ], ..
	[ "Min", "min" ], ..
	[ "Sin", "sin" ], ..
	[ "Cos", "cos" ], ..
	[ "Tan", "tan" ], ..
	[ "ACos", "acos" ], ..
	[ "ASin", "asin" ], ..
	[ "ATan", "atan" ], ..
	[ "ATan2", "atan2" ], ..
	[ "Floor", "floor" ], ..
	[ "Ceil", "ceil" ], ..
	[ "Abs", "abs" ], ..
	[ "Sqr", "sqrt" ], ..
	[ "Log", "log" ], ..
	[ "Exp", "exp" ], ..
	[ "Rnd", "random" ], ..
	[ "True", "True" ], ..
	[ "False", "False" ], ..
	[ "Null", "Null" ], ..
	[ "Return", "return" ], ..
	[ "Super", "super" ], ..
	[ "Self", "this" ], ..
	[ "Extends", "extends" ], ..
	[ "New", "new" ] ..
]
	'[ "", "" ], ..
	IdentifierChanges.Insert( Pair[ 0 ].ToLower(), Pair[ 1 ] )
Next

Global Classes:TMap = New TMap

Const Directory:String = "C:\Program Files\BlitzMax\mod\dwlab.mod\frmwork.mod"

GetClassNames( Directory )
ProcessDirectory( Directory )

Function GetClassNames( DirName:String )
	Local Dir:Int = ReadDir( DirName )
	Repeat
		Local FileName:String = NextFile( Dir )
		If Not FileName Then Exit
		If FileName = "." Or FileName = ".." Then Continue
		
		Local FullFileName:String = DirName + "\" + FileName
		If FileType( FullFileName ) = FILETYPE_DIR Then
			GetClassNames( FullFileName )
			Continue
		End If
		
		If Not FileName.ToLower().EndsWith( ".bmx" ) Then Continue
	
		DebugLog "Retrieving class names from " + FileName
		Local File:TStream = ReadFile( FullFileName )
		While Not Eof( File )
			Local Line:String = ReadLine( File ).Trim().ToLower()
			If Line.StartsWith( "type" ) Then
				Line = Line[ 4.. ].Trim() + " "
				Classes.Insert( Line[ ..Line.Find( " " ) ], Null )
			End If
		WEnd
	Forever
End Function

Function ProcessDirectory( DirName:String )
	Local Dir:Int = ReadDir( DirName )
	Repeat
		Local FileName:String = NextFile( Dir )
		If Not FileName Then Exit
		If FileName = "." Or FileName = ".." Then Continue

		Local FullFileName:String = DirName + "\" + FileName
		If FileType( FullFileName ) = FILETYPE_DIR Then
			ProcessDirectory( FullFileName )
			Continue
		End If
	
		If Not FileName.ToLower().EndsWith( ".bmx" ) Then Continue
		
		DebugLog "Converting " + FileName
		Local File:TStream = ReadFile( FullFileName )
		Local Text:String = ""
		Local RemBlock:Int = False
		While Not Eof( File )
			Local Line:String = ReadLine( File )
			Local Trimmed:String = Line.ToLower().Trim()
			If Trimmed.StartsWith( "?" ) Then Continue
			if Text Then Text :+ "~n"
			If RemBlock Then
				If Trimmed = "endrem" or Trimmed = "end rem" Then
					Text :+ TRegEx.Create( "^((\t| )*)(EndRem|End Rem)" ).ReplaceAll( Line, "\1 */" )
					RemBlock = False
				Else
					Line = TRegEx.Create( "^((\t| )*)(bbdoc|about): *" ).ReplaceAll( Line, "\1" )
					Line = TRegEx.Create( "^((\t| )*)returns: *" ).ReplaceAll( Line, "\1@return " )
					Text :+ TRegEx.Create( "^((\t| )*)(.*)$" ).ReplaceAll( Line, "\1 * \3" )
				End If
			ElseIf Trimmed = "rem" Then
				Text :+ TRegEx.Create( "^((\t| )*)Rem" ).ReplaceAll( Line, "\1/**" )
				RemBlock = True
			Else
				If Line.Trim() Then
					Line :+ ";"
					
					Local IdentifierBegin:Int = -1
					Local Brackets:Int = False
					Local N:Int = 0 
					While N < Line.Length
						If Brackets Then
							If Line[ N ] = Asc( "~q" ) Then Brackets = False
						Else
							If Line[ N ] = Asc( "~q" ) Then
								Brackets = True
							ElseIf Line[ N ] = Asc( "'" ) Then
								Line = Line [ ..N ] + "//" + Line[ N + 1..Line.Length - 1 ]
								Exit
							ElseIf IdentifierBegin < 0 Then
								If IsIdentifier( Line[ N ], True ) Then IdentifierBegin = N
							ElseIf Not IsIdentifier( Line[ N ], False ) Then
								Local NewIdentifier:String = ConvertIdentifier( Line[ IdentifierBegin..N ] )
								Line = Line[ ..IdentifierBegin ] + NewIdentifier + Line[ N.. ]
								N = IdentifierBegin + NewIdentifier.Length
								IdentifierBegin = -1
							End If
						End If
						N :+ 1
					WEnd
					
					Text :+ Line
				End If
			End If
		WEnd
		CloseFile File
		
		Text = TRegEx.Create( "^((\t| )*)Local " ).ReplaceAll( Text, "\1" )
		Text = TRegEx.Create( "^((\t| )*)Global " ).ReplaceAll( Text, "\1public " )
		Text = TRegEx.Create( "^((\t| )*)Field " ).ReplaceAll( Text, "\1public " )
		Text = TRegEx.Create( "^((\t| )*)Const " ).ReplaceAll( Text, "\1public final " )
		
		Text = TRegEx.Create( "^((\t| )*)(Function|Method) *((\w|\d|_)*) *\(" ).ReplaceAll( Text, "\1\3 \4:Void(" )
		Text = TRegEx.Create( "^((\t| )*)Method (.*);" ).ReplaceAll( Text, "\1public \3 {" )
		Text = TRegEx.Create( "^((\t| )*)Function (.*);" ).ReplaceAll( Text, "\1public static \3 {" )
		Text = TRegEx.Create( "^((\t| )*)Type (.*);" ).ReplaceAll( Text, "\1public class \3 {" )
		
		Text = TRegEx.Create( "^((\t| )*)If (.*)=(.*)" ).ReplaceAll( Text, "\1if \3==\4" )
		Text = TRegEx.Create( " *== *~q~q" ).ReplaceAll( Text, ".isEmpty()" )
		Text = TRegEx.Create( " *== *~q([^~q]*)~q" ).ReplaceAll( Text, ".equals( \1 )" )
		
		Text = TRegEx.Create( "^((\t| )*)(ElseIf|Else If) (.*) Then((\t| )*);" ).ReplaceAll( Text, "\1} elseif( \4 ) {" )
		Text = TRegEx.Create( "^((\t| )*)(ElseIf|Else If) (.*);" ).ReplaceAll( Text, "\1} elseif( \4 ) {" )
		Text = TRegEx.Create( "^((\t| )*)If (.*) then((\t| )*);" ).ReplaceAll( Text, "\1if( \3 ) {" )
		Text = TRegEx.Create( "^((\t| )*)If (.*) then (.*) else (.*);" ).ReplaceAll( Text, "\1if( \3 ) \4; else \5;" )
		Text = TRegEx.Create( "^((\t| )*)If (.*) then (.*);" ).ReplaceAll( Text, "\1if( \3 ) \4;" )
		Text = TRegEx.Create( "^((\t| )*)Else((\t| )*);" ).ReplaceAll( Text, "\1} else {" )
		
		Text = TRegEx.Create( "^((\t| )*)For Local ((\w|\d|_)*):((\w|\d|_)*) *= *(.*) To (.*) Step (.*);" ).ReplaceAll( Text, "\1for( \3:\5=\7; \3 <= \8; \3 += \9 ) {" )
		Text = TRegEx.Create( "^((\t| )*)For ((\w|\d|_)*) *= *(.*) To (.*) Step (.*);" ).ReplaceAll( Text, "\1for( \3=\5; \3 <= \6; \3 += \7 ) {" )
		Text = TRegEx.Create( "^((\t| )*)For Local ((\w|\d|_)*):((\w|\d|_)*) *= *(.*) To (.*);" ).ReplaceAll( Text, "\1for( \3:\5=\7; \3 <= \8; \3++ ) {" )
		Text = TRegEx.Create( "^((\t| )*)For ((\w|\d|_)*) *= *(.*) To (.*);" ).ReplaceAll( Text, "\1for( \3=\5; \3 <= \6; \3++ ) {" )
		Text = TRegEx.Create( "^((\t| )*)For Local ((\w|\d|_)*):((\w|\d|_)*) *= *(.*) Until (.*);" ).ReplaceAll( Text, "\1for( \3:\5=\7; \3 <= \8; \3++ ) {" )
		Text = TRegEx.Create( "^((\t| )*)For ((\w|\d|_)*) *= *(.*) Until (.*);" ).ReplaceAll( Text, "\1for( \3=\5; \3 < \6; \3++ ) {" )
		Text = TRegEx.Create( "^((\t| )*)For Local ((\w|\d|_)*):((\w|\d|_)*) *= *EachIn (.*);" ).ReplaceAll( Text, "\1for( \3:\5@@ \7 ) {" )
		Text = TRegEx.Create( "^((\t| )*)For ((\w|\d|_)*) *= *EachIn (.*);" ).ReplaceAll( Text, "\1for( \3@@ \5 ) {" )
		Text = TRegEx.Create( "^((\t| )*)While *(.*);" ).ReplaceAll( Text, "\1while( \3 ) {" )
		Text = TRegEx.Create( "^((\t| )*)Repeat((\t| )*);" ).ReplaceAll( Text, "\1while( true ) {" )
		Text = TRegEx.Create( "^((\t| )*)(EndMethod|End Method|EndIf|End If|End Function|EndFunction|End Type|EndType|Next|WEnd|Forever)((\t| )*);" ).ReplaceAll( Text, "\1}" )
		
		Text = TRegEx.Create( ":\+" ).ReplaceAll( Text, "+=" )
		Text = TRegEx.Create( ":\-" ).ReplaceAll( Text, "-=" )
		Text = TRegEx.Create( ":\*" ).ReplaceAll( Text, "*=" )
		Text = TRegEx.Create( ":/" ).ReplaceAll( Text, "/=" )
		
		Text = TRegEx.Create( ">==" ).ReplaceAll( Text, ">=" )
		Text = TRegEx.Create( "<==" ).ReplaceAll( Text, "<=" )
		Text = TRegEx.Create( "<>" ).ReplaceAll( Text, "!=" )
		
		Text = TRegEx.Create( "~~q" ).ReplaceAll( Text, "\~q" )
		Text = TRegEx.Create( "~~n" ).ReplaceAll( Text, "\r\n" )
		Text = TRegEx.Create( "~~t" ).ReplaceAll( Text, "\t" )
		Text = Text.Replace( "@@", ":" )
		'Text = TRegEx.Create( "" ).ReplaceAll( Text, "" )
		
		File = WriteFile( FullFileName[ ..FullFileName.Length - 4 ] + ".hx" )
		WriteLine( File, Text )
		CloseFile File
	Forever
End Function

Function IsIdentifier:Int( Code:Int, StringBeginning:Int )
	If StringBeginning And Code >= Asc( "0" ) And Code <= Asc( "9" ) Then Return True
	If Code >= Asc( "A" ) And Code <= Asc( "Z" ) Then Return True
	If Code >= Asc( "a" ) And Code <= Asc( "z" ) Then Return True
End Function

Function ConvertIdentifier:String( Identifier:String )
	Local LowerCaseIdentifer:String = Identifier.ToLower()
	
	If Classes.Contains( LowerCaseIdentifer ) Then
		If LowerCaseIdentifer.StartsWith( "lt" ) Then Identifier = Identifier[ 2.. ]
		Return Identifier[ 0..1 ].ToUpper() + Identifier[ 1.. ]
	End If
	
	Local Result:String = String( IdentifierChanges.ValueForKey( LowerCaseIdentifer ) )
	If Result Then Return Result
	
	If Identifier.EndsWith( "@" ) Then Identifier = Identifier[ ..Identifier.Length - 1 ] + ":Byte"
	If Identifier.EndsWith( "%" ) Then Identifier = Identifier[ ..Identifier.Length - 1 ] + ":Int"
	If Identifier.EndsWith( "#" ) Then Identifier = Identifier[ ..Identifier.Length - 1 ] + ":Float"
	If Identifier.EndsWith( "!" ) Then Identifier = Identifier[ ..Identifier.Length - 1 ] + ":Double"
	If Identifier.EndsWith( "$" ) Then Identifier = Identifier[ ..Identifier.Length - 1 ] + ":String"
	
	If LowerCaseIdentifer.StartsWith( "l_" ) Then Identifier = Identifier[ 2.. ]
	
	Return Identifier[ 0..1 ].ToLower() + Identifier[ 1.. ]
End Function