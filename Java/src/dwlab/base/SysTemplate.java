package dwlab.base;

public class SysTemplate {
	public static String version = "1.4.24";
	
	public static final boolean debug = true;
	
	public enum XMLMode {
		GET,
		SET
	}
	
	public static XMLMode xMLMode;

	public static boolean xMLGetMode() {
		return xMLMode == XMLMode.GET;
	}

	public static boolean xMLSetMode() {
		return xMLMode == XMLMode.SET;
	}
}
