This repo serves as a template for new repos created in gnlab (Ganong-Noel lab). 

New repos by default include a set of agentic coding tools. (It distinct from our [lab wiki with guides for RAs and undergraduates](https://github.com/uchicago-bfi-gnlab/lab_manual/wiki).)

Instructions for creating repositories from a template are on [this](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) github docs page. 

#### How does this template keep track of empty directories (e.g., `/analysis/source/`)?
- Note that git can't push empty directories -- it can only track files. (See e.g. [here](https://git.wiki.kernel.org/index.php/Git_FAQ#Can_I_add_empty_directories.3F).)
- To circumvent this issue, I have used the command
```
find . -type d -empty -exec touch {}/.gitkeep \;
```
which creates an empty `.gitkeep` file inside each empty directory, forcing git to track the empty directories. 
