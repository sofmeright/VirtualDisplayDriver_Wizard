# IDDSampleDriver_Wizard
Kai @ PPIT presents to you the Virtual Display Driver Wizard.

![image](https://github.com/user-attachments/assets/692397c0-0ce6-4c94-8646-b664c990253e)

What you see is what you get! Very simple prototype. Call it beta. 

I use this in my [workstation setup](http://sh.uni2.cc/28JLJ) was wondering how hard it would be to have a GUI for this and here we are.

Issues in advance:
- The one problem is getting the resolution sorting down. It works but you have to close and reopen to get it to sort after using F2 to manipulate priority.
- Due to the way I went with the decision pipeling a GUI event is calling itself with the best case code I came up with, made a workaround but it only does partial sort this way, for the XML format the Drivers devs have recently adopted it is ideal to sort everything prior to writing out so all the likened width x hight are nested. It may require a rebuild of the methods used for iterating through the list view items.

Things that work:
- Everything else works as planned that I am aware.
- User named backups feature
- installation/uninstallation/Reload of drivers.
- GPU selection.
- Monitor Selection
- Reading and writing from the files.
- All other core features work.

Installing:
- I recommend creating a copy of any vdd_settings.xml, option.txt, adapter.txt configs you have in your C:\IddSampleDriver folder just to be extra safe.
- The script/compiled executable should go in the folder where you store your [Virtual Display Drivers Unpacked](https://github.com/itsmikethetech/Virtual-Display-Driver), it will need access to them for installation purposes.
- If you unpack the drivers from itsmiketech into the same folder it can take care of everything else, at worst you might just copy paste all the values into the write places for the option.txt, and save a copy to be safe. Then load it by launching this tool while it is in the C:\IddSampleDriver folder or in the script folder at Backups\\[backup_title_here].backup. If it is misbehaving for you it should at least be able to load it in sorted and write out your XML for you, it did MINE.

TLDR: Again
1. Unpack the script or exe, if you are using the script you will need [Autohotkey](https://www.autohotkey.com) installed.
2. Unpack the [Virtual Display Drivers](https://github.com/itsmikethetech/Virtual-Display-Driver) into the same folder.
3. Run the exe or script.
4. How to use it? Read the GUI.

Again we will call this a beta. We will resolve this bug next and after that do some general UI cleanup. This is a quick and dirty tool by design. If you want to contribute and have experience most of the bones are here, be my guest. I do not think there would be much interest in this, I plan to do a little more and call it a day.
