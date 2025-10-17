---
allowed-tools: Bash(julia --version), Bash(julia -e:*), Bash(mkdir -p:*), Bash(mv:*), Bash(git init:*), Write
description: Initialize a comprehensive Julia package development environment optimized for Claude Code workflow. Creates a structured project with separate design/, resources/, and dev-note/ directories for multi-agent collaboration (jl-explorer, jl-critic, jl-implementer, jl-tester, jl-benchmarker, jl-documenter). Includes CLAUDE.md to desribe the project, session continuity support, and how to follow Julia community standards.
argument-hint: <PackageName.jl> <Description>
---

# Prerequisite

Before execution, "$1" should be camel case string and not be ended with ".jl". For example, instead of "new-benchmark", "NewBenchmark" is correct. "NewBenchmark.jl" is not acceptible. If it do not satify that, do not execute it and terminate this process.

# Context

## 1. Confirm Julia exists.
Check the julia command exist using !`julia --version`.
When emitting not found error, please inform the user to "install Julia first" and terminate this process.

## 2. Create directory structure.

Create all required directories:

```bash
# design
mkdir -p design/01-exploration
mkdir -p design/02-critique
mkdir -p design/03-architecture
# resources
mkdir -p resources/code-examples/similar-packages
mkdir -p resources/code-examples/algorithms
mkdir -p resources/code-examples/patterns
mkdir -p resources/documentation/internal-specs
mkdir -p resources/documentation/api-drafts
mkdir -p resources/documentation/technical-notes
mkdir -p resources/data/benchmark-data
mkdir -p resources/data/test-cases
mkdir -p resources/data/validation-data
mkdir -p resources/external/papers
mkdir -p resources/external/reference-libs
mkdir -p resources/external/competitor-analysis
# dev-note
mkdir -p dev-note
```

Create dev-note template files:

```bash
echo "# jl-implementer Development Notes

[Track implementation progress here]" > dev-note/implementer-notes.md

echo "# jl-tester Insights

[Track testing discoveries here]" > dev-note/tester-insights.md

echo "# jl-benchmarker Findings

[Track performance insights here]" > dev-note/benchmarker-findings.md

echo "# Session Log

[Track cross-session continuity here]" > dev-note/session-log.md

echo "# Ideas Parking

[Park future enhancement ideas here]" > dev-note/ideas-parking.md
```

Generate Julia package, rename it, and create additional directories:

```bash
julia -e "using Pkg; Pkg.generate(\"$1\")"
mv "$1" "$1.jl"
mkdir -p "$1.jl/test"
mkdir -p "$1.jl/benchmark"
mkdir -p "$1.jl/docs/src"
```

Initialize git repositories:

```bash
git init
git init "$1.jl/"
```

## 3. Generate CLAUDE.md

Generate CLAUDE.md with the content below.

```Markdown
# Project

See @$1.jl/README.md for project overview.

## Project Structure & Agent Coordination

### Directory Structure
```
project-root/
├── design/                          # Private design repository
│   ├── 01-exploration/             # jl-explorer outputs
│   │   ├── ecosystem-analysis.md
│   │   ├── competitive-landscape.md
│   │   └── technical-requirements.md
│   ├── 02-critique/                # jl-critic outputs  
│   │   ├── design-review.md
│   │   ├── risk-assessment.md
│   │   └── claude-code-suitability.md
│   └── 03-architecture/            # jl-implementer outputs
│       ├── package-structure.md
│       ├── api-design.md
│       ├── type-system-design.md
│       └── dependency-strategy.md
├── resources/                       # Private resources & reference materials
│   ├── code-examples/              # Reference implementations & snippets
│   │   ├── similar-packages/       # Code from similar Julia packages
│   │   ├── algorithms/             # Algorithm implementations to reference
│   │   └── patterns/               # Useful Julia coding patterns
│   ├── documentation/              # Private docs & specifications
│   │   ├── internal-specs/         # Internal specifications & requirements
│   │   ├── api-drafts/             # API design drafts & iterations
│   │   └── technical-notes/        # Technical research & analysis
│   ├── data/                       # Test data & benchmarking datasets
│   │   ├── benchmark-data/         # Datasets for performance testing
│   │   ├── test-cases/             # Complex test scenarios & edge cases
│   │   └── validation-data/        # Data for algorithm validation
│   └── external/                   # External resources & dependencies
│       ├── papers/                 # Academic papers & research materials
│       ├── reference-libs/         # External library code for reference
│       └── competitor-analysis/    # Analysis of competing solutions
├── dev-note/                       # Development memory & ideas storage
│   ├── implementer-notes.md        # jl-implementer progress & ideas
│   ├── tester-insights.md          # jl-tester discoveries & patterns
│   ├── benchmarker-findings.md     # jl-benchmarker optimizations & results
│   ├── session-log.md              # Cross-session continuity tracking
│   └── ideas-parking.md            # Future enhancement ideas & inspiration
├── $1.jl/                          # Public Julia package repository
│   ├── src/                        # jl-implementer responsibility
│   ├── test/                       # jl-tester responsibility
│   ├── benchmark/                  # jl-benchmarker responsibility
│   ├── docs/                       # jl-documenter responsibility
│   ├── Project.toml
│   └── README.md
└── CLAUDE.md                       # This file - project command center
```

### Agent Responsibilities & Directory Ownership

#### Phase 1: Design (Private Repository)
- **jl-explorer**: Creates analysis in @design/01-exploration/ + leverages @resources/ for research
- **jl-critic**: Reviews @design/01-exploration/ and writes critiques in @design/02-critique/
- **jl-implementer**: Finalizes architecture in @design/03-architecture/ + uses @resources/code-examples/patterns/

#### Phase 2-4: Development (Public Repository + Memory + Resources)
- **jl-implementer**:
  - Primary: @$1.jl/src/ directory
  - Memory: @dev-note/implementer-notes.md
  - Resources: Can reference @resources/code-examples/ and @resources/documentation/
  - Can reference design/ outputs for guidance
  
- **jl-tester**:
  - Primary: @$1.jl/test/ directory
  - Memory: @dev-note/tester-insights.md
  - Resources: Can use @resources/data/test-cases/ for complex testing scenarios
  - Does NOT modify @$1.jl/src/ - stays in testing domain
  
- **jl-benchmarker**:
  - Primary: @$1.jl/benchmark/ directory
  - Memory: @dev-note/benchmarker-findings.md
  - Resources: Can use @resources/data/benchmark-data/ for performance testing
  - Does NOT modify @$1.jl/src/ - stays in benchmarking domain

- **jl-documenter**:
  - Primary: @$1.jl/docs/ directory
  - Secondary: @$1.jl/src/ (docstrings only)
  - Resources: Can reference @resources/documentation/ for examples and templates
  - Specializes in Documenter.jl workflow and implementation

#### All Agents: Resource Access Guidelines
- **Read-only access** to @resources/ directory
- Use resources for reference, inspiration, and validation
- Do NOT modify or add files to @resources/ during development
- Document useful resources found in your dev-note/ files for future reference

### Cross-Session Continuity Protocol

#### Session Startup Routine
1. **Read this CLAUDE.md** for project overview and current status
2. **Check @dev-note/session-log.md** for last session context
3. **Review your agent-specific notes** in dev-note/
4. **Reference design/ outputs** if needed for requirements
5. **Explore relevant resources/** for additional context
6. **Begin work** with full context restored

#### Session Ending Routine
1. **Update your agent-specific dev-note/ file** with progress and insights
2. **Update @dev-note/session-log.md** with session summary
3. **Document useful resources** discovered during work

#### Cross-Agent Communication
- Leave notes for other agents in your @dev-note/ files
- Check other agents' notes before starting your work
- Reference shared @resources/ for common understanding
- Coordinate through @dev-note/ rather than direct file conflicts

## Development Guidelines

Each specialized agent has detailed expertise and guidelines. Refer to their prompts for specific instructions:

- **Code standards, REPL philosophy, error handling, display policy**: See jl-implementer agent
- **Testing strategy and comprehensive test suite implementation**: See jl-tester agent
- **Documentation with Documenter.jl and docstring standards**: See jl-documenter agent
- **Performance benchmarking and optimization analysis**: See jl-benchmarker agent
- **Ecosystem exploration and competitive analysis**: See jl-explorer agent
- **Design critique and AI-assisted development suitability**: See jl-critic agent

## Notes for Claude Code Usage

### Context Management
- Always reference this CLAUDE.md first for project understanding
- Use @dev-note/ files to maintain context across sessions
- Leverage @design/ outputs for architectural decisions
- Explore @resources/ for additional context and examples
- Keep public package clean and professional

### Subagent Coordination
- Each agent has clear directory ownership boundaries
- Cross-agent communication happens through @dev-note/ files
- No direct file conflicts - each agent stays in their domain
- jl-implementer is the only agent modifying core @$1.jl/src/ functionality
- All agents can reference @resources/ for additional context

### Quality Gates
- All public code follows Julia community standards
- Private design process can include experimental approaches
- REPL experience is prioritized throughout development
- Performance is considered from architectural level
- Resources are used for validation and inspiration

```

## 4. Generate README.md

Generate @$1.jl/README.md for the Julia package referring the template below. The place denoted by '[...]' in the package should be replaced in accordance with the package name $1.jl and the description ($2).
````Markdown
# $1.jl

Note: 🚧 This package is under active development. APIs may change without notice.

[Brief one-line description]

## Overview

[Expand on the description to explain what this package does and why it exists]

## Installation

This package is currently under development. Once registered, you can install it using Julia's package manager:
```julia
using Pkg
Pkg.add("[PackageName]")
```

For development version:
```julia
using Pkg
Pkg.add(url="https://github.com/[YourUsername]/[PackageName].jl")
```

## Quick Start
```julia
using [PackageName]

# [Simple example demonstrating basic usage based on package purpose]
```

````