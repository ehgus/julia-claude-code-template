---
allowed-tools: Bash(julia:*), Write
description: Initialize a comprehensive Julia package development environment optimized for Claude Code workflow. Creates a structured project with separate design/, resources/, and dev-note/ directories for multi-agent collaboration (jl-explorer, jl-critic, jl-implementer, jl-tester, jl-benchmarker, jl-documenter). Includes CLAUDE.md to desribe the project, session continuity support, and how to follow Julia community standards.
argument-hint: <PackageName.jl> <Description>
---

# Context

## 1. Confirm Julia exists.
Check the julia command exist using !`julia -v`.
When emitting not found error, please inform the user to "install Julia first" and terminate this process.

## 2. Execute Julia script that automatically generate format.

Run the script below that generate Julia project structure.
Run the script with command 'julia -e SCRIPT $1' where SCRIPT will be the script below.

```Julia
#!/usr/bin/env julia

"""
Julia Project Structure Generator (Simplified)

Creates the directory structure from CLAUDE.md template.
Assumes CLAUDE.md template already exists or will be create by other process.

Usage:
    julia setup_project.jl <PackageName>
"""

using Pkg

function create_directory_structure(package_name::String)
    """Create the complete directory structure"""

    # Define the directory structure from CLAUDE.md
    directories = [
        # Design directories
        "design/01-exploration",
        "design/02-critique",
        "design/03-architecture",

        # Resources directories
        "resources/code-examples/similar-packages",
        "resources/code-examples/algorithms",
        "resources/code-examples/patterns",
        "resources/documentation/internal-specs",
        "resources/documentation/api-drafts",
        "resources/documentation/technical-notes",
        "resources/data/benchmark-data",
        "resources/data/test-cases",
        "resources/data/validation-data",
        "resources/external/papers",
        "resources/external/reference-libs",
        "resources/external/competitor-analysis",

        # Dev note directory
        "dev-note",
    ]

    # Create all directories
    for dir in directories
        mkpath(dir)
    end

    # Create Julia package using Pkg.generate (without .jl extension)
    Pkg.generate(package_name)

    renamed_package_name = mv(package_name, package_name*".jl")
    # Create additional package directories
    package_dirs = [
        "$renamed_package_name/test",
        "$renamed_package_name/benchmark",
        "$renamed_package_name/docs/src",
    ]

    # Initialize git
    run(`git init design/`)
    run(`git init $renamed_package_name/`)

    for dir in package_dirs
        mkpath(dir)
    end
end

function create_dev_note_templates()
    """Create minimal dev-note template files"""

    # Simple template files
    templates = [
        "dev-note/implementer-notes.md" => "# jl-implementer Development Notes\n\n[Track implementation progress here]\n",
        "dev-note/tester-insights.md" => "# jl-tester Insights\n\n[Track testing discoveries here]\n",
        "dev-note/benchmarker-findings.md" => "# jl-benchmarker Findings\n\n[Track performance insights here]\n",
        "dev-note/session-log.md" => "# Session Log\n\n[Track cross-session continuity here]\n",
        "dev-note/ideas-parking.md" => "# Ideas Parking\n\n[Park future enhancement ideas here]\n",
    ]

    for (filepath, content) in templates
        open(filepath, "w") do f
            write(f, content)
        end
    end
end

function main()
    if length(ARGS) != 1
        println("Usage: julia setup_project.jl <PackageName>")
        exit(1)
    end

    package_name = ARGS[1]
    println("Creating project structure for $package_name...")

    create_directory_structure(package_name)
    create_dev_note_templates()

    println("Project setup complete")
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    main()
end

```

## 3. Generate CLAUDE.md

Generate CLAUDE.md with the content below.

```Markdown
# Project

See @$1/README.md for project overview.

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
├── $1/               # Public Julia package repository
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
- **jl-explorer**: Creates analysis in `design/01-exploration/` + leverages `resources/` for research
- **jl-critic**: Reviews design in `design/02-critique/` + references `resources/competitor-analysis/`
- **jl-implementer**: Finalizes architecture in `design/03-architecture/` + uses `resources/code-examples/patterns/`

#### Phase 2-4: Development (Public Repository + Memory + Resources)
- **jl-implementer**: 
  - Primary: `$1/src/` directory
  - Memory: `dev-note/implementer-notes.md`
  - Resources: Can reference `resources/code-examples/` and `resources/documentation/`
  - Can reference design/ outputs for guidance
  
- **jl-tester**: 
  - Primary: `$1/test/` directory
  - Memory: `dev-note/tester-insights.md`
  - Resources: Can use `resources/data/test-cases/` for complex testing scenarios
  - **Focus: Unit tests only** - integration tests belong elsewhere
  - **Structure: Mirror src/ hierarchy** - Each `src/file.jl` has corresponding `test/file.jl`
  - `runtests.jl` is the only exception - it orchestrates all tests
  - Does NOT modify src/ - stays in testing domain
  
- **jl-benchmarker**: 
  - Primary: `$1/benchmark/` directory  
  - Memory: `dev-note/benchmarker-findings.md`
  - Resources: Can use `resources/data/benchmark-data/` for performance testing
  - Does NOT modify src/ - stays in benchmarking domain
  
- **jl-documenter**: 
  - Primary: `$1/docs/` directory
  - Secondary: `$1/src/` (docstrings and show methods only)
  - Resources: Can reference `resources/documentation/` for examples and templates
  - Specializes in Documenter.jl workflow and implementation

#### All Agents: Resource Access Guidelines
- **Read-only access** to `resources/` directory
- Use resources for reference, inspiration, and validation
- Do NOT modify or add files to `resources/` during development
- Document useful resources found in your dev-note/ files for future reference

### Cross-Session Continuity Protocol

#### Session Startup Routine
1. **Read this CLAUDE.md** for project overview and current status
2. **Check `dev-note/session-log.md`** for last session context
3. **Review your agent-specific notes** in dev-note/
4. **Reference design/ outputs** if needed for requirements
5. **Explore relevant resources/** for additional context
6. **Begin work** with full context restored

#### Session Ending Routine
1. **Update your agent-specific dev-note/ file** with progress and insights
2. **Update `dev-note/session-log.md`** with session summary
3. **Document useful resources** discovered during work

#### Cross-Agent Communication
- Leave notes for other agents in your dev-note/ files
- Check other agents' notes before starting your work
- Reference shared resources/ for common understanding
- Coordinate through dev-note/ rather than direct file conflicts

## Development Guidelines

### Julia Package Standards
- Follow Julia naming conventions (lowercase with underscores)
- Implement proper multiple dispatch patterns
- Ensure type stability throughout codebase
- Write comprehensive docstrings for all public APIs
- Include performance considerations in design decisions
- Follow semantic versioning for releases

### REPL-First Development Philosophy  
- Optimize for excellent REPL interaction and user experience
- Implement beautiful `show` methods for custom types
- Write docstrings that shine in `?function_name` queries
- Design APIs that feel natural during interactive sessions
- Ensure error messages are clear and actionable
- Avoid excessive try-catch blocks that hide debugging information
- **No premature error handling**: Do NOT add try-catch, fallbacks, or error recovery mechanisms unless explicitly requested
- **Let errors surface**: Clear error messages and stack traces are more valuable than masked failures
- Error handling features (memory profilers, sophisticated error recovery) should only be added when explicitly requested by the user

### Testing & Performance Strategy
- Write comprehensive unit tests using Test.jl in test/ directory
- **Test structure mirrors src/ structure**: Each `src/file.jl` should have `test/file.jl`
- Each test file contains unit tests only for its corresponding src file
- `runtests.jl` orchestrates all test files but doesn't contain tests itself
- Keep unit tests isolated and fast-running
- Integration tests should be separate from test/ directory
- Include edge cases and numerical accuracy validation
- Implement performance benchmarks with BenchmarkTools.jl
- Monitor memory allocations and type stability
- Test across different Julia versions and platforms

### Documentation Requirements
- Use Documenter.jl for all documentation
- Include mathematical notation using LaTeX
- Provide copy-paste ready examples in docstrings
- Create tutorials for common use cases
- Document performance characteristics and complexity

## Notes for Claude Code Usage

### Context Management
- Always reference this CLAUDE.md first for project understanding
- Use dev-note/ files to maintain context across sessions
- Leverage design/ outputs for architectural decisions
- Explore resources/ for additional context and examples
- Keep public package clean and professional

### Subagent Coordination
- Each agent has clear directory ownership boundaries
- Cross-agent communication happens through dev-note/ files
- No direct file conflicts - each agent stays in their domain
- jl-implementer is the only agent modifying core src/ functionality
- All agents can reference resources/ for additional context

### Quality Gates
- All public code follows Julia community standards
- Private design process can include experimental approaches
- REPL experience is prioritized throughout development
- Performance is considered from architectural level
- Resources are used for validation and inspiration

```

## 4. Generate README.md

Generate README.md for the Julia package referring the template below. The place denoted by '[...]' in the package should be replaced in accordance with the package name $1 and the description ($2). Place the file at '$1/README.md'.
````Markdown
# [PackageName.jl]

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