# directory.nvim
Plugin to be able to switch between repos of the same project.

The idea of this plugin is to be able to change the working directory depending on which project you are on.

## Instalation



## Configuration
``` lua
require("directory").setup({
    projects = {
        ["one/project"] = {
            { path = "~/one/project/frontend", match = "frontend" },
            { path = "~/one/project/backend", match = "backend" },
        },
        ["another/project"] = {
            { path = "~/another/project/frontend", match = "frontend" },
            { path = "~/another/project/backend", match = "backend" },
        }
    },
    global_settings = {
        -- save the current buffer and loads it again when switching back to that repo
        save_current_buffer = true,
        -- if there is no current buffer then the default buffer command is used
        default_buffer = "e .",
        -- After changing directories the after_change function is called
        after_change = function () 
          -- do someting after directory has been changed
          require("harpoon.term").clear_all()
        end
    }
})
```
The setup function recieves an array of projects, each project has a key that is the path that is going to be matched with the current working directory and used to navigate.
Each project has and array of repositories. Each repository has:
1. A path that is going to used when changing directories.
2. A match field that is going to be used to fetch that repository comparing it with the current working directory


### Navigating
```vim
nnoremap <leader>na :lua require("directory").change_directory(1)<CR>,
nnoremap <leader>ns :lua require("directory").change_directory(2)<CR>,
```
You can have one remap for each repository. `change_directory` receives an index an that index is the one that it's going to take from the current_project array.
In this way you can use the same remaps for switching repositories in different projects

**Example**:
- If the current working directory matches  "one/project" `change_directory(1)` will change the current directory to `~/one/project/frontend`
- If the current working directory matches  "another/project" `change_directory(2)` will change the current directory to `~/one/project/backend`

### Telescope extension
This plugin also comes with a telescope extension to be able to change directories base on a list of directories.

In order to load the list of directory set the array in the setup function
```lua
require("directory").setup({
    ...
    directories = {
        "~/one/project/frontend",
        "~/one/project/backend",
        "~/another/project/frontend",
        "~/another/project/backend",
    },
    ...
})
```

First you have to load the extension
```lua
require("telescope").load_extension("directory")
```

Then you can open it both with a remap or with in the command section
```vim
:Telescope directory directory

noremap <leader>pd :lua require("telescope").extensions.directory.directory()<CR>
```



