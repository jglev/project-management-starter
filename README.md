# Dissertation Project Management Intro

## Visual Studio Code + RStudio

### Setup

1. Install [Visual Studio Code](https://code.visualstudio.com/) ("VSCode") for your Operating System.
1. Install the "`org-checkbox`" extension:
   1. Open VSCode.
   1. In VSCode, type `Cmd/Ctrl + Shift + P`, then "`Extensions: Install Extensions`", and press Enter.
   1. In the Extensions sidebar that pops up, type "`org-checkbox`". You should see one by `publicus`. Click "Install".
1. Install [RStudio](https://rstudio.com/products/rstudio/download/) for your Operating System.

### Open this directory in VSCode

1. Open VSCode
1. Click `File -> Open Workspace...`
1. Navigate to and select this directory.

#### VSCode keyboard shortcuts

##### Using the interface

| Function          | Keyboard Shortcut | Command Palette (`⌘ + Shift + P`) command |
| ----------------- | ----------------- | ----------------------------------------- |
| Show/Hide sidebar | `⌘ + B`           | `View: Focus into Sidebar`                |
| Fold              | `⌥ + ⌘ + [`       | `Fold`                                    |
| Unfold            | `⌥ + ⌘ + ]`       | `Unfold`                                  |

##### Editing files:

| Function                   | Keyboard Shortcut | Command Palette (`⌘ + Shift + P`) command |
| -------------------------- | ----------------- | ----------------------------------------- |
| Find                       | `⌘ + F`           | `Find`                                    |
| Replace                    |                   | `Replace`                                 |
| Find all (across files)    | `⌘ + Shift + F`   | `Search: Find in Files`                   |
| Replace all (across files) | `⌘ + Shift + h`   | `Search: Replace in Files`                |

##### Command Palette functions

| Function                                    | Keyboard Shortcut | Command Palette prefix |
| ------------------------------------------- | ----------------- | ---------------------- |
| Run command                                 | `⌘ + Shift + P`   | `>`                    |
| Search for and open a file in the directory | `⌘ + P`           | `(no prefix)`          |

### Open the Dashboard in RStudio

1. Open [`dashboard/dashboard.Rproj`](dashboard/dashboard.Rproj) using RStudio:
   1. Open RStudio
   1. In RStudio, click `File -> Open Project...`.
   1. Navigate to and select `dashboard.Rproj`.
1. In RStudio, open [`dashboard/dashboard.Rmd`](dashboard/dashboard.Rmd), with `File -> Open File...`
1. Click the "`Knit`" button, or click `File -> Knit Document`.

## OpenProject

### Setup

1. Install [`docker-compose`](https://docs.docker.com/compose/install/#install-compose) for your Operating System.
1. Install [Visual Studio Code](https://code.visualstudio.com/) for your Operating System.

### Start and open OpenProject

1. Run `start.sh`
1. Wait a few minutes, then go to http://localhost:8080/ in your web browser.
1. Sign in with username `admin` and password `admin`. You will be asked to create a new password.

## Additional reference material

- [Introduction to **Markdown**](https://guides.github.com/features/mastering-markdown/)
- [`org-checkbox` VSCode extension key](key.md)
