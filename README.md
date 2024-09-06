# IDDSampleDriver_Wizard
Kai @ PPIT presents to you the Virtual Display Driver Wizard.

![image](https://github.com/user-attachments/assets/692397c0-0ce6-4c94-8646-b664c990253e)

What you see is what you get! Very simple prototype. Call it beta. 

I use this in my [workstation setup](http://sh.uni2.cc/28JLJ) was wondering how hard it would be to have a GUI for this and here we are.

Issues in advance:
- The one problem is getting the resolution sorting down. It works but you have to close and reopen to get it to sort after using F2 to manipulate priority.
- Due to the way I went with the decision pipeling a GUI event is calling itself with the best case code I came up with, made a workaround but it only does partial sort this way, for the XML format the Drivers devs have recently adopted it is ideal to sort everything prior to writing out so all the likened width x hight are nested. This is one days work, I promise to clean it up after some R&R.

Things that work:
- Everything else works as planned that I am aware.
- User named backups feature
- installation/uninstallation/Reload of drivers.
- GPU Detection/Selection.
- Monitor Selection
- Reading and writing from the files.
- All other core features work.

Installing:
- Not a bad idea to make a copy of any vdd_settings.xml, option.txt, adapter.txt configs you may already have in your C:\IddSampleDriver folder just to be safe.
- The script/compiled executable should go in the folder where you store your [Virtual Display Drivers (Unpacked)](https://github.com/itsmikethetech/Virtual-Display-Driver), it will need access to them for installation purposes.

Notes/Hints:
- Grouping of resolutions in the XML may or may not be important... In my GUI currently if there are seperated enteries containing the same width & height i.e. their priorities are not in sequence, then it will also write to seperated resolution entries in a legible XML format, its legible but seperated is not best practice imho. And I honestly don't know how the drivers iterate that, so be aware! This is to be streamlined with a different sorting idea I thought out, Im like 75% sure it will work, I just can't do it *right now*, I tried using ChatGPT I am so tired and it tried to make me break what we already have. 🤣
- At runtime it will load the vdd_settings.xml if present otherwise it will try to load adapter/option.txt. You can also replace/omit these accordingly at C:\IddSampleDriver if you want to workaround this very intended behavior.
- You can also place any config file with the script but in a folder "Backups" with the filename in the format "option.txt.[backup_title_here].backup", replace accordingly (vdd_settings.xml/option.txt/adapter.txt)
- You can name a backup whatever you like and place it manually and when you relaunch you can restore from it just as if you backed up from the GUI.
- What is Priority??? 🤷‍♀️, I made priority up to at least be able to force my preferred aspect ratio at the top of the list due to an issue with Immortals Fenyx Rising [HERE, look to the issues solutions segement and its what I was facing...](http://sh.uni2.cc/28JLJ)


TLDR: Again
1. Unpack the script or exe, if you are using the script you will need [Autohotkey](https://www.autohotkey.com) installed.
2. Unpack the [Virtual Display Drivers](https://github.com/itsmikethetech/Virtual-Display-Driver) into the same folder.
3. Run the exe or script.
4. How to use it? Read the GUI.

Again we will call this a beta. We will resolve this bug next and after that do some general UI cleanup. This is a quick and dirty tool by design. If you want to contribute and have experience most of the bones are here, be my guest. I do not think there would be much interest in this, I plan to do a little more and call it a day.

Planned Features:
- Like TOMORROW! Placing good default configs (i.e. option.txt) into the right places when there is nothing there. Overlooked that *completely*.
- Better Sorting ASAP
- A UI Theme/Overhaul.

Disclaimer: The Software provided hereunder ("Software") is licensed "as-is," without warranties of any kind, express or implied. The Softwarer makes no representations regarding the functionality, performance, compatibility, security, or availability of the Software and no warranty. The developer should not be held responsible even if it blatantly be the cause of your dog running off and joining a circus, or your mother wins 5 tickets to Hawaii but you get stuck on a gaming bender and pass it up. The developer should not be held responsible if use of the Virual Display Driver causes you to spend longer hours on the PC and you muff up at your workplace. The developer should equally not be accredited with any responsibility for your experience using this software. All thanks is to those in development of the drivers and their forks, and the OpenSource communities! It's never been a better time than now to be a PC user!
