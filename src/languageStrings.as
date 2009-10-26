
import flash.events.Event;

/*							*
 *							*
 *	Actionscript Methods
 *							*
 */


/*
 * Summary:      Parses the FlashVariables relevant to the timedEventQueue http call.  Makes 
 *               the initial call to load.
 * Parameters:   NONE
 * Return:       VOID
 */
public function setupLanguageLoader():void
{	
	//setup the backend url to be timedEventQueueURL
	languageLoaderURL = flashVars.helper_url;			
	//setup the loader with Bulk loading enabled.
	languageLoader = new LangLoader(languageLoaderURL, languageLoaderArray, true);
	languageLoader.addEventListener("FinishedLoadingLanguageStrings", getLangArray);
	languageLoader.load(null);
}

/*
 * Summary:		Updates stings that are used initially on the screen.      
 *               
 * Parameters:   
 * Return:       
 */
public function updateScreenLanguage():void
{
	for (var key:Object in languageLoaderCompletedObject)
	{
		switch (key)
		{
			case "NumberScheduledHostsFlashText":
				NumberScheduledHostsFlashText.displayName = languageLoaderCompletedObject[key];
		  		break;	
		  		
		  	case "NumberScheduledServicesFlashText":
				NumberScheduledServicesFlashText.displayName = languageLoaderCompletedObject[key];
		  		break;	
		  			
			case "RefreshIntervalFlashText":
				refreshSettingLabel.text = languageLoaderCompletedObject[key];
		  		break;	
		  			
			case "WindowFlashText":
				windowSettingLabel.text = languageLoaderCompletedObject[key];
		  		break;			
		  		
		  	case "ScheduledEventAxisLabelFlashText":
				verticalAxis.title = languageLoaderCompletedObject[key];
		  		break;
		  		
		  	case "TimeFromNowAxisLabelFlashText":
				horizontalAxis.title = languageLoaderCompletedObject[key];
		  		break;
		  		
		  	case "PauseFlashText":
				playButton.label = languageLoaderCompletedObject[key];
		  		break;	
		  			  		
		  	case "CloseFlashText":
				closeButton.label = languageLoaderCompletedObject[key];
		  		break;
		  		
		  	case "SettingsFlashText":
				settingsButton.label = languageLoaderCompletedObject[key];
		  		break;		
		  		
		  	case "NagiosCopywriteNoticeFlashText":
				NagiosCopywriteText.text = languageLoaderCompletedObject[key];
		  		break;			  			  		
		  		
		  	case null:
		  		trace ("Language String 'null' refrence.  Something is wrong with the loader.");
		  		break;
	
			default:
		  		trace ("LanguageString Case Statement.  None with key: " + key + "\tvalue: " + languageLoaderCompletedObject[key])
		}	
	}
}

/*							*
 *							*
 *	Event Listener Functions
 *							*
 */

public function getLangArray(event:Event):void
{
	languageLoaderCompletedObject = event.currentTarget.completeLanguageObject;
	updateScreenLanguage();
}


