
// - - - Library Imports for TimedEventQueue - - - //

import mx.charts.chartClasses.IAxis;
import nagios.formatter.HrMinSecFormatter;


// - - - Initializing fuctions -- called at program load - - - //

/**
 * calls the setup functions for the T.E.Q. and initializes the horzAxis
 * labeling function.
 */ 
public function timedEventQueueInit():void
{
	//create the timed event queue http call and start loading.
	setupTimedEventQueue();
	
	//setup the labelFunction for the horizonal axis
	horizontalAxis.labelFunction = chartHorzLabelFunc;	
}

// - - - T.E.Q functions - - - //

/**
 * Parses the FlashVariables relevant to the T.E.Q. http call, sets up
 * a timer class instance based on the refresh interval, and makes the
 * initial call to load() to start the graph updating.
 */  
public function setupTimedEventQueue():void
{
	//setup the backend url to be timedEventQueueURL
	timedEventQueueURL = flashVars.backend_url;
	
	//setup the timedEventQueueVariables and parse the flashVars relevant
	timedEventQueueVariables["cmd"] = "gettimedeventqueuesummary";
	for (var keyStr:Object in flashVars)
	{
		switch (keyStr)
		{
			case "window":
				timedEventQueueVariables[keyStr] = flashVars[keyStr];
				break;

			case "bucket_size":
				timedEventQueueVariables[keyStr] = flashVars[keyStr];
				break;
				
			case "instance_id":
				timedEventQueueVariables[keyStr] = flashVars[keyStr];
				break;								
		}
	}
	timedEventQueue = new XMLLoader(timedEventQueueURL, timedEventQueueVariables);
	timedEventQueue.addEventListener(Event.COMPLETE, chartUpdater, false, 0, true);
	timedEventQueue.load(null);	
	
	
	//setup the timer with the correct delays
	setRefresh();
}


/**
 * Sets up a timer class instance for T.E.Q and related objects.
 */ 
public function setRefresh():void
{	
	
	if( refreshInterval == 0 )
	{
		refreshInterval == flashVars.refresh_interval;	
	}
	
	//update the refresh slider position.
	//refreshSlider.value = refreshInterval;
	
	timedEventQueueTimer.delay =  refreshInterval * 1000;
	
	timedEventQueueTimer.addEventListener(TimerEvent.TIMER, timedEventQueueTimerListener);
	
	timedEventQueueTimer.start();
}


/*
 * Summary:      
 *               
 * Parameters:   
 * Return:       
 */
public function chartMaxSmoother( max:int ):void
{
	if ( ( max * 1.20 > timedEventQueueMaxChecks) || ( max < timedEventQueueMaxChecks/4) )
	{
		timedEventQueueMaxChecks = max * 1.20;
	}		
	
	verticalAxis.maximum = timedEventQueueMaxChecks;
	
}

/*
 * Summary:      
 *               
 * Parameters:   
 * Return:       
 */
public function chartLabler( params:Object ):void
{		
	horizontalAxis.interval = Math.floor( 
								( int( params["window"] ) / int( params["bucket_size"] ) ) / 4 
							);
}


public function chartHorzLabelFunc(item:Object, prevValue:Object, axis:IAxis):String
{
	// seconds = # buckets at tick * bucket_size
	var formattedStr:HrMinSecFormatter = new HrMinSecFormatter( int( item ) * int( flashVars.bucket_size ) );
	
	return formattedStr.toString();
}




		



/*							*
 *							*
 *	Event Listener Functions
 *							*
 */


/*
 * Summary:      
 *               
 * Parameters:   
 * Return:       
 */
public function chartUpdater(event:Event):void
{
	var bucketHelper:bucketUtls = new bucketUtls( XML( event.currentTarget.data ) );

	//setup some chart parameters
	chartMaxSmoother( bucketHelper.max );
	
	chartLabler( event.currentTarget.variables );

			
	//setup the data
	timedEventQueueAC = bucketHelper.toArrayCollection( new Array([0],[12]) );
		
}		



/*
 * Summary:      
 *               
 * Parameters:   
 * Return:       
 */	
public function timedEventQueueTimerListener(e:TimerEvent):void
{	
	timedEventQueue.load(null);
}		