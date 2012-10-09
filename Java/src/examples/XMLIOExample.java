package examples;
import java.util.LinkedList;
import java.lang.Math;
import dwlab.base.XMLObject;
import dwlab.base.Align;
import dwlab.base.Project;
import dwlab.base.Object;

public static Example example = new Example();
example.execute();

public class Example extends Project {
	public LinkedList people = new LinkedList();
	public LinkedList professions = new LinkedList();

	public void init() {
		initGraphics();
		for( String name : [ "director", "engineer", "dispatcher", "driver", "secretary", "bookkeeper", "supply agent", "bookkeeper chief", .. ) {
				"lawyer", "programmer", "administrator", "courier" ];
			Profession.create( name );
		}
	}

	public void logic() {
		if( keyHit( key_G ) ) {
			people.clear();
			for( int n = 1; n <= 10; n++ ) {
				Worker.create();
			}
		} else if( keyHit( key_C ) ) {
			people.clear();
		} else if( keyHit( key_F2 ) ) {
			saveToFile( "people.dat" );
		} else if( keyHit( key_F3 ) ) {
			loadFromFile( "people.dat" );
		}

		if( appTerminate() || keyHit( key_Escape ) ) exiting = true;
	}

	public void render() {
		drawText( "Press G to generate data, C to clear, F2 to save, F3 to load", 0, 0 );
		int y = 16;
		for( Worker worker : people ) {
			drawText( worker.firstName + " " + worker.lastName + ", " + worker.age + " years, " + trimDouble( worker.height, 1 ) + " cm, " + 
					trimDouble( worker.weight, 1 ) + " kg, " + worker.profession.name , 0, y );
			y += 16;
		}
		printText( "XMLIO, Manage... example", 0, 12, Align.toCenter, Align.toBottom );
	}

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageListField( "professions", example.professions );
		xMLObject.manageChildList( example.people );
	}
}



public class Profession extends Object {
	public String name;

	public static Profession create( String name ) {
		Profession profession = new Profession();
		profession.name = name;
		example.professions.addLast( profession );
	}

	public void xMLIO( XMLObject xMLObject ) {
		super.xMLIO( xMLObject );
		xMLObject.manageStringAttribute( "name", name );
	}
}



public class Worker extends Object {
	public String firstName;
	public String lastName;
	public int age;
	public double height;
	public double weight;
	public Profession profession;

	public static void create() {
		Worker worker = new Worker();
		worker.firstName = [ "Alexander", "Alex", "Dmitry", "Sergey", "Andrey", "Anton", "Artem", "Vitaly", "Vladimir", "Denis", "Eugene", 
				"Igor", "Constantine", "Max", "Michael", "Nicholas", "Paul", "Roman", "Stanislaw", "Anatoly", "Boris", "Vadim", "Valentine", 
				"Valery", "Victor", "Vladislav", "Vyacheslav", "Gennady", "George", "Gleb", "Egor", "Ilya", "Cyril", "Leonid", "Nikita", "Oleg", 
				"Peter", "Feodor", "Yury", "Ian", "Jaroslav" ][ rand( 0, 40 ) ];
		worker.lastName = [ "Ivanov", "Smirnov", "Kuznetsov", "Popov", "Vasiliev", "Petrov", "Sokolov", "Mikhailov", "Novikov", 
				"Fedorov", "Morozov", "Volkov", "Alekseev", "Lebedev", "Semenov", "Egorov", "Pavlov", "Kozlov", "Stepanov", "Nikolaev", 
				"Orlovv", "Andreev", "Makarov", "Nikitin", "Zakharov" ][ rand( 0, 24 ) ];
		worker.age = rand( 20, 50 );
		worker.height = Math.random( 155, 180 );
		worker.weight = Math.random( 50, 90 );
		worker.profession = Profession( example.professions.get( rand( 0, example.professions.size() - 1 ) ) );
		example.people.addLast( worker );
	}

	public void xMLIO( XMLObject xMLObject ) {
		// !!!!!! Remember to always include this string at the beginning of the method !!!!!!

		super.xMLIO( xMLObject );

		// !!!!!! !!!!!! 

		xMLObject.manageStringAttribute( "first-name", firstName );
		xMLObject.manageStringAttribute( "last-name", lastName );
		xMLObject.manageIntAttribute( "age", age );
		xMLObject.manageDoubleAttribute( "height", height );
		xMLObject.manageDoubleAttribute( "weight", weight );

		// !!!!!! Remember to equate object to to result of ManageObjectAttribute !!!!!!

		profession = Profession( xMLObject.manageObjectField( "profession", profession ) );

		// !!!!!! A = TA( XMLObject.ManageObjectAttribute( "name", A ) ) !!!!!!
	}
}
