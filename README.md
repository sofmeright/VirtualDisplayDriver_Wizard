Kai of <a href="https://kb.precisionplanit.com">PRPlanIT.com</a> presents:

# Virtual Display Driver: Wizard
> A GUI tool that can integrate with other software such as Sunshine for efficient manipulation (Install / Uninstall / Reload / Configure) of Indirect Display Driver Sample (IddSample) implementations like the HDR capable <a href="https://github.com/itsmikethetech/Virtual-Display-Driver">Virtual Display Driver from itsmikethetech</a> that works on Windows 10/11. This installer/configuration tool is intended to provide a more elegant solution in place of needing to edit configs or use Device Manger for driver installation.


<img src="https://github.com/sofmeright/IDDSampleDriver_Wizard/blob/main/PPIT-IddSample_Wiz-SS_GUI_Advanced.png" width="300" />

### How did we get here:
> I use the Virtual Display Driver in my [workstation setup](http://sh.uni2.cc/28JLJ) and at a point I wondered how hard it would be to make a GUI for the driver and in turn I had to figure out how hard it was to finish my thought.
> I'm sharing this because I am typically a leecher and not a seeder. I use a lot of open source products in my workflow but do not often contribute. I'd be tickled if anyone gets use of this even if its only a drop-in-the-bucket.

### Features:
- Sunshine Integration - Automatic resolution adding / switching to the clients set [width x height x hz] with combination of sunshine commands and qres. Set and FORGET.
- Driver (Install / Uninstall / Reload) - Note: Reload has been useful, in my experience using Sunshine; reload did not cause the active session to terminate and refreshed changes.
- Monitor(s) (Set # of) - Adjusting the amount of virtual displays the driver is providing.
- RenderingEngine(GPU) (*Detection* & Selection)
- Resolutions (Adding / Removing)
- Resolutions (Grouping of Resolutions) - Resolution enteries containing the same [width x hight] are sorted by the earliest occurence of that specific [w x h] in the list. ~ This is done so they are in grouped entries when we write out the XML config.
- Priority (Changing) - (See: What is priority? in [Notes / Hints])
- Configs (Reading / Writing) - Reads and Writes both config formats (.txt & .xml).
- Configs (Conversion) - Efficiently converts between the xml and text config formats, via injecting them as decribed in [Notes / Hints].
- Configs (Default) - Pushes the properly named configs from the scripts folder to the C:\IddSampleDriver if not already there.
- Backups (Save/Load/Inject) - User can Save/Load (User Named) Backups of the .txt & .xml based configs into a Backups folder directly from the GUI. These can also be manipulated in their folder directly (See [Notes / Hints] for further instructions).
> Note: Additional features such as an Interactive Installer are planned. These features have been considered prior to creation of the tool and the design philosophy allows for ease of implementation.

### CMD/CLI Arguements:
You can call the script/exe from a staging tool/sunshine with Admin Credentials ~ any process that loads it directly or a .bat that can calls it. This will allow you to load initial settings or toggle install/uninstall/reload.
To use command line arguments with the script you will need to pipe it through Autohotkey first (otherwise directly after the .exe): 
> cmd /C SunshineIntegration.bat %SUNSHINE_CLIENT_WIDTH% %SUNSHINE_CLIENT_HEIGHT% %SUNSHINE_CLIENT_FPS%
- Install / Uninstall / Reload the driver.
> VirtualDisplayDrv.exe [Driv_Inst / Driv_Unin / Driv_Relo]
- Load/Save/Remove Backup entries for the given name (in quotes if it contains spaces).
> VirtualDisplayDrv.exe [Back_Load / Back_Save / Back_Remo] \<Name\>
- Sets the number of monitors
> VirtualDisplayDrv.exe Moni_Sets \<integer\>
- Sets the GPU to the given GPU name or if an integer by the GPU Detection number (in quotes if it contains spaces).
> VirtualDisplayDrv.exe GPUs_Sets \<String or integer\> 
- When a string is passed in containing %width% %hight% %Refresh% it adds it to the top of the list (even if it already exists).
> VirtualDisplayDrv.exe [Reso_Adds / Reso_Remo] \<WIDTH\> \<HEIGHT\> \<Hz\> 

# Installation:
1. Unpack the .exe or the .ahk source file. Note: If you wish to use the ".ahk" file (plain-text source code), you must install [Autohotkey](https://www.autohotkey.com).
2. Unpack the [Virtual Display Drivers](https://github.com/itsmikethetech/Virtual-Display-Driver) (or other IDDSample drivers) into the same folder.
3. Install Devcon with [Windows Development Kit](https://download.microsoft.com/download/2/5/f/25f22c34-1cc4-404c-9f92-2ff26cc4ac91/KIT_BUNDLE_WDK_MEDIACREATION/wdksetup.exe) or [(this unofficial) DevCon-Installer](https://github.com/Drawbackz/DevCon-Installer/releases/tag/1.3).
4. Run the exe or script.
5. How to use it? Read the GUI, do stuff. There are some recommendations scattered throughout this ReadMe as well.

### Notes / Hints:
- At runtime it will load the vdd_settings.xml if present otherwise it will try to load adapter/option.txt. You can also replace/omit these accordingly at C:\IddSampleDriver if you want to workaround this very intended behavior.
- You can also place any config file with the script but in a folder "Backups" with the filename in the format "option.txt.[backup_title_here].backup", replace accordingly (vdd_settings.xml/option.txt/adapter.txt)
- You can name a backup whatever you like and place it manually and when you relaunch you can restore from it just as if you backed up from the GUI.
- But WHAT is *Priority*??? 🤷‍♀️ - I made it up ~ for the purpose of forcing a preferred [width x hight + Hz] to the top of the list. The resulting / only workable solution to accomplish this was a bit more robust than I initially desired (See: Features - Grouping of Resolutions), but nonetheless it resolves an issue I had with Immortals Fenyx Rising that may or may not affect other games or software. [HERE in the issues/solutions segement, I briefly describe the issue...](http://sh.uni2.cc/28JLJ)

### Integrating the tool with Sunshine:

<img src="https://github.com/sofmeright/IDDSampleDriver_Wizard/blob/main/PPIT-IddSample_Wiz-SS_Sunshine_Integration.png" width="300" />

- For some strange reason its possible to execute this with a .bat but not directly from Sunshine and it is not a syntax issue as we are passing the same syntax to a .bat.
- Make sure to check the config.elevated option, admin is needed for Driver Reloading, the tool will not run w/o elevation.
- Point the sunshine command to the SunshineIntegration.bat, then afterwards run qres to set the resolution and all your clients will automatically add any resolution that they request. There are FOSS HDR togglers available afaik as well.
>
> cmd /C SunshineIntegration.bat %SUNSHINE_CLIENT_WIDTH% %SUNSHINE_CLIENT_HEIGHT% %SUNSHINE_CLIENT_FPS%

### Current Issues / Workarounds:
- AFAIK I haven't closed the issue that it requires reload of GUI to show new backups in the dropdown if another selection is made after Saving them.
- File writes/Priority Sorting is happening with out any loading screens. This is my preferred experience. However, due to this; if you change many things in swift sequence while it is writing or sorting ~ all the changes may not make it to the config if you close out without another change. If you make sure there is at least like 3-5 seconds between your last change you will be fine even if you go fast. (You can typically tell its updating ~ A file write occurs after that). CLI usage is unaffected. If it is bothersome I can add a loading screen in between writes, I resolved this already by simply hiding the GUI until its ready to change again, but I didn't like that. If this troubles you, raise an issue.
- You will have a generally good experience in the GUI, just be aware of this above limitation. Resolving this issue without changing the current feel of the application will take a entire recode of the way I am implementing the backend for resolutions entries. It can be on the roadmap, especially if this tool becomes more adopted.
> Note: This software is essentially in beta. This is a quick and dirty tool by design. There is always that chance to find an issue I missed. I will encourage you to let me know if you find any bugs, I can't fix what I don't know is broke!

### Planned Features:
> Validation of the resolution fields of positive integers only so that jank can not be inserted into the list.
>
> Automatically selecting a default GPU when nothing is selected. Meant to add this already. Whoops!
> 
> Adding resolutions by pressing enter when (Wt x Ht + Hz) is filled out rather than by pressing a button.
>
> A generic installer flow with options for users who do not want an Advanced tool and just want to get up and going.
>
> Found [a fork](https://github.com/timminator/Virtual-Display-Driver) of the Virtual Display Driver that has a interactive installer albeit less utilitarian than this, they cite that they used [nefcon](https://github.com/nefarius/nefcon), will prospect this as an alternative install/uninstall/reload method if it can provide the reload feature it may be easier to package than devcon. (In our review we found issues specifically with reload/uninstall using nefcon, even as found implemented in timinators git. Please raise an issue if you want to help!)

### Dependencies / Requirements:
> This software configures the state of a few implementations of Microsofts Indirect Display Driver Sample, as such a compatible implementation is required; the one I test with is [the "Virtual Display Driver" from itsmikethetech](https://github.com/itsmikethetech/Virtual-Display-Driver) which is forked from [ge9's IddSampleDriver](https://github.com/ge9/IddSampleDriver), it will likely work other forks that share the same IddSampleDriver and *.inf name.

> The Driver Installation method I use depends on Microsoft DevCon as part of the [Windows Development Kit](https://download.microsoft.com/download/2/5/f/25f22c34-1cc4-404c-9f92-2ff26cc4ac91/KIT_BUNDLE_WDK_MEDIACREATION/wdksetup.exe) and here's a [FOSS based installer](https://github.com/Drawbackz/DevCon-Installer/releases/tag/1.3) for just devcon (In the FOSS installer: Make sure to TICK the Windows Path Variable option! SELECT ~ Update Sources in the installer: the DevCon version available for install may be dated, I needed this for a Windows 11 Entry to appear.) If you know a method for installing the drivers with CLI without this dependency, please raise an issue!

> This was written 100% with [Autohotkey](https://www.autohotkey.com), I first touched [Autohotkey](https://www.autohotkey.com) in 2010 or so. Why AutoHotkey? I determined in evaluating how hard it would be to do this that [Autohotkey](https://www.autohotkey.com) would allow me to have the fastest trasition from having an idea to having a workable code. In every release there is a ".ahk" plain-text source file, that you can inspect and even make changes. If you install [Autohotkey](https://www.autohotkey.com) you will be able to execute the source code directly.

 >If you do not like AutoHotkey... You are most entitled to that opinion and encouraged to fork and port to something like Java or Python. Then I certainly will pull the changes, build a WebUI or do something as a token of gratitude & repect for your opinion. Otherwise as Deadpool said, MAXIMUM EFFORT!!! 🥴 AutoHotkey it is! 🤣

### Disclaimer: 
> The Software provided hereunder ("Software") is licensed "as-is," without warranties of any kind, express or implied. The Softwarer makes no representations regarding the functionality, performance, compatibility, security, or availability of the Software and no warranty. The developer should not be held responsible even if it blatantly be the cause of your dog running off and joining a circus, or your mother wins 5 tickets to Hawaii but you get stuck on a gaming bender and pass it up. The developer should not be held responsible if use of the Virual Display Driver causes you to spend longer hours on the PC and you muff up at your workplace. The developer should equally not be accredited with any responsibility for your experience using this software. All thanks is to those in development of the drivers and their forks, and the OpenSource communities! It's never been a better time than now to be a PC user!
