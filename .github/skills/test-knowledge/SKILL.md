---
name: test-knowledge
description: "Generates a quiz to test the user's knowledge of a codebase or script. Supports two modes: script-specific (deep dive on one script, invoke with a script path) and whole-project (architecture, design choices, pipeline, invoke with `project`). Reads actual source files, git history, and directory structure before generating questions."
---

# Test Knowledge Skill

You goal is to help a data science team that primarily writes Python and R scripts for data manipulation, cleaning, transformation, and analysis. A growing concern is that with the use of AI to create code, the understanding of the code by researchers may be diminishing. Your primary goal is to develop a test for the user that assess the understanding of their understanding of the code logic and structure. This is a recipe for cognitive debt: The goal is for the user to know just how bad the cognitive debt truly is.

## Workflow

When asked to add knowledge quizzes to a script/project, do the following:

### Step 1: Thoroughly understand the script

**You MUST thoroughly explore the project before generating any questions.** Do not rely on cached or assumed knowledge. Perform ALL of the following steps before writing a single question:

1. **Read the project README** (`readme.md` or equivalent) to understand the project's purpose, pipeline, and data flow.
2. **List the full directory structure** of the workspace to understand how code, data, configuration, and output are organized.
3. **Identify and read key instruction files** (any `*.instructions.md`, `agent.md` or other relevant files in `.github/`) to understand project conventions and rules.
4. **Read the target script(s) in full** — never skim or summarize from memory. Read the actual file contents line by line.
5. **Check recent git history**: run `git log` and `git diff` (or similar) to understand what has changed recently. If a specific script is the target, run `git log -- <path>` for that file.
6. **Read related or upstream/downstream scripts** referenced by or connected to the target. For example, if quizzing on script `example_script.r`, also read any scripts that are called in it, and any upstream build scripts that produce its inputs.
7. **Read helper function files** (`funcs/` directories) that the target script calls.
8. **Examine output files** in `release/` to understand what the script produces.

Only after completing all of these steps should you proceed to question generation.

### Step 2: Identify parts of the code to test
You should develop the quizzes that you think are valuable in assessing a user's comprehension of the code logic and structure. This includes both larger-picture questions as well as more gritty details. It is especially helpful to focus on parts of the code that are complex, very critical to the overall purpose of the code and final output, and susceptible to misunderstanding and bugs.

### Step 3: Identify specific questions
- Based on the parts of the code you think are important to understand from Step 2, determine the most effective ways to test this knowledge.
- Assume (unless specified by the user) that there should be mixture of general questions that test understanding of the overall logic and structure of the code as well as more specific questions that test understanding of specific details of the code.

A few example topics you might want to ask about:

- **Algebraic expressions of equations estimated**
- **Important decisions in the code** (e.g. decisions where the code does it one way but the code *could* plausibly have been written another way instead).
- **How edge cases are handled**

Do **not** write questions about syntax, variable names etc. Unless otherwise specified by the user, generate 20 multiple choice questions (with only one correct answer) and 20 open-ended questions.

### Step 4: Grading

The user will return a list of answers to you, either in the markdown document, or in the chat window. You should grade each question individually. For each question the user got wrong, explin what the error is, and what the correct answer is, linking to specific parts of the code/project. You should then include a summary of the areas of the code that the user should focus on understanding better.

## Mode Selection

The quiz should have two modes: script-specific (triggered when the user provides a specific script path or filename, e.g. `/test_knowledge pgm/foo.r`), and whole-project (default, or triggered if the user types e.g., `/test_knowledge project_name`). Questions for script-specific analysis should foc us on important decisions and details within the script, while project-wide analysis should put more emphasis on the overarching pipeline and architecture.

## Interaction Flow Summary

```
1. User invokes /test_knowledge [script path | "project"]
2. Agent determines mode (script-specific or whole-project)
3. Agent performs deep context extraction:
   a. Read README and instruction files
   b. List and explore directory structure
   c. Read target script(s) and all related files in full
   d. Check git log and recent diffs
   e. Read helper functions and output files
4. Agent generates a quiz in the form of a markdown file
6. User responds with answers, either in the `.md` file or in the chat window
7. Agent grades each answer against actual code, providing explanations and code references for incorrect answers
8. Agent provides overall summary and areas of improvement
```
