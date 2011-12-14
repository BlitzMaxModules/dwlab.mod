SuperStrict

Framework brl.basic
Import dwlab.frmwork
Import dwlab.graphicsdrivers

Global Example:TExample = New TExample
Example.Execute()

Type TExample Extends LTProject
	Field People:TList = New TList
	Field Professions:TList = New TList
	
	Method Init()
		L_InitGraphics()
		For Local Name:String = Eachin [ "director", "engineer", "dispatcher", "driver", "secretary", "bookkeeper", "supply agent", "bookkeeper chief", ..
				"lawyer", "programmer", "administrator", "courier" ]
			TProfession.Create( Name )
		Next
	End Method
	
	Method Logic()
		If KeyHit( Key_G ) Then
			People.Clear()
			For Local N:Int = 1 To 10
				TWorker.Create()
			Next
		ElseIf KeyHit( Key_C ) Then
			People.Clear()
		ElseIf KeyHit( Key_F2 ) Then
			SaveToFile( "people.dat" )
		ElseIf KeyHit( Key_F3 ) Then
			LoadFromFile( "people.dat" )
		End If
			
		If AppTerminate() Or KeyHit( Key_Escape ) Then Exiting = True
	End Method

	Method Render()
		DrawText( "Press G to generate data, C to clear, F2 to save, F3 to load", 0, 0 )
		Local Y:Int = 16
		For Local Worker:TWorker = Eachin People
			DrawText( Worker.FirstName + " " + Worker.LastName + ", " + Worker.Age + " years, " + L_TrimDouble( Worker.Height, 1 ) + " cm, " + ..
					L_TrimDouble( Worker.Weight, 1 ) + " kg, " + Worker.Profession.Name , 0, Y )
			Y :+ 16
		Next
	End Method
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageListField( "professions", Example.Professions )
		XMLObject.ManageChildList( Example.People )
	End Method
End Type



Type TProfession Extends LTObject
	Field Name:String
	
	Function Create:TProfession( Name:String )
		Local Profession:TProfession = New TProfession
		Profession.Name = Name
		Example.Professions.AddLast( Profession )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		Super.XMLIO( XMLObject )
		XMLObject.ManageStringAttribute( "name", Name )
	End Method
End Type



Type TWorker Extends LTObject
	Field FirstName:String
	Field LastName:String
	Field Age:Int
	Field Height:Double
	Field Weight:Double
	Field Profession:TProfession
	
	Function Create()
		Local Worker:TWorker = New TWorker
		Worker.FirstName = [ "Alexander", "Alex", "Dmitry", "Sergey", "Andrey", "Anton", "Artem", "Vitaly", "Vladimir", "Denis", "Eugene", ..
				"Igor", "Constantine", "Max", "Michael", "Nicholas", "Paul", "Roman", "Stanislaw", "Anatoly", "Boris", "Vadim", "Valentine", ..
				"Valery", "Victor", "Vladislav", "Vyacheslav", "Gennady", "George", "Gleb", "Egor", "Ilya", "Cyril", "Leonid", "Nikita", "Oleg", ..
				"Peter", "Feodor", "Yury", "Ian", "Jaroslav" ][ Rand( 0, 40 ) ]
		Worker.LastName = [ "Ivanov", "Smirnov", "Kuznetsov", "Popov", "Vasiliev", "Petrov", "Sokolov", "Mikhailov", "Novikov", ..
				"Fedorov", "Morozov", "Volkov", "Alekseev", "Lebedev", "Semenov", "Egorov", "Pavlov", "Kozlov", "Stepanov", "Nikolaev", ..
				"Orlovv", "Andreev", "Makarov", "Nikitin", "Zakharov" ][ Rand( 0, 24 ) ]
		Worker.Age = Rand( 20, 50 )
		Worker.Height = Rnd( 155, 180 )
		Worker.Weight = Rnd( 50, 90 )
		Worker.Profession = TProfession( Example.Professions.ValueAtIndex( Rand( 0, Example.Professions.Count() - 1 ) ) )
		Example.People.AddLast( Worker )
	End Function
	
	Method XMLIO( XMLObject:LTXMLObject )
		' !!!!!! Remember to always include this string at the beginning of the method !!!!!!
		
		Super.XMLIO( XMLObject )
		
		' !!!!!! !!!!!! 
		
		XMLObject.ManageStringAttribute( "first-name", FirstName )
		XMLObject.ManageStringAttribute( "last-name", LastName )
		XMLObject.ManageIntAttribute( "age", Age )
		XMLObject.ManageDoubleAttribute( "height", Height )
		XMLObject.ManageDoubleAttribute( "weight", Weight )
		
		' !!!!!! Remember to equate object to to result of ManageObjectAttribute !!!!!!
		
		Profession = TProfession( XMLObject.ManageObjectField( "profession", Profession ) )
		
		' !!!!!! A = TA( XMLObject.ManageObjectAttribute( "name", A ) ) !!!!!!
	End Method
End Type