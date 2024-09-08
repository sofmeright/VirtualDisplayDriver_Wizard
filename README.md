# VirtualDisplayDriver_Wizard

Kai of [PRPlanIT.com](https://kb.precisionplanit.com) presents to you:

Virtual Display Driver: Wizard
- A quick and dirty GUI tool for manipulation (Install / Uninstall / Reload / Configure) of Indirect Display Driver Sample (IddSample) implementations like the HDR capable [Virtual Display Driver from itsmikethetech](https://github.com/itsmikethetech/Virtual-Display-Driver) that works on Windows 10/11. This installer/configuration tool is intended to provide a more elegant solution in place of needing to edit configs or use Device Manger for driver installation.


<img src="https://github.com/sofmeright/IDDSampleDriver_Wizard/blob/main/PPIT-IddSample_Wiz-v0.602-SS_GUI_Advanced.png" width="200" />

Features:
- Driver (Install / Uninstall / Reload) - Note: Reload has been useful, in my experience using Sunshine; reload did not cause the active session to terminate and refreshed changes.
- Monitor(s) (Set # of) - Adjusting the amount of virtual displays the driver is providing.
- RenderingEngine(GPU) (*Detection* & Selection)
- Resolutions (Adding / Removing) - Note: Removing is done by highlighting and pressing the DELETE key.
- Resolutions (Grouping of Resolutions) - Resolution enteries containing the same [width x hight] are sorted by the earliest occurence of that specific [w x h] in the list. ~ This is done so they are in grouped entries when we write out the XML config.
- Priority (Changing) - The priority of a specific resolution can be set by selecting it and pressing F2 then pressing Enter when finished with the edit. (See: What is priority? in [Notes / Hints])
- Configs (Reading / Writing) - Reads and Writes both config formats (.txt & .xml).
- Configs (Conversion) - Efficiently converts between the xml and text config formats, via injecting them as decribed in [Notes / Hints].
- Configs (Default) - Pushes the properly named configs from the scripts folder to the C:\IddSampleDriver if not already there.
- Backups (Save/Load/Inject) - User can Save/Load (User Named) Backups of the .txt & .xml based configs into a Backups folder directly from the GUI. These can also be manipulated in their folder directly (See [Notes / Hints] for further instructions).

Note: Additional features such as a GUI Overhaul, CLI, and an Interactive Installer are planned and have been considered prior in the current design philosophy for later implementation.

How did we get here:
- I use the Virtual Display Driver in my [workstation setup](http://sh.uni2.cc/28JLJ) and at a point I wondered how hard it would be to make a GUI for the driver and in turn I had to figure out how hard it was to finish my thought.
- I'm sharing this because I am typically a leecher and not a seeder. I use a lot of open source products in my workflow but do not often contribute. I'd be tickled if anyone gets use of this even if its only a drop-in-the-bucket.

Requirements:
- This software configures the state of a few implementations of Microsofts Indirect Display Driver Sample, as such a compatible implementation is required; the one I test with is [the "Virtual Display Driver" from itsmikethetech](https://github.com/itsmikethetech/Virtual-Display-Driver) which is forked from [ge9's IddSampleDriver](https://github.com/ge9/IddSampleDriver), it will likely work other forks that share the same IddSampleDriver and *.inf name.
- The Driver Installation method I use depends on Microsoft DevCon as part of the [Windows Development Kit](https://download.microsoft.com/download/2/5/f/25f22c34-1cc4-404c-9f92-2ff26cc4ac91/KIT_BUNDLE_WDK_MEDIACREATION/wdksetup.exe) and here's a [FOSS based installer](https://github.com/Drawbackz/DevCon-Installer/releases/tag/1.3) for just devcon (In the FOSS installer: Make sure to TICK the Windows Path Variable option! SELECT ~ Update Sources in the installer: the DevCon version available for install may be dated, I needed this for a Windows 11 Entry to appear.)

Installing...
1. Unpack the exe or the script. Note: To directly execute from the ".ahk" file (plain-text source code), you must install [Autohotkey](https://www.autohotkey.com).
2. Unpack the [Virtual Display Drivers](https://github.com/itsmikethetech/Virtual-Display-Driver) into the same folder.
3. Install Devcon with [Windows Development Kit](https://download.microsoft.com/download/2/5/f/25f22c34-1cc4-404c-9f92-2ff26cc4ac91/KIT_BUNDLE_WDK_MEDIACREATION/wdksetup.exe) or [(this unofficial) DevCon-Installer](https://github.com/Drawbackz/DevCon-Installer/releases/tag/1.3).
4. Run the exe or script.
5. How to use it? Read the GUI, there are some general recommendations in [Notes / Hints] and [Features] as well.

Notes / Hints:
- At runtime it will load the vdd_settings.xml if present otherwise it will try to load adapter/option.txt. You can also replace/omit these accordingly at C:\IddSampleDriver if you want to workaround this very intended behavior.
- You can also place any config file with the script but in a folder "Backups" with the filename in the format "option.txt.[backup_title_here].backup", replace accordingly (vdd_settings.xml/option.txt/adapter.txt)
- You can name a backup whatever you like and place it manually and when you relaunch you can restore from it just as if you backed up from the GUI.
- But WHAT is *Priority*??? 🤷‍♀️ - I made it up ~ for the purpose of forcing a preferred [width x hight + Hz] to the top of the list. The resulting / only workable solution to accomplish this was a bit more robust than I initially desired (See: Features - Grouping of Resolutions), but nonetheless it resolves an issue I had with Immortals Fenyx Rising that may or may not affect other games or software. [HERE in the issues/solutions segement, I briefly describe the issue...](http://sh.uni2.cc/28JLJ)
- This was written 100% with [Autohotkey](https://www.autohotkey.com), I first touched [Autohotkey](https://www.autohotkey.com) in 2010 or so. Why AutoHotkey? I determined in evaluating how hard it would be to do this that [Autohotkey](https://www.autohotkey.com) would allow me to have the fastest trasition from having an idea to having a workable code. In every release there is a ".ahk" plain-text source file, that you can inspect. You can make changes and execute this code directly from the source if you wish, if you install [Autohotkey](https://www.autohotkey.com).
- If you do not like AutoHotkey... You are most cetainly entitled to that opinion and you are also allowed to fork this and port it to something like Java or Python. Then I certainly will pull the changes and build a WebUI or do something as a token of gratitude and repect for your opinion. Otherwise as Deadpool said, MAXIMUM EFFORT!!! 🥴 AutoHotkey it is! 🤣

Current Issues / Workarounds:
- None that I am aware of at this time.
- OH WAIT UGLY -> UGLY UI is AN ISSUE! Whats up next? A GUI rework!
- Spoke too soon, I will fix this next: Solution - In order to have the selected RenderEngine (or Monitor Count) save to file, you will need to edit a priority (or add a resolution). (You can even press F2 then Press ENTER) There is no logic to detect when a user makes a selection in the combo box and in turn to write to file. For now its recommended to use this temporary workaround.
- Does not automatically select the first detected RenderEngine as a default when you first run it if none are selected. This will be implemented soon, just select it and then change a priority or add a resolution for now.

This software is essentially in beta. This is a quick and dirty tool by design. There is always that chance to find an issue I missed. I will encourage you to let me know if you find any bugs, I can't fix what I don't know is broke!

Planned Features (This section also features priority sorting😅):
1. Validation of the resolution fields of positive integers only so that jank can not be inserted into the list.
2. Adding resolutions by pressing enter when (Wt x Ht + Hz) is filled out rather than by pressing a button.
3. A UI Theme/Overhaul.
4. Silent intall via CMD. Creating a CMD syntax to use this tool without the GUI, that way the driver can be configured from other tools. In essence allow operation from a staging tool/sunshine or any process that can load it directly or a .bat that calls it. This will allow users to load initial settings or toggle install/uninstall/reload. Users could bulk configure the drivers for gaming servers with many VMs with specific guests settings in an efficient manner by this feature.
5. A generic installer flow with options for users who do not want an Advanced tool and just want to get up and going.

Disclaimer: The Software provided hereunder ("Software") is licensed "as-is," without warranties of any kind, express or implied. The Softwarer makes no representations regarding the functionality, performance, compatibility, security, or availability of the Software and no warranty. The developer should not be held responsible even if it blatantly be the cause of your dog running off and joining a circus, or your mother wins 5 tickets to Hawaii but you get stuck on a gaming bender and pass it up. The developer should not be held responsible if use of the Virual Display Driver causes you to spend longer hours on the PC and you muff up at your workplace. The developer should equally not be accredited with any responsibility for your experience using this software. All thanks is to those in development of the drivers and their forks, and the OpenSource communities! It's never been a better time than now to be a PC user!
