# AI Agent Documentation Strategy

```yaml
document_scope: "reference_material"
exported_artifact: false
default_copy_target: false
purpose: "design reference for documentation structure in AI-agent projects"
```

## Core Principles

```yaml
ai_agent_priority:
  human_readability: false
  token_optimization: true
  cognitive_load_reduction: true
  
information_consolidation:
  duplicate_elimination: true
  single_source_of_truth: true
  
universality:
  single_projects: true
  hierarchical_projects: true
  scale_independence: true
  target: "projects using AI agents (any scale)"
```

## Basic Structure (Multi-Agent)

```yaml
project_structure:
  root_files:
    - "CLAUDE.md"      # ≤200 tokens (AI entry point)
    - "GEMINI.md"      # ≤200 tokens (AI entry point)
    - "README.md"      # human interface only
  documents:
    root_shared: "shared resources and specifications"
    agents_directory: "documents/agents/ (AI-specific, English, no suffix)"
    users_directory: "documents/users/ (human-specific, Japanese, _JP.md suffix)"
  source_code: true

directory_structure:
  "documents/":
    purpose: "shared resources between AI and humans"
    content: "specifications, schemas, shared documentation"
  "documents/agents/":
    purpose: "AI-optimized documentation"
    language: "English"
    naming: "filename.md (no language suffix)"
    optimization: "token efficiency priority"
  "documents/users/":
    purpose: "human-readable documentation"  
    language: "Japanese (primary target)"
    naming: "filename_JP.md (Japanese suffix required)"
    optimization: "comprehensibility priority"
```

## Hierarchical Projects (OOP Design)

```yaml
hierarchy_principles:
  child_independence: "complete independence without parent knowledge"
  parent_containment: "parent manages all child project information"
  information_flow: "parent → child (unidirectional only)"
  external_reference: "only when necessary as external project reference"
  encapsulation: "child does not know parent implementation details"
  oop_analogy: "similar to object-oriented class containment design"

structure:
  parent_project:
    files: ["CLAUDE.md", "GEMINI.md", "README.md"]
    documents:
      shared_root: "documents/ (shared specifications)"
      agents_directory: "documents/agents/ (parent project AI docs)"
      users_directory: "documents/users/ (parent project human docs)"
      child_management: "documents/agents/children.md (child project coordination)"
  
  child_projects:
    independence: "complete independence without parent knowledge"
    structure:
      files: ["CLAUDE.md", "GEMINI.md", "README.md"] 
      documents:
        shared_root: "documents/ (child-specific shared specs)"
        agents_directory: "documents/agents/ (child AI docs, parent unaware)"
        users_directory: "documents/users/ (child human docs, parent unaware)"
    parent_awareness: false
    external_reference: "treat parent as external project if coordination needed"
```

## File Format Standards

```yaml
format_priority: "AI efficiency > human readability"
base_format: "markdown with YAML blocks"
processing_efficiency: "maximum AI parsing speed"

format_usage:
  agent_files: "structured markdown with YAML blocks"
  project_files: "markdown with YAML sections"
  documents: "markdown/YAML/JSON (flexible)"
  readme: "standard markdown (human exception)"

format_selection:
  structured_data: "YAML"
  explanations: "markdown"
  api_specs: "JSON"
  mixed: "markdown + YAML blocks (most efficient)"
```

## File Role Definitions

```yaml
PROJECT_md:
  purpose: "project description and routing"
  content:
    - "project overview and objectives"
    - "tech stack and architecture"
    - "constraints and business rules"
    - "current status and progress"
  token_limit: 800
  routing_responsibility: true

agent_md:
  purpose: "AI agent entry point"
  design_importance: "entry point with critical responsibilities"
  priority_structure:
    high:
      - "role and responsibility scope"
      - "immediate action guidelines"
      - "critical constraints and prohibitions"
      - "routing to documents/PROJECT.md"
      - "task-specific document guidance"
      - "gradual information acquisition guidelines"
    medium:
      - "frequently used information direct inclusion"
      - "cost optimization processing guidelines"
      - "unnecessary processing avoidance criteria"
  token_limit: 200
  self_sufficiency: "emergency action defined"
  critical_considerations:
    - "information density maximization within token limits"
    - "fallback strategy when other documents not read"
    - "minimum essential information for initial access"

README_md:
  purpose: "human interface only"
  content:
    - "basic project information"
    - "setup and usage"
    - "contribution guidelines"
    - "project background"
  token_limit: "none"
```

## Documents Directory Structure

```yaml
documents_principles:
  shared_root: "documents/ - specifications and shared resources"
  agents_directory: "documents/agents/ - AI-optimized documentation"
  users_directory: "documents/users/ - human-readable documentation"
  
directory_responsibilities:
  "documents/":
    content: "shared specifications, schemas, APIs"
    audience: "both AI agents and humans"
    language: "context-dependent (technical specs often English)"
  "documents/agents/":
    content: "project details, workflows, optimization guides"
    audience: "AI agents only"
    language: "English (processing efficiency)"
    naming: "descriptive.md (no language suffix)"
  "documents/users/":
    content: "setup guides, explanations, tutorials"
    audience: "human developers"
    language: "Japanese (primary target language)"
    naming: "descriptive_JP.md (language suffix required)"

reference_strategy:
  entry_points: "CLAUDE.md/GEMINI.md reference documents/agents/ primarily"
  human_entry: "README.md references documents/users/ for human guidance"
  shared_resources: "both reference documents/ for common specifications"
  gradual_guidance: "agent.md → documents/agents/ → documents/ (shared specs)"

routing_strategy:
  ai_workflow: "CLAUDE.md → documents/agents/project.md → task-specific files"
  human_workflow: "README.md → documents/users/setup_JP.md → detailed guides"
  shared_specs: "reference documents/ for API specs, schemas, standards"
  lost_prevention: "clear directory purpose prevents confusion"
```

## Implementation Examples

```yaml
# documents/agents/project.md Example
project: "User Management API"
status: "in_development"
priority: "high"
tech_stack: "TypeScript + Express + PostgreSQL"
architecture: "REST API + MVC pattern"
constraints:
  - "test coverage ≥80%"
  - "OpenAPI compliant"
  - "OAuth2.0 required"
current_phase: "MVP implementation"

routing:
  shared_specs: "documents/api-schema.json"
  workflows: "documents/agents/development.md"
  human_setup: "documents/users/setup_JP.md"

# CLAUDE.md Example (Markdown + YAML Structure)
format_example: |
  # CLAUDE.md - Claude Agent Instructions (≤200 tokens)
  
  ## Essential Information (Priority: High)
  role: "main_developer"
  constraints:
    - "test_driven_development_required"
    - "type_safety_priority_no_any"
    - "update_related_documents_when_changing_project"
    - "think_and_interim_reports_in_english_final_report_in_japanese"
    - "ask_user_git_commit_after_changes_and_final_report"
  emergency_action: "stop_implementation_and_request_clarification_if_unclear"
  
  ## Routing Information (Priority: High)
  primary_ref: "documents/agents/project.md (project details)"
  task_routing:
    - "before_implementation: documents/agents/project.md"
    - "shared_specs: documents/api-schema.json"
    - "development_workflow: documents/agents/development.md"
    - "human_coordination: documents/users/setup_JP.md"
  
  ## Efficiency Configuration (Priority: Medium)
  focus_files: ["src/**/*.ts", "tests/**/*.test.ts"]
  current_priority: "API endpoint implementation"

# GEMINI.md Example
# Use CLAUDE.md structure, customize per agent
```

## Information Priority

```yaml
priority_order:
  1: "[AI_NAME].md (root directory entry point)"
  2: "documents/agents/project.md (AI-specific project details)"
  3: "documents/ (shared specifications and schemas)"
  4: "documents/agents/ (detailed AI-optimized information)"
  5: "README.md (human interface entry point)"
  
human_priority_order:
  1: "README.md (human entry point)"
  2: "documents/users/setup_JP.md (setup and getting started)"
  3: "documents/ (shared specifications when needed)"
  4: "documents/users/ (detailed human-readable guides)"
```

## Operational Guidelines

```yaml
version_control: "git management with source code"
multi_developer: "standard git workflow (PR/merge)"
update_frequency: "change-triggered document updates"
maintenance: "document review in code review process"
document_sync: "AI agent responsibility via constraints"
```
