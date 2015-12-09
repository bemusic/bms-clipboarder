# bms-clipboarder [![Build status](https://ci.appveyor.com/api/projects/status/vn6bgwn40prrd1h1?svg=true)](https://ci.appveyor.com/project/dtinth/bms-clipboarder)


### Make BMS faster with BMS clipboard scripts [WORK IN PROGRESS]


## 1. Introduction

BMS Clipboard Scripts are small programs that operate on clipboard data of a BMS editor.
Combined with AutoHotKey, you can create BMS notecharts faster.

__Note:__ These scripts only work with iBMSC. Pull requests to make it work with BMSE is welcome.


## 2. Included Tools

### 2.1 <kbd>Ctrl</kbd> <kbd>M</kbd> move notes

This tool lets you move selected notes easily by typing the desired key sequence.

![Imgur](http://i.imgur.com/1RJh6F0.gif)


### 2.2 <kbd>Ctrl</kbd> <kbd>B</kbd> bgmize

This tool moves notes back to BGM lanes.
It can be useful for creating 差分BMS (custom charts).

![Imgur](http://i.imgur.com/s1SbrDK.gif)


### 2.3 <kbd>Ctrl</kbd> <kbd>D</kbd> unmatch notes

This tool is to be used with [BMS Sound Matcher](http://bemuse.ninja/bms-tools/compiler.html).
It copies the notes in BGM lane into keysound reference in player lane.




## 3. Technical Information

__bms-clipboarder__ consists of two main parts:

1. bms-clipboarder shell (written in AutoHotKey)

2. Individual tools (written in Haskell, but possible to write using other languages)


### 3.1 bms-clipboarder shell

This is an AutoHotKey script that listens to hotkeys.
When the key is pressed, firstly, it sends <kbd>Ctrl+X</kbd>/<kbd>Ctrl+C</kbd> key to copy/paste notes.
Secondly, it invokes an individual tool, sending the data from clipboard.
Lastly, it copies the result from the individual tool into clipboard and sends <kbd>Ctrl+V</kbd> key to paste notes.

You can change the keyboard shortcut AND÷OR add more tools by editing __BMS Clipboarder.ahk__ file.


### 3.2 Individual tools

This is a command-line program that reads BMS clipboard data from Standard Input,
and return resulting clipboard data to Standard Output.

Although these tools are written in Haskell, __you can create extra tools in any language__.
You only need to make sure that it obeys the input/output format.

Haskell is chosen because:

- It can be compiled into `.exe` files very easily.
- It has a very smart type system, which means shorter code.
- It has a strong type system, which helps makes less bug-prone code.


#### Input Format

- Input format is the clipboard data from BMS editor (right now, it only supports iBMSC).


#### Output Format

- __First line:__ Must be "ok" or "error", indicating the result.

- __Second line:__ Success or error message.

- __Subsequent lines:__ Modified clipboard data.


#### Example

Given the following `input.txt`

```
iBMSC Clipboard Data xNT
9 0 8720000 0 0
8 24 8730000 0 0
9 48 8740000 0 0
10 60 8750000 0 0
9 84 8760000 0 0
10 108 8770000 0 0
11 132 8780000 36 0
8 192 8790000 0 0
8 216 8800000 0 0
8 240 8810000 0 0
10 252 8820000 0 0
11 276 8830000 0 0
```

When run the following command:

```
dist\build\BGMize\BGMize.exe < input.txt
```

It will print out:

```
ok
Moved notes!
iBMSC Clipboard Data xNT
26 276 8830000 0 0
26 252 8820000 0 0
26 240 8810000 0 0
26 216 8800000 0 0
26 192 8790000 0 0
26 132 8780000 0 0
26 108 8770000 0 0
26 84 8760000 0 0
26 60 8750000 0 0
26 48 8740000 0 0
26 24 8730000 0 0
26 0 8720000 0 0
```


## 4. Development

To work on individual tools, you need to install Haskell Platform.
To compile the source codes into `.exe` files, run:

```
cabal build
```
