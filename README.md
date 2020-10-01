# Single-Worker Project Management Intro

This repository provides a conceptual framework and two concrete approaches (one using [R](https://rstudio.com/) [recommended]; the other using [OpenProject](https://www.openproject.md/)) for managing large projects where you are the sole worker. This repository was created in response to being asked how to conceptualize writing a dissertation: specifically, how to approach a project so large it is impossible to hold completely in mind at once, and how to incentivize oneself to work on the project.

## General ideas

### Four major elements around which to build manage a large project

- Task dependency / hierarchy
- Task statuses
- Remembering when a task needs to be done
- Remembering when to start working on a task

### Goals to keep in mind for facilitating storing and using knowledge about tasks

- Notes should ideally be organized alongside related notes
- Notes should ideally be able to be easily re-compiled alongside _unrelated_ notes
- Notes should allow one to understand the timeline of how and when decisions happened

## Reference material for thinking about these topics

- [Introduction to **Markdown**](https://guides.github.com/features/mastering-markdown/):  
   Markdown is a syntax for formatting plain text, based on how people used to write plain-text emails (for example, to markd something as bold in markdown, one would put \*\*asterisks around it\*\*).
- The ["Bullet Journal" introduction site](https://bulletjournal.com/pages/learn):  
   Bullet Journals are very buzzword-y, and I have seen people (including myself) spend lots of time procrastinating on actually doing work by over-doing making a pretty, over-engineered Bullet Journal system.

  With that said, there are a few core ideas that I took away from the website linked above, and continue to use:

  1.  Use a system that has no mental friction to using. Anytime I've bought a $30 journal, I feel like whatever I write in it has to be special, even if subconsciously. It's the same with using special software. So, I just use plain text documents, with special coloring applied on top of them (as described below). My notes are all written in Markdown, but are still just plain text documents. If I'm writing notes by hand, I use an inexpensive (<$10) notebook.

  2.  I name my daily note file "daily-[context].md". Thus, my main notes file is "daily-work-2020-01-01ff.md", and last year's notes are in "daily-work-2019-01-01ff.md", etc. At home, I have "daily-personal.md".

  Similarly, I have "collections" files for things that aren't day-dependent – mainly my master list of tasks to do, "collections-master-project-list.md" (or "collections-dissertation-master-list.md", etc.).

  My daily notes file contains a new section for each day, with tasks copied (not cut, but just copied) from my master todo list, like this:

  ```md
  # 2020-10-01

  - [x] Example task 1

  - Notes that I wanted to record today.
    - Additional notes.

  # 2020-09-30

  - [<] Example task 1
    - I didn't get to this task today, and so will work on it tomorrow.
  ```

  Sometimes, as with a dissertation project, it's not necessary or preferable to have daily notes files, and is instead preferable to just keep all of one's notes about each task indented under that task in the master todo list file, like this:

  ```md
  - [ ] Write dissertation results section
    - [ ] Perform descriptive statistics
    - [ ] Perform inferential statistics
      - [ ] Decide on model approach
        - 2020-10-01:
          - I received permission from my advisor to use model A.
        - 2020-09-30:
          - I started reading about model A. I think that it might be useful to use.
  ```

  3.  The biggest thing that the Bullet Journal idea gave me was the idea that things can be written down in more than one place (across more than one day), and that tasks often take care of themselves and can get cancelled. If I find myself repeatedly not doing a task and copying it forward day by day, eventually I ask whether I should just cancel it, and stop worrying about it.

  Other things from the website above, like the Index, stop being necessary when one can search across all of one's notes. I also don't use the Future Log idea – I have a "Timing" calendar to remind me when to think about things, and my Master list to review periodically. I also haven't found a need for the Monthly Log idea.

- ["`org-mode`"](https://orgmode.org/guide/TODO-Items.html) from the text editor Emacs:  
   My project management preferences were shaped a lot by managing my dissertation-writing process using "org-mode". It uses a different syntax than Markdown, and is difficult enough to set up that I don't recommend that others use it; rather, this repository, including the [`Project_Notes_Example.md`](Project_Notes_Example.md) and the R-based dashboard described below, are my attempt to bring the parts of the org-mode system that I found most useful into other tools that I use more often now, and that others can also start using more easily.

## Tools for a master todo list

### Visual Studio Code + RStudio (Recommended)

The primary approach suggested by these materials is to use a text editor, [Visual Studio Code](https://code.visualstudio.com/), and a data analysis program like [R/RStudio](https://rstudio.com/products/rstudio/download/), to manage projects that are being worked on by one person.

The code in this repository provides a dashboard, written in R:

![documentation/example_screenshots/statuses.png](documentation/example_screenshots/statuses.png)

![documentation/example_screenshots/scheduled.png](documentation/example_screenshots/scheduled.png)

#### Setup

1. Download these files:
   1. Click `Clone -> Download ZIP`.
      ![documentation/example_screenshots/github_clone.png](documentation/example_screenshots/github_clone.png)
   1. Un-zip the downloaded archive.
1. Create a copy of [`Project_Notes_Example.md`](Project_Notes_Example.md), and call it something like `Project_Notes.md`. **This will be the file you use as your global Todo list.**

1. Install [Visual Studio Code](https://code.visualstudio.com/) ("VSCode") for your Operating System.
1. Install the "`org-checkbox`" extension:
   1. Open VSCode.
   1. In VSCode, type `Cmd/Ctrl + Shift + P`, then "`Extensions: Install Extensions`", and press Enter.
   1. In the Extensions sidebar that pops up, type "`org-checkbox`". You should see one by `publicus`. Click "Install".
1. Install [RStudio](https://rstudio.com/products/rstudio/download/) for your Operating System.

#### Open this directory in VSCode

1. Open VSCode
1. Click `File -> Open Workspace...`
1. Navigate to and select this directory.

##### VSCode keyboard shortcuts

###### Using the interface

| Function          | Keyboard Shortcut | Command Palette (`⌘ + Shift + P`) command |
| ----------------- | ----------------- | ----------------------------------------- |
| Show/Hide sidebar | `⌘ + B`           | `View: Focus into Sidebar`                |
| Fold              | `⌥ + ⌘ + [`       | `Fold`                                    |
| Unfold            | `⌥ + ⌘ + ]`       | `Unfold`                                  |

###### Editing files:

| Function                   | Keyboard Shortcut | Command Palette (`⌘ + Shift + P`) command |
| -------------------------- | ----------------- | ----------------------------------------- |
| Find                       | `⌘ + F`           | `Find`                                    |
| Replace                    |                   | `Replace`                                 |
| Find all (across files)    | `⌘ + Shift + F`   | `Search: Find in Files`                   |
| Replace all (across files) | `⌘ + Shift + h`   | `Search: Replace in Files`                |

###### Command Palette functions

| Function                                    | Keyboard Shortcut | Command Palette prefix |
| ------------------------------------------- | ----------------- | ---------------------- |
| Run command                                 | `⌘ + Shift + P`   | `>`                    |
| Search for and open a file in the directory | `⌘ + P`           | `(no prefix)`          |

#### Use the R Dashboard

##### Option 1: Use the version hosted on `shinyapps.io`

In your web browser, go to https://publicus.shinyapps.io/project_management_dashboard/

#### Option 2: Run the dashboard on your own computer, using RStudio

1.  Open [`dashboard/dashboard.Rproj`](dashboard/dashboard.Rproj) using RStudio:
    1. Open RStudio
    1. In RStudio, click `File -> Open Project...`.
    1. Navigate to and select `dashboard.Rproj`.
1.  In RStudio, open [`dashboard/ui.R`](dashboard/dashboard.Rmd), with `File -> Open File...`
1.  _(Only necesssary the first time you run the Dashboard)_ In the RStudio R console, run `renv::restore()` to install extensions that the Dashboard needs.
    - If you are on MacOS and see an error, "`ld: library not found for -lgfortran`", you may need click `Tools -> Terminal -> New Terminal...`, and run `xcode-select --install` to install [XCode](https://developer.apple.com/xcode/ide/) on your system. (This is to be tried after following any directions in the error message.)
1.  Click the "`Run App`" button.

    - Alternatively, from a Unix shell in this repository's top-level directory, you may run

      ```sh
      (cd dashboard && R -e "shiny::runApp('.', port = 8088)")
      ```

      You may then visit your web browser at `http://localhost:8088`.

### OpenProject (for a more complex workflow)

A second approach is to use [OpenProject](https://www.openproject.md/), which is open-source Project Management software for ["Agile" Project Management](https://www.atlassian.com/agile/project-management/epics-stories-themes).

![documentation/example_screenshots/openproject.png](documentation/example_screenshots/openproject.png)

#### Setup

1. Install [`docker-compose`](https://docs.docker.com/compose/install/#install-compose) for your Operating System.
1. Install [Visual Studio Code](https://code.visualstudio.com/) for your Operating System.

#### Start and open OpenProject

1. Run `start.sh`
1. Wait a few minutes, then go to http://localhost:8080/ in your web browser.
1. Sign in with username `admin` and password `admin`. You will be asked to create a new password.
