/*
 *	Authar: 	Mark Young
 *  Company: 	Nagios Enterprises
 *	Copywrite:	2008
 *
 *	Description:	main.as Main script for the teqchart.mxml Timed Event Queue Flex application.
 *
 **/

/*							*
 *							*
 *		Libraries
 *							*
 */
	
	/* import of internal libraries */
	import nagios.net.LangLoader;
	import nagios.net.XMLLoader;
	import nagios.utils.bucketUtls;
	import nagios.formatter.HrMinSecFormatter;
	
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;


/*							*
 *							*
 *	Instance Variablse
 *							*
 */
	/* 
	 * FLEX/Actionscript instance variables for use by main.as and teqchart.mxml directly 
	 */
	[Bindable] private var timedEventQueueAC:ArrayCollection;
	[Bindable] private var timedEventQueueChartingMax:int;
	[Bindable] private var languageStrings:Object = new Object();
	
	[Embed(source='assets/playButton.png')]
	[Bindable]
	public var imagePlay:Class;
	
	[Embed(source='assets/pauseButton.png')]
	[Bindable]
	public var imagePause:Class;	
	
	[Embed(source='assets/settingsButton.png')]
	[Bindable]
	public var imageSettings:Class;	
	
	/*
	 * FLEX/Actionscript instance variables used in main.as only 
	 */
	private var flashVars:Object;
	private var refreshInterval:int = 30;
	
	private var timedEventQueue:XMLLoader;
	private var timedEventQueueURL:String ;
	private var timedEventQueueVariables:Object = new Object();
	private var timedEventQueueMaxChecks:int;
	//setup a timedEventQueueTimer with at lease a default of update every 30seconds
	private var timedEventQueueTimer:Timer = new Timer(3000);
	
	
	private var languageLoader:LangLoader;
	private var languageLoaderURL:String ;
	//names of the variables to use for the ajaxhelper.php function calls
	private var languageLoaderArray:Array = new Array(	["NumberScheduledHostsFlashText"], 
														["NumberScheduledServicesFlashText"], 
														["RefreshIntervalFlashText"],
														["WindowFlashText"],
														["ScheduledEventAxisLabelFlashText"],
														["TimeFromNowAxisLabelFlashText"],
														["PlayFlashText"],
														["PauseFlashText"],
														["CloseFlashText"],
														["SettingsFlashText"],
														["TimedEventQueueChartTitleFlashText"],
														["TimedEventQueueInfoFlashText"],
														["RefreshIntervalInfoFlashText"],
														["WindowInfoFlashText"],
														["NagiosCopywriteNoticeFlashText"]
													 );
	private var languageLoaderCompletedObject:Object; 
	
	private var playPause:Boolean = true;
													 

	
	

/*							*
 *							*
 *	Actionscript Methods
 *							*
 */
	
/*
 * Summary:		init() is called after the main page loads.  Sets up the http calls to
 *              the backend and ajaxhelper.
 * Parameters:  NONE
 * Return:      VOID
 */
public function init():void
{
	//setup the flash vars
	flashVars = Application.application.parameters;
	trace("flashVars::\n" + printObject(flashVars));
	refreshInterval = flashVars.refresh_interval;
		
	//sets the value of the sliders, and anyother UI values that need to be
	UIInit();
	
	//Initializes the language loader, listeners, and functions to set the UI display from the string found in the 
	setupLanguageLoader();

	//Initializes the timedEventQueue http calls and listeners.
	timedEventQueueInit();
}
	

public function printObject(obj:Object):String	
{
	var returnStr:String = "";
	
	for (var key:Object in obj)
	{
		returnStr = returnStr + "key\t=\t" + key + "\nvalue\t=\t" + obj[key] + "\n";
	}
	
	return returnStr;
}
	



/*							*
 *							*
 *	Event Listener Functions
 *							*
 */
	


	
			