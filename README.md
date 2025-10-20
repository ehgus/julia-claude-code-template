# Julia Claude Code Template

A comprehensive project template for Julia package development using Claude Code with specialized subagents, designed around Extreme Programming (XP) principles for AI-assisted development.

This is working in progress.

## Philosophy: Extreme Programming for AI Development

This template adapts Extreme Programming practices for AI-assisted Julia package development:

- **Test-Driven Development (TDD)**: The jl-tester agent writes tests first, defining the API through test expectations. The jl-implementer then makes those tests pass with minimal code.
- **Pair Programming**: Agents collaborate in tight pairs throughout development - jl-critic reviews code alongside jl-implementer, jl-tester pairs with jl-implementer in TDD cycles, providing real-time feedback and continuous code review.
- **Simple Design**: The jl-explorer focuses on just-in-time research for immediate needs rather than exhaustive upfront analysis, following YAGNI (You Aren't Gonna Need It).
- **Short Iteration Cycles**: All agents work together in rapid cycles on small features rather than sequential waterfall phases.
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

### 2. Customize Template

``` bash
# Copy `CLAUDE-TEMPLATE.md` into `CLAUDE.md`
cp CLAUDE-TEMPLATE.md CLAUDE.md
```

Edit `CLAUDE.md` and replace all bracketed placeholders with your preferences:

- [Package Name] → Your default package name
- [PackageName.jl] → Your package format
- [Target Domain] → Your focus area (e.g., "Machine Learning", "Scientific Computing")
- [Performance Goals] → Your typical performance requirements
- [Key Dependencies] → Your commonly used packages
- [Julia Version Compatibility] → Your Julia version requirements

### 3. Initialize New Projects

```bash
# Basic usage
julia setup_project.jl MyPackageName
```

## Project Workflow

1. **Design Phase**
   - `jl-explorer`: Analyze ecosystem and requirements
   - `jl-critic`: Review and critique design decisions

2. **Development Phase**
   - `jl-implementer`: Core package implementation
   - `jl-tester`: Comprehensive testing suite
   - `jl-documenter`: Documentation with Documenter.jl

3. **Session Management**
   - All agents use `dev-note/` for cross-session continuity
   - `CLAUDE.md` serves as the project command center
   - Resources in `resources/` provide additional context

## Directory Structure

```
project-name-project/
├── design/                          # Private design repository
│   ├── 01-exploration/             # jl-explorer outputs
│   ├── 02-critique/                # jl-critic outputs  
│   └── 03-architecture/            # jl-implementer outputs
├── resources/                       # Private resources & references
│   ├── code-examples/              # Reference implementations
│   ├── documentation/              # Internal specs & research
│   ├── data/                       # Test & benchmark datasets
│   └── external/                   # Papers & competitor analysis
├── dev-note/                       # Development memory system
│   ├── implementer-notes.md        # jl-implementer session memory
│   ├── tester-insights.md          # jl-tester discoveries
│   ├── session-log.md              # Cross-session continuity
│   └── ideas-parking.md            # Future enhancement ideas
├── PackageName/                     # Public Julia package
│   ├── src/                        # Package source code
│   ├── test/                       # Test suite
│   ├── docs/                       # Documenter.jl documentation
│   └── Project.toml               # Package metadata
└── CLAUDE.md                       # Project command center
```
