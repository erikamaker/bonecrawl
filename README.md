# THERE'S BEEN A MISTAKE

You wake up in a dim dungeon, dead. A prisoner of the sprawling underworld, your eternal fate is demonic judgment. Except, you don't belong here.
Fight through the nine labyrinthian levels of perdition. Face treacherous demons, reclaim your bones, and save your soul.

[Video.webm](https://github.com/erikamaker/bonecrawl/assets/118931925/686d6913-2326-4a55-8233-b4e57b7073a0)

# ABOUT THE ENGINE 

In 2003, my mom linked me to a .zip file of some text adventures. That's all it took. I spent a lot of my youth on solo adventures that unfolded before me in terminal-green characters across a curved black screen. For 20 years, I've dreamt of building my own adventure and, in 2019, I broke ground on the rogue-like realization of its engine. Here it is, warts and all.

The idea was to create a text-based RPG that felt action-oriented. It needed to work with words alone, yet stay far away from the realm of multiple-choice CYOAs to maximize on replayability. I wanted the player to experience a full and unique adventure, complete with NSWE navigation, a visual grid map of coordinates, a hearts bar display, inventory management, dynamic terrain, tools and weapons crafting, turn-based battling, layered lore, magick casting, reactive characters, environmental puzzles, and a heck of a lot more. 


# PROGRESS UPDATE

> The last class is all but finished. Its last method will accept the correct bone from the player to ascend them to the next level, and I'm feeling a little emotional about finishing it today, so I'm waiting until Monday when I'm on vacation. Following that, I'm going to take a few weeks to comb through everything and make sure we're all good to release the first level, and then I'm putting the lid on this lovely project for now! 

7/2/23

> The last 18 days have been all about battle methods, equipping items, refactoring, and polishing. There's only one class left to build before the level can be written. Following that, hosting a live demo on www.bonecrawl.com. We're in the final stretch! Woo! 

6/18/23

> I never liked that the Board class contained (what should have been) the player (class) data, and knew that the classes should be distinct from one another. So, I abstracted the player from the board, and made it its own class. Now that I'm not possessed by that spirit, it's time to finish up the last few classes. 

5/30/23

> I've been polishing some old classes and building the battling methods. NPC class is pretty much finished. Battling is coming along well! I just need to implement special stats to keep things a little more interesting. Coming down the line is: complete battling system including special stats items / attacks, crafting system (really simple idea in mind, shouldn't take long), and then some level building before release! 

> Oh, and the engine doesn't scroll anymore. I worked an escape sequence into the main loop that closes the old frame before its successor displays. Lots of small cosmetic tweaks the last month. 

5/14/23 


> Getting really close to the end for a complete demo and test level. Just need to work on the NPC class, and the crafting system a little more. I've been distracted with work, studying, and the melting of Midwestern snow. I expect a surge of inspiration any day now, and I'll get a webpage ready on bonecrawl.com.

4/11/23


> The terminal-based engine is nearing completion, but there's still work to do. Following its completion, I will be building a website at www.bonecrawl.com, where players may can a demo and download the game. Each level will be released in installments. I would love to one day add MMORPG functionality, so that friends can meet up in their own levels to map out adventures. More than anything, I have big mobile app aspirations for this project. 

3/14/23


Copyright Erika Maker  / 'Bone Crawl' © 2019 (www.bonecrawl.com). All rights reserved.

Desktop demo of rogue-like text adventure engine, and accompanying test level.

Intended use: game engine for creating game content on PC and mobile platforms. 
