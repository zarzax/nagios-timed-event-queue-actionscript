// - - - Library Imports for UI - - - //

import flash.events.Event;
import mx.events.SliderEvent;

// - - - Instance Variables -- for user interface concerns. - - - //

// - - - Initializing Functions -- called at program load - - - //

/**
 * Initialize the data interaction for the User Interface with one call. 
 */ 
public function UIInit():void
{	
	//setup the sliders positions
	slidersInit();
	boxTextInit();
}

/**
 * Initialize the window size and refresh interval sliders
 */ 
public function slidersInit():void
{
	//build all the localvariables
	var window:Number			=	flashVars.window;
	var refresh:Number			=	flashVars.refresh_interval;

	
	//set the sliders initial value
	windowSettingSlider.value 		= window;
	refreshSettingSlider.value		= refresh;
}

/**
 * Initialize the settingsPanel text boxes.
 */ 
public function boxTextInit():void
{
	//build all the local variables
	var window:Number			=	flashVars.window;
	var refresh:Number			=	flashVars.refresh_interval;
	
	//set the sliders initial value
	windowSettingTextInput.text 		= window.toString();
	refreshSettingTextInput.text 		= refresh.toString();	
}


// - - - User interaction functions - - - //
/**
 * using the instance var playPause:bool and updating on clicks
 * change values and icon according to true or false.
 */
public function playFunctionUpdater():void
{
	if (playPause)
	{
		timedEventQueueTimer.stop();
		playPause = false;
		if ( languageLoaderCompletedObject.hasOwnProperty("PlayFlashText"))
		{
			playButton.label = languageLoaderCompletedObject["PlayFlashText"].toString();
		}
			
		playButton.setStyle("icon", imagePlay);
		
	}
	else
	{
		timedEventQueue.load(null);
		timedEventQueueTimer.start();
		playPause = true;
		if ( languageLoaderCompletedObject.hasOwnProperty("PauseFlashText") )
		{
			playButton.label = languageLoaderCompletedObject["PauseFlashText"];
		}
			
		playButton.setStyle("icon", imagePause);
	}	
}

	
// - - - Event Listeners -- for settingsPanel sliders and textboxes - - - //

/**
 * Listen for window slider value change and update accordingly
 */ 
public function windowSliderUpdater(event:SliderEvent):void
{
	//set the TextInput
	windowSettingTextInput.text = event.currentTarget.value;
	
	//update the URLVariables of the timed event queue.
	var windowObj:Object = new Object();
	windowObj["window"] = event.currentTarget.value;
	timedEventQueue.setVars(windowObj);
	
	timedEventQueue.load(null);

	//reset the timer then start.
	timedEventQueueTimer.reset();	
	
	if (playPause)
	{
		timedEventQueueTimer.start();
	}	

	
}

/**
 * Listen for refresh slider value change and update accordingly
 */ 
public function refreshSliderUpdater(event:SliderEvent):void
{
	//set the TextInput
	refreshSettingTextInput.text = event.currentTarget.value;
	
	//set the refresh interval to be that of the sliders current value
	refreshInterval = event.currentTarget.value;
	
	//do the work..  set the new time in the timer object delay.
	timedEventQueueTimer.delay = refreshInterval * 1000;
	
	timedEventQueue.load(null);
	
	//reset the timer then start.
	timedEventQueueTimer.reset();
	
	if (playPause)
	{
		timedEventQueueTimer.start();
	}
}

/**
 * Listen for window text keypress 'enter' and update accordingly
 */ 
public function windowTextUpdater(event:Event):void
{
	//update the slider
	windowSettingSlider.value = int(event.currentTarget.text);
	
	//update the URLVariables of the timed event queue.
	var windowObj:Object = new Object();
	windowObj["window"] = int(event.currentTarget.text);
	timedEventQueue.setVars(windowObj);
	
	timedEventQueue.load(null);
	
	//reset the timer then start.
	timedEventQueueTimer.reset();
	timedEventQueueTimer.start();
}

/**
 * Listen for refresh text keypress 'enter' and update accordingly
 */ 
public function refreshTextUpdater(event:Event):void
{
	//update the slider
	refreshSettingSlider.value = int(event.currentTarget.text);
	
	//set the refresh interval to be that of the sliders current value
	refreshInterval = event.currentTarget.text;
	
	//do the work..  set the new time in the timer object delay.
	timedEventQueueTimer.delay = refreshInterval * 1000;
	
	timedEventQueue.load(null);
	
	//reset the timer then start.
	timedEventQueueTimer.reset();
	timedEventQueueTimer.start();		
}

