---
title: Recompiling The Lion King With an Agent
date: 2026-10-21 01:30 -0600
description: |
  How a 1994 SNES cartridge became a native PC program in ten days, one loop at a time.
---

![I Just Can't Wait to Be King in widescreen: young Simba leaps between twisting branches, monkeys hanging from them, red blossoms against an orange sky](/assets/images/posts/tlkrecomp/hero.png)
*I Just Can't Wait to Be King in 16:9, running as native code.*

[TLKRecomp](https://github.com/kinduff/TLKRecomp) is *The Lion King* for the Super Nintendo, rebuilt as a native PC program. It runs on Linux, Windows and Mac, plays from the Westwood logo to the final fight with Scar, and can widen the picture to 16:9.

It took ten days, and AI agents wrote the code. They worked in a loop: try something, compare it frame by frame with the original game, find the first thing that differs, fix it, and go again.

This post explains what a recompilation is, how that loop ran, what the first broken tries looked like, what came out of it, and a detour into Donkey Kong Country.

## What "recompiling" means

A SNES game is machine code for the console's own processor. Normally an emulator runs it: a program that pretends to be that processor, one instruction at a time.

A **static recompilation** translates the game's machine code into C ahead of time. A tool ([snesrecomp](https://github.com/RetroPortingToolKit/snesrecomp)) does the translating, and the C gets compiled for your computer like any other program. The chips that draw the picture and play the sound stay emulated, so the game still looks and sounds like the cartridge.

{% svg assets/images/posts/tlkrecomp/recomp.svg %}

Once the game is C, it can be read and changed: a settings menu, a practice mode, widescreen, another game's characters.

No game data lives in the repository. You bring your own dump of your own cartridge, and the build generates the C on your machine.

## The hard part: finding the code

The translator can't translate code it doesn't know about. A cartridge is just bytes; nothing marks which bytes are code, where each routine starts, or what mode the processor is in when it gets there. Popular games come with a community disassembly that answers those questions. The Lion King had none.

The first run of the translator found **24 routines** and stopped. The game has well over a thousand.

The way out came from speedrunners. TASVideos hosts tool-assisted speedruns of this exact ROM: every button press, frame by frame, from power-on to THE END. Played back in an emulator, a speedrun is a ghost holding the controller, and it walks the game through most of its routines. Log every routine the game enters, hand the new ones to the translator, recompile, and check the result. Then do it again with the next tape.

{% svg assets/images/posts/tlkrecomp/coverage.svg %}

The speedruns did a second job too: they became the answer key. If the compiled build plays a ten-minute speedrun to the last frame with the same memory as a reference emulator (BizHawk, bsnes core), the game is right. A single wrong instruction makes Simba miss a jump and the run falls apart.

## How the agents iterated

One agent session acted as coordinator. It held the plan, split the work into tasks, and handed each one to a worker agent in its own copy of the project. The tasks got letters (task C, task M, task FF) and later names (WIN, TURBO, WIDE), about forty in total. The workers were a mix of Claude, Gemini and Codex sessions.

Nothing was merged on a worker's word. Every change had to pass the **gates**: run the game compiled and fully emulated, feed both the same button presses, and compare every frame and every byte of memory. Three speedruns, a 60,000-frame run that collects every bug in the game, and 71 hand-made input tapes, all compared every time.

When something differed, the routine was always the same: find the first frame that differs, then the first hardware access that differs inside that frame, then the routine that caused it. Fix it in the translator or in the emulated hardware, never with a special case for one address. Run every gate again.

{% svg assets/images/posts/tlkrecomp/loop.svg %}

The last step is a person playing it. That step caught things no gate could, as the first tries showed.

{% svg assets/images/posts/tlkrecomp/timeline.svg %}

## The first tries

Before recompiling anything, the agent learned how the game stores its levels by reading the raw cartridge bytes: a custom compression format, a map of 16x16 cells, a table of blocks, tiles and palettes. The first proof it understood something was this: Pride Lands, drawn straight from the ROM's data with no emulator involved. No background yet, but the rocks are where they belong.

![Pride Lands rendered from the ROM data alone, foreground only, on a plain cream background](/assets/images/posts/tlkrecomp/first-map.png)
*Day one: the first level, decoded from the cartridge.*

It tried the same with character sprites, assembling them from the ROM without the game's help. Some came out right. Some didn't.

![Rows of sprites from the ROM: hyena, Scar, Timon, ostrich, gorilla and vulture, each correct on top and oddly assembled below](/assets/images/posts/tlkrecomp/first-sprites.png)
*Top row: right. Bottom row: the same characters, assembled wrong.*

The first pictures from compiled code were worse. A few hand-written hints about how certain routines start were wrong, and one wrong guess early in the boot scrambles everything after it. The middle frame is the emulator; the sides are the compiled build.

![Three frames side by side: a garbled mess of orange tiles, the correct first level with young Simba, and a field of green noise](/assets/images/posts/tlkrecomp/first-garbled.png)
*Compiled, emulated, compiled.*

Then the compiled build matched the emulator: same frames, same memory, every gate green. The first real launch showed a black window.

![On the left a black rectangle, on the right the Lion King title screen with START and OPTIONS](/assets/images/posts/tlkrecomp/first-black-window.png)
*What the window showed, and what the tests saw.*

The tests read the picture from memory, and the picture in memory was perfect. The window drew every pixel fully transparent. It was a small fix, and minutes later the game was playable with sound. From then on, no change counted as done until someone had looked at the real window.

A few more surprises along the way:

- **An interrupt arrived 34 clock ticks late.** Invisible on screen, but enough to shift a lag frame, and enough for a speedrun to drift out of sync thousands of frames later.
- **A blue sky after drowning** in *I Just Can't Wait to Be King* looked like a bug. The agent replayed the same death in BizHawk frame by frame: the original game does it too.
- **A missing part of the intro song.** Every gate passed, because the compiled and emulated builds were wrong in exactly the same way. A listen against a reference recording found a long held note being cut short: the emulated sound chip forgot to reset a "note finished" flag, so the game's music code reused that note's channel early. One small patch to the emulated chip.

## The features

Once the game ran, each feature started as one short request and went through the same loop:

- **The whole game**, start to finish, bonus stages included, keyboard or gamepad.
- **Checked against real emulation**: three published speedruns and the All Bugs run play back in sync, memory checked against BizHawk.
- **A settings menu in the game** (Tab or Esc), shared with other recomp projects.
- **Shaders**: CRT, LCD grid, sharpen, composite. 8:7, 4:3 or square pixels.
- **Practice mode** for speedrunners: level timer, splits, lag counter, input display, one-key restart.
- **Level select** with the debug menu's invulnerability.
- **Save states**, and a **turbo** key that runs the game up to 16x.
- **Widescreen** (experimental): scenery, parallax and enemies keep going past the original edges.
- **Releases** for Linux (AppImage), Windows (one .exe) and Mac (.dmg).

![Six scenes from the game: the ostrich ride, the stampede, Hakuna Matata, Simba's Destiny, Be Prepared and the fight with Scar](/assets/images/posts/tlkrecomp/feature-gallery.png)

![The settings menu drawn over the game, Display section selected](/assets/images/posts/tlkrecomp/feature-menu.png)
*The settings menu.*

![Practice mode: a level timer, TAS split and input display over Can't Wait to Be King](/assets/images/posts/tlkrecomp/feature-practice.png)
*Practice mode.*

![The stampede with the CRT shader at 4:3](/assets/images/posts/tlkrecomp/feature-crt.png)
*CRT shader, 4:3.*

Progress is reported as a card in the colors of the game's HUD, and every number on it names the command that measured it.

![Status card in the colors of the game's HUD: routines compiled 100%, game code run compiled 94.5%, functions found 93.9%, speedruns in sync 100%](/assets/images/posts/tlkrecomp/feature-status.png)

## Showcase

All from the recompiled build. Widescreen first. The game only knows about a 256-pixel-wide screen; the extra picture comes from the level data it already keeps in memory.

<p><video poster="/assets/images/posts/tlkrecomp/widescreen-levels-poster.jpg" controls autoplay loop muted playsinline width="100%" aria-label="Each level of the game in turn, starting in the original 4:3 picture and opening up to 16:9 widescreen"><source src="/assets/images/posts/tlkrecomp/widescreen-levels.mp4" type="video/mp4"><source src="/assets/images/posts/tlkrecomp/widescreen-levels.webm" type="video/webm"></video>
<em>Every level, opening up from the original 4:3 to 16:9. Unmute for the music.</em></p>

![Pride Lands in widescreen: Simba on the grass under the rocks](/assets/images/posts/tlkrecomp/wide-pridelands.png)
*The Pride Lands, 16:9.*

![Can't Wait to Be King in widescreen: Simba leaping under a hanging monkey above the river, giraffe heads below](/assets/images/posts/tlkrecomp/wide-king.png)
*I Just Can't Wait to Be King.*

![The Elephant Graveyard in widescreen with hyenas coming from beyond the original screen](/assets/images/posts/tlkrecomp/feature-widescreen.png)
*The Elephant Graveyard. Those hyenas used to be off-screen.*

![Hakuna Matata in widescreen: Simba swinging from a vine between waterfalls](/assets/images/posts/tlkrecomp/wide-hakuna.png)
*Hakuna Matata.*

![Be Prepared in widescreen: adult Simba on a ledge between lava falls](/assets/images/posts/tlkrecomp/wide-prepared.png)
*Be Prepared.*

![Simba's Return in widescreen: Simba leaping through a stone arch](/assets/images/posts/tlkrecomp/wide-return.png)
*Simba's Return.*

![Bug Hunt bonus stage in widescreen, Timon in the trees with bugs around him](/assets/images/posts/tlkrecomp/wide-bughunt.png)
*Bug Hunt III.*

From the cartridge itself: the game has a hidden developer menu that fans documented years ago, and the retail cartridge still calls itself version .99.

![The hidden debug menu over the title screen: CPU and PPU versions, INVUL OFF, LEVEL THE ELEPHANT GRAVEYARD, VERSION .99](/assets/images/posts/tlkrecomp/debug-menu.png)
*The debug menu. Version .99.*

A whole level, laid out from the data the way no one sees it while playing:

![The full Hakuna Matata map: layers of jungle platforms around a tall waterfall](/assets/images/posts/tlkrecomp/map-hakuna.png)
*Hakuna Matata, all of it.*

![Six frames from the stampede sequence, the herd coming at the camera](/assets/images/posts/tlkrecomp/stampede.png)
*The Stampede.*

![A Bug Hunt bonus stage: Timon in the trees, bugs everywhere](/assets/images/posts/tlkrecomp/bonus-bug-hunt.png)
*Timon's bonus stage.*

![A contact sheet of the whole game: logos, title screen, every level, and THE END](/assets/images/posts/tlkrecomp/journey.png)
*The whole journey, boot to THE END.*

## The Donkey Kong mashup

The project started with a different idea: Donkey Kong characters in The Lion King. A finished recomp of Donkey Kong Country 3 already existed ([DKC3Recomp](https://github.com/elliotttate/DKC3Recomp)), so once both games were C code on the same toolkit, the two could borrow from each other.

Three agents worked on it in parallel, each on its own branch:

- **Kongs in The Lion King.** Dixie or Kiddy Kong replaces Simba. Their graphics are read straight from the DKC3 cartridge, drawn into Simba's spot in video memory with their own colors, and put back after each frame is drawn.
- **Simba in DKC3.** The reverse: adult Simba stands in for Dixie, cub Simba for Kiddy, inside Donkey Kong Country 3.
- **DKC3's music in The Lion King.** A second sound chip plays the Donkey Kong soundtrack while The Lion King keeps its own sound effects.

One rule held for all three: the skin is paint, nothing more. With the option on, the game's memory stays byte for byte the same as with it off. Only the picture or the sound changes, so the gates still apply and the speedruns still finish.

![Two frames of the Pride Lands: on the left Simba leaps toward the rocks, on the right Dixie Kong in the same spot](/assets/images/posts/tlkrecomp/mashup-dixie.png)
*Same frame, two skins: Simba and Dixie Kong.*

![Kiddy Kong hanging from a vine under the SIMBA'S DESTINY title, in the night jungle](/assets/images/posts/tlkrecomp/mashup-kiddy.png)
*Kiddy Kong in Simba's Destiny.*

![Three pairs from DKC3's demo, Kongs on the left and Simba on the right: in the mill, in the forest next to a barrel, and hanging from a rope over water](/assets/images/posts/tlkrecomp/mashup-simba-dkc3.png)
*The other way round: Simba in Donkey Kong Country 3. The Kongs on the left, Simba on the right.*

It's rough. The game still runs the Kongs, so Simba moves with their physics and their hitboxes, and poses DKC3 has but The Lion King doesn't (rolling, swimming, getting hurt) fall back to standing still. On the rope, adult Simba hangs like a stretched rug. All three live on branches, not in the release.

## Thanks

To the speedrunners EZGames69, SBDWolf, Akiteru and ShgofcTAS: your runs were the map and the answer key. Your names are in the README next to your runs. And to [TASVideos](https://tasvideos.org), which publishes those runs under [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/).

To [BizHawk](https://github.com/TASEmulators/BizHawk) and its bsnes core, the reference every byte was checked against.

To [snesrecomp](https://github.com/RetroPortingToolKit/snesrecomp), and to its author, [Matthew Stanley](https://github.com/mstan), for the advice and for welcoming me to the community. And to the ports that showed the way: [DKC3Recomp](https://github.com/elliotttate/DKC3Recomp) by [elliotttate](https://github.com/elliotttate) and [MegaManXSNESRecomp](https://github.com/mstan/MegaManXSNESRecomp).

And to my family, for their patience with glitchy builds and gameplay videos recorded on my phone.

The code is at [github.com/kinduff/TLKRecomp](https://github.com/kinduff/TLKRecomp), and downloads are on the [releases page](https://github.com/kinduff/TLKRecomp/releases/latest). Bring your own cartridge: the repository holds no ROM and no game data, and the project is never sold. snesrecomp's license allows noncommercial use only.
