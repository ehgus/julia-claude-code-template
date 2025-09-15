#!/usr/bin/env julia

"""
Julia Project Structure Generator (Simplified)

Creates the directory structure from CLAUDE.md template.
Assumes CLAUDE.md template already exists and will be copied/modified.

Usage:
    julia setup_project.jl <PackageName> [project_dir]

Example:
    julia setup_project.jl FastMatrices
    julia setup_project.jl NeuralODE my_projects/
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
        "dev-note"
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
        "$renamed_package_name/docs/src"
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
        "dev-note/ideas-parking.md" => "# Ideas Parking\n\n[Park future enhancement ideas here]\n"
    ]
    
    for (filepath, content) in templates
        open(filepath, "w") do f
            write(f, content)
        end
    end
end

function main()
    if length(ARGS) == 2
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