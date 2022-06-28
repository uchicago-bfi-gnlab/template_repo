# template_repo
This repo serves as a template for new repos created in gnlab.

### Creating a new repo using this template
1. Navigate to `<> Code` page of this [repo](https://github.com/ganong-noel/template_repo). 
2. Click on `Use this template`. 
3. Proceed as usual. 


- Detailed instructions are on [this](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) github docs page. 


#### How does this template keep track of empty directories (e.g., `/analysis/source/`)?
- Note that git can't push empty directories -- it can only track files. (See e.g. [here](https://git.wiki.kernel.org/index.php/Git_FAQ#Can_I_add_empty_directories.3F).)
- To circumvent this issue, I have used the command
```
find . -type d -empty -exec touch {}/.gitkeep \;
```
which creates an empty `.gitkeep` file inside each empty directory, forcing git to track the empty directories. 
