---
allowed-tools: Bash(julia --version), Bash(julia -e:*), Bash(test -d:*), Bash(mkdir -p:*), Bash(mv:*), Bash(git init:*), Bash(cat:*), Write
description: Initialize a comprehensive Julia package development environment with XP workflow. Creates iterations/, pairing-artifacts/, spikes/ for XP iterations, plus resources/ directory. Automatically generates PROGRESS.md for TODO tracking and CLAUDE.md as project command center. Supports creating new packages or wrapping existing ones.
argument-hint: <PackageName> [Description]
---

# Prerequisite

Before execution, "$1" should be camel case string and not be ended with ".jl". For example, instead of "new-benchmark", "NewBenchmark" is correct. "NewBenchmark.jl" is not acceptible. If it do not satify that, do not execute it and terminate this process.

# Context

## 1. Confirm Julia exists.
Check the julia command exist using !`julia --version`.
When emitting not found error, please inform the user to "install Julia first" and terminate this process.

## 2. Check package existence based on description parameter.

- Check that "$1.jl/" directory does whether exist using the following command:
```bash
test -d "$1.jl" && echo "EXISTS" || echo "NOT_EXISTS"`
```

**If description ($2) is provided** (creating new package):
- If "$1.jl/" exists, inform user "Package $1.jl already exists. Cannot create new package." and terminate
- Proceed with full setup including package generation

**If description ($2) is NOT provided** (wrapping existing package):
- If "$1.jl/" doesn't exist, inform user "Package $1.jl not found. Please provide description to create new package." and terminate
- Proceed with setup but SKIP package generation and README creation

## 3. Create directory structure.

Create all required directories:

```bash
# XP iteration structure
mkdir -p iterations
mkdir -p spikes
# resources
mkdir -p resources/code-examples/similar-packages
mkdir -p resources/code-examples/algorithms
mkdir -p resources/code-examples/patterns
mkdir -p resources/documentation/internal-specs
mkdir -p resources/documentation/api-drafts
mkdir -p resources/documentation/technical-notes
mkdir -p resources/data/test-cases
mkdir -p resources/data/validation-data
mkdir -p resources/external/papers
mkdir -p resources/external/reference-libs
mkdir -p resources/external/competitor-analysis
```

Create PROGRESS.md:

```bash
cat > PROGRESS.md << 'PROGRESS_EOF'
# Project Progress

*Current work tracked in: `iterations/iter-initial-setup/`*

## TODO Backlog

**Format:**
\`\`\`
### Task Name
[tag]
Why: Explanation of why this is needed
\`\`\`

**Available tags (sorted by typical importance):**

| Tag | Definition | When to use |
|-----|------------|-------------|
| \`bug\` | Something is broken or incorrect | Crashes, errors, wrong behavior |
| \`feature\` | New functionality | Adding new capabilities users can use |
| \`perf\` | Performance optimization | Speed, memory, or efficiency improvements |
| \`improvement\` | Enhance existing feature | Make something work better without changing core behavior |
| \`refactor\` | Code restructuring | Clean up implementation without changing functionality |
| \`test\` | Testing infrastructure | Test coverage, CI/CD, test tools |
| \`docs\` | Documentation | README, guides, API docs, docstrings |
| \`chore\` | Maintenance tasks | Dependencies, tooling, cleanup |

*Note: Actual priority depends on context - a critical \`perf\` issue may be more urgent than a minor \`bug\`*

---

### Implement core functionality
[feature]
Why: Users need basic functionality to get started

### Add test suite
[test]
Why: Need automated testing before accepting contributions

### Write documentation
[docs]
Why: Help users understand how to use the package
PROGRESS_EOF
```

Initialize git repositories:

```bash
git init
```

**If description ($2) is provided** (creating new package):

Generate Julia package, rename it, create additional directories, and initialize git inside:

```bash
julia -e "using Pkg; Pkg.generate(\"$1\")"
mv "$1" "$1.jl"
mkdir -p "$1.jl/test"
mkdir -p "$1.jl/docs/src"
git init "$1.jl/"
```

## 4. Generate CLAUDE.md

Generate CLAUDE.md with the content below.

```Markdown
# Project

See @$1.jl/README.md for project overview.

## Project Structure & Agent Coordination

### Directory Structure
```
project-root/
├── PROGRESS.md                      # TODO backlog with tagged tasks
├── iterations/                      # XP iteration cycles
│   ├── iter-feature-name/          # Descriptive iteration names
│   │   ├── planning.md             # User stories, tasks for this iteration
│   │   ├── test-failures.md        # RED phase - failing tests
│   │   ├── implementation.md       # GREEN phase - make tests pass
│   │   ├── refactor-notes.md       # REFACTOR phase - improve code
│   │   └── retrospective.md        # What we learned
│   └── ...                         # Keep last 3-10, archive older ones
├── spikes/                          # Timeboxed research experiments
├── resources/                       # Private resources & reference materials
│   ├── code-examples/              # Reference implementations & snippets
│   │   ├── similar-packages/       # Code from similar Julia packages
│   │   ├── algorithms/             # Algorithm implementations to reference
│   │   └── patterns/               # Useful Julia coding patterns
│   ├── documentation/              # Private docs & specifications
│   │   ├── internal-specs/         # Internal specifications & requirements
│   │   ├── api-drafts/             # API design drafts & iterations
│   │   └── technical-notes/        # Technical research & analysis
│   ├── data/                       # Test data & validation datasets
│   │   ├── test-cases/             # Complex test scenarios & edge cases
│   │   └── validation-data/        # Data for algorithm validation
│   └── external/                   # External resources & dependencies
│       ├── papers/                 # Academic papers & research materials
│       ├── reference-libs/         # External library code for reference
│       └── competitor-analysis/    # Analysis of competing solutions
├── $1.jl/                          # Public Julia package repository
│   ├── src/                        # jl-implementer responsibility
│   ├── test/                       # jl-tester responsibility
│   ├── docs/                       # jl-documenter responsibility
│   ├── Project.toml
│   └── README.md
└── CLAUDE.md                       # This file - project command center
```

### Agent Responsibilities - XP Workflow

#### TDD Cycle (Red-Green-Refactor)
- **jl-tester**: Writes failing tests FIRST in @$1.jl/test/, defines API through test expectations
  - Documents test approach in @iterations/[current]/test-failures.md
  - Uses @resources/data/test-cases/ for complex scenarios

- **jl-implementer**: Makes tests pass in @$1.jl/src/, implements minimal code to satisfy tests
  - Documents implementation in @iterations/[current]/implementation.md
  - Documents refactoring in @iterations/[current]/refactor-notes.md
  - References @resources/code-examples/patterns/

- **jl-documenter**: Updates docs incrementally in @$1.jl/docs/ alongside implementation
  - Living documentation - update with each iteration
  - Adds docstrings to @$1.jl/src/ (only location documenter touches src/)
  - Uses @resources/documentation/ for templates

#### Just-in-Time Research & Review
- **jl-explorer**: Task decomposition and quick ecosystem research
  - Breaks complex requests into small, independent iterations (1-3 days each)
  - Identifies which subtasks are independent vs. dependent
  - Conducts just-in-time research for current iteration needs
  - Stores findings in @spikes/
  - Uses @resources/ for reference materials

- **jl-critic**: Reviews design decisions and code quality during iterations
  - Documents architectural decisions in @iterations/[current]/planning.md
  - Evaluates architectural options before tests are written

#### Iteration Management
- Current iteration planning: @iterations/[current]/planning.md
- Backlog: @PROGRESS.md with tagged TODOs
- Retrospectives: @iterations/[current]/retrospective.md
- Keep last 3-10 iterations, archive older ones to git tags

### Cross-Session Continuity Protocol

#### Session Startup Routine
1. **Read this CLAUDE.md** for project overview
2. **Check @PROGRESS.md** to see current iteration and backlog
3. **Read @iterations/[current]/planning.md** for current tasks
4. **Check recent @iterations/ retrospectives** for learnings
5. **Begin work** with full context restored

#### Session Ending Routine
1. **Update current iteration files** (planning.md, implementation.md, etc.)
2. **Update @PROGRESS.md** if completing tasks or iteration

#### Cross-Agent Communication
- **Iteration context**: Current work tracked in @iterations/[current]/
- **Research findings**: Store in @spikes/

## Development Guidelines

Each specialized agent has detailed expertise and guidelines. Refer to their prompts for specific instructions:

- **Code standards, REPL philosophy, error handling, display policy**: See jl-implementer agent
- **Testing strategy and comprehensive test suite implementation**: See jl-tester agent
- **Documentation with Documenter.jl and docstring standards**: See jl-documenter agent
- **Task decomposition, iteration planning, and ecosystem exploration**: See jl-explorer agent
- **Design critique and AI-assisted development suitability**: See jl-critic agent

## Notes for Claude Code Usage

### Context Management
- Always reference this CLAUDE.md first for project understanding
- Check @PROGRESS.md for current iteration and TODO backlog
- Current work tracked in @iterations/[current]/ directory
- Explore @resources/ for additional context and examples
- Check @pairing-artifacts/ for collaboration notes
- Review recent @iterations/ retrospectives for learnings

### XP Workflow
- **Test-first**: jl-tester writes failing tests, jl-implementer makes them pass
- **Pair programming**: Agents collaborate through pairing-artifacts/
- **Short iterations**: Complete features in days, tracked in iterations/
- **Continuous refactoring**: Document in refactor-notes.md
- **Living documentation**: jl-documenter updates incrementally

### Quality Gates
- All public code follows Julia community standards
- Experimental approaches documented in spikes/ and pairing-artifacts/
- REPL experience is prioritized throughout development
- Performance considered from iteration planning
- Retrospectives capture learnings for continuous improvement

```

## 5. Generate README.md (only if description is provided)

**If description ($2) is provided** (creating new package):

Generate @$1.jl/README.md for the Julia package referring the template below. The place denoted by '[...]' in the package should be replaced in accordance with the package name $1.jl and the description ($2).
````Markdown
# $1.jl

Note: 🚧 This package is under active development. APIs may change without notice.

[Brief one-line description]

## Overview

[Expand on the description to explain what this package does and why it exists]

## Installation

This package is currently under development. You can install it using Julia's package manager:

```julia
using Pkg
Pkg.add(url="https://github.com/[YourUsername]/$1.jl")
```

````