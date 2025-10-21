# Julia Claude Code Template

A comprehensive project template for Julia package development using Claude Code with specialized subagents, designed around Extreme Programming (XP) principles for AI-assisted development.

This is working in progress.

## Philosophy: Extreme Programming for AI Development

This template adapts Extreme Programming practices for AI-assisted Julia package development:

- **Test-Driven Development (TDD)**: The jl-tester agent writes tests first, defining the API through test expectations. The jl-implementer then makes those tests pass with minimal code.
- **Role-Based TDD Workflow**: Different agents provide focused perspectives for each phase - jl-tester enforces test-first discipline (RED), jl-implementer focuses on minimal implementation (GREEN) and refactoring, jl-critic provides architectural review. This structured approach ensures separation of concerns and disciplined development.
- **Simple Design**: The jl-explorer decomposes complex requests into small iterations and focuses on just-in-time research for immediate needs rather than exhaustive upfront analysis, following YAGNI (You Aren't Gonna Need It).
- **Short Iteration Cycles**: The jl-explorer breaks large features into independent, iteration-sized subtasks (1-3 days each), enabling rapid cycles and incremental delivery.
- **Living Documentation**: The jl-documenter updates documentation incrementally with each change, keeping it synchronized with the code.

## Features

- **Complete project structure** optimized for Claude Code development
- **Multi-agent workflow** with specialized Julia development agents (jl-explorer, jl-critic, jl-implementer, jl-tester, jl-documenter)
- **XP-based workflow** promoting TDD, continuous refactoring, and short feedback loops
- **Private design repository** for internal development processes
- **Resources directory** for reference materials and private assets
- **Session continuity** through dev-note/ memory system

## Quick Start

### 1. Download Template

```bash
# Clone the template repository
git clone https://github.com/eghus/julia-claude-code-template.git my-julia-template
cd my-julia-template
```

### 2. Initialize New Project

Use the `/init-jl-package` command in Claude Code:

```bash
# Create new package with description
/init-jl-package MyPackageName "A brief description of your package"

# Or wrap existing package (no description)
/init-jl-package MyPackageName
```

This will:
- Set up the XP iteration structure (iterations/, pairing-artifacts/, spikes/)
- Automatically create PROGRESS.md for TODO tracking
- Initialize dev-note/ for session continuity
- Generate CLAUDE.md as project command center
- Set up your Julia package structure (if creating new)

### 3. Start Your First Iteration

```bash
# Create your first iteration
mkdir iterations/iter-initial-setup
# Edit PROGRESS.md and add your TODOs, then start working!
```

## XP Iteration Workflow

The template follows **Extreme Programming (XP)** principles with short iteration cycles:

### Starting an Iteration

1. Create new iteration directory: `iterations/iter-FEATURE-NAME/` (use descriptive names!)
2. Create planning.md and move the iteration description from `PROGRESS.md`.
3. Remove iteration description from `PROGRESS.md`
4. Develop planning.md with user stories and acceptance criteria
5. Use `jl-tester` to write failing tests (RED phase)
6. Use `jl-implementer` to make tests pass (GREEN phase)
7. Refactor and document learnings (REFACTOR phase)

**Naming Convention:** Use descriptive names like `iter-gpu-acceleration`, `iter-error-handling`, not sequential numbers like `iter-001`.

### Completing an Iteration

```bash
# Automated workflow using helper command
/complete-iteration iter-gpu-acceleration "GPU support complete"
```

This will:
- Commit iteration files to git
- Create git tag for historical reference
- Prompt you to update PROGRESS.md

### Managing Iteration History

Keep **last 3-10 iterations** in filesystem for agent context:
```bash
# Archive old iterations (they're preserved in git)
rm -rf iterations/iter-initial-setup/
git add -A
git commit -m "Archive: iter-initial-setup (preserved at git tag)"
```

### Accessing Historical Iterations

Use built-in commands to access git-archived iterations:

```bash
# View recent work
/display-recent-tags 5

# Search for specific topics
/search-iterations "GPU performance"

# View detailed iteration info
/show-iteration iter-type-system
```

### Workflow Summary

1. **TDD Cycles**: `jl-tester` writes tests → `jl-implementer` makes them pass
2. **Sequential Workflow**: Each agent completes their phase independently with clear handoffs
3. **Short Iterations**: Complete small features in days, not weeks
4. **Living History**: Recent iterations visible, old ones in git tags
5. **Continuous Feedback**: Retrospectives inform next iteration

## Directory Structure

```
project-name/
├── PROGRESS.md                      # TODO tracking & current status
├── iterations/                      # Short development cycles (XP iterations)
│   ├── iter-gpu-acceleration/      # Active iteration (descriptive name!)
│   │   ├── planning.md             # User story, acceptance criteria
│   │   ├── test-failures.md        # RED phase - failing tests
│   │   ├── implementation.md       # GREEN phase - make it work
│   │   ├── refactor-notes.md       # REFACTOR phase - make it right
│   │   └── retrospective.md        # What we learned
│   ├── iter-data-validation/       # Keep last 3-10 iterations
│   └── iter-type-system/           # Older ones archived in git
├── spikes/                          # Timeboxed research (XP practice)
│   ├── spike-gpu-acceleration/
│   └── spike-alternative-algo/
├── resources/                       # Private resources & references
│   ├── code-examples/              # Reference implementations
│   ├── documentation/              # Internal specs & research
│   ├── data/                       # Test & benchmark datasets
│   └── external/                   # Papers & competitor analysis
├── dev-note/                        # Development memory system
│   ├── implementer-notes.md        # jl-implementer session memory
│   ├── tester-insights.md          # jl-tester discoveries
│   ├── session-log.md              # Cross-session continuity
│   └── ideas-parking.md            # Future enhancement ideas
├── PackageName/                     # Public Julia package
│   ├── src/                        # Package source code
│   ├── test/                       # Test suite (TDD - tests first!)
│   ├── docs/                       # Documenter.jl documentation
│   └── Project.toml                # Package metadata
└── CLAUDE.md                        # Project command center
```
