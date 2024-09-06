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
Notes:
- At runtime it will load the vdd_settings.xml if present otherwise it will try to load adapter/option.txt(s) all can be placed manually into the C:\IddSampleDriver folder.
- You can also place any config file in a folder "Backups" with the filename in the format "option.txt.[backup_title_here].backup" just replace whatever (vdd_settings.xml/option.txt/adapter.txt)
- You can name a backup whatever you like and place it manually and when you relaunch you can restore from it just as if you backed up from the gui.


TLDR: Again
1. Unpack the script or exe, if you are using the script you will need [Autohotkey](https://www.autohotkey.com) installed.
2. Unpack the [Virtual Display Drivers](https://github.com/itsmikethetech/Virtual-Display-Driver) into the same folder.
3. Run the exe or script.
4. How to use it? Read the GUI.

Again we will call this a beta. We will resolve this bug next and after that do some general UI cleanup. This is a quick and dirty tool by design. If you want to contribute and have experience most of the bones are here, be my guest. I do not think there would be much interest in this, I plan to do a little more and call it a day.

Planned Features:
- Better Sorting ASAP
- Placing good default configs (i.e. option.txt) into the right places when there is nothing there. Overlooked that completely.

Disclaimer: The Software provided hereunder ("Software") is licensed "as-is," without warranties of any kind, express or implied. The Softwarer makes no representations regarding the functionality, performance, compatibility, security, or availability of the Software and no warranty. The developer should not be held responsible even if it blatantly be the cause of your dog running off and joining a circus, or your mother wins 5 tickets to Hawaii but you get stuck on a gaming bender and pass it up. The developer should not be held responsible if use of the Virual Display Driver causes you to spend longer hours on the PC and you muff up at your workplace. The developer should equally not be accredited with any responsibility for your experience using this software. All thanks is to those in development of the drivers and their forks, and the OpenSource communities! It's never been a better time than now to be a PC user!
