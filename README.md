# IDDSampleDriver_Wizard
Kai @ PPIT presents to you the Virtual Display Driver Wizard.

![image](https://github.com/user-attachments/assets/096ec719-05bf-479f-859c-982d96e99603)

What you see is what you get! Very simple prototype. Call it beta. 

I use this in my [workstation setup](http://sh.uni2.cc/28JLJ) was wondering how hard it would be to have a GUI for this and here we are.

Issues in advance:
- None that I am aware of at this time.
- OH WAIT UGLY -> UGLY UI is AN ISSUE! Whats up next? A GUI rework!

Things that work:
- User named backups feature
- installation/uninstallation/Reload of drivers.
- Pushing the configs to the C:\IddSampleDriver if not already there.
- Converting xml to text, text to xml
- Sorting your resolutions by priority levels. Moving entries with the same width and hight as a group.
- GPU Detection/Selection.
- Monitor Selection
- Reading and writing from the files.
- All core features work, if you find an issue you know where to report it!

Installing:
- The script/compiled executable should go in the folder where you store your [Virtual Display Drivers (Unpacked)](https://github.com/itsmikethetech/Virtual-Display-Driver), it will need access to them for installation purposes.
- Driver Installing depends on Microsoft DevCon as part of the [Windows Development Kit](https://download.microsoft.com/download/2/5/f/25f22c34-1cc4-404c-9f92-2ff26cc4ac91/KIT_BUNDLE_WDK_MEDIACREATION/wdksetup.exe) and here's a [FOSS based installer](https://github.com/Drawbackz/DevCon-Installer/releases/tag/1.3) for just devcon (update sources the version its offering may be dated, I did that before a Windows 11 Entry loaded. ALSO make sure to tick the Windows Path Variable option!)

Notes/Hints:
- At runtime it will load the vdd_settings.xml if present otherwise it will try to load adapter/option.txt. You can also replace/omit these accordingly at C:\IddSampleDriver if you want to workaround this very intended behavior.
- You can also place any config file with the script but in a folder "Backups" with the filename in the format "option.txt.[backup_title_here].backup", replace accordingly (vdd_settings.xml/option.txt/adapter.txt)
- You can name a backup whatever you like and place it manually and when you relaunch you can restore from it just as if you backed up from the GUI.
- What is Priority??? 🤷‍♀️, I made priority up to at least be able to force my preferred aspect ratio at the top of the list due to an issue with Immortals Fenyx Rising [HERE, look to the issues solutions segement and its what I was facing...](http://sh.uni2.cc/28JLJ)

TLDR: Installing... AGAIN
1. Unpack the script or exe, if you are using the script you will need [Autohotkey](https://www.autohotkey.com) installed.
2. Unpack the [Virtual Display Drivers](https://github.com/itsmikethetech/Virtual-Display-Driver) into the same folder.
3. Install Devcon with [Windows Development Kit](https://download.microsoft.com/download/2/5/f/25f22c34-1cc4-404c-9f92-2ff26cc4ac91/KIT_BUNDLE_WDK_MEDIACREATION/wdksetup.exe) or [(this unofficial) DevCon-Installer](https://github.com/Drawbackz/DevCon-Installer/releases/tag/1.3).
4. Run the exe or script.
5. How to use it? Read the GUI.

This software is essentially in beta. This is a quick and dirty tool by design. There is always that chance to find an issue I missed. I will encourage you to let me know if you find any bugs, I can't fix what I don't know is broke!

Planned Features:
- A UI Theme/Overhaul.

Disclaimer: The Software provided hereunder ("Software") is licensed "as-is," without warranties of any kind, express or implied. The Softwarer makes no representations regarding the functionality, performance, compatibility, security, or availability of the Software and no warranty. The developer should not be held responsible even if it blatantly be the cause of your dog running off and joining a circus, or your mother wins 5 tickets to Hawaii but you get stuck on a gaming bender and pass it up. The developer should not be held responsible if use of the Virual Display Driver causes you to spend longer hours on the PC and you muff up at your workplace. The developer should equally not be accredited with any responsibility for your experience using this software. All thanks is to those in development of the drivers and their forks, and the OpenSource communities! It's never been a better time than now to be a PC user!
