# Key Principles

- "**Keep it simple, stupid.**" Do not overengineer or optimize prematurely.

# Workflow

Validate your work early and often:

- Write and run end-to-end and integration tests focused on critical flows. One comprehensive, true E2E test beats many narrow unit tests 95% of the time.
- For UI, validate your work visually by screenshotting it (e.g. using Vercel agent-browser, Playwright CLI, or your preferred tooling).
- For UI components, write Storybook stories.
- For LLM engineering, write and run evals.
- Type checking (necessary but not sufficient)
- Linting and formatting (necessary but not sufficient)

Commit your work to version control. Shepherd PRs through code review (by humans or other agents) to merged and deployed.

Unless the repo or the user says otherwise, merge PRs by rebasing, not with a merge commit or a squash. An agent that is the only one working on a branch may force-push it (with `--force-with-lease`) to clean up its commit history before merge.

# Memory

**The repo is the source of truth, not agent memory.** Don't record project facts or working preferences in agent memory.

# Writing style

**Write well.** Load the "unslop" skill if it's available. Apply it to all writing: your output, plans, code, code comments, documentation, AGENTS.md edits, issues, commit messages, PRs, etc. Claude 5.5 and later models can skip loading unslop.

**Remove all mannered prose.** Mannered prose swaps metaphor and flourish for direct statement. "A dial worth turning" instead of "a parameter worth varying"; "this point earns its keep" instead of "this point still matters." The phrases exist to display the writer, not to convey the idea, and readers can tell. They are also imprecise, because metaphors drag in connotations you did not choose. Say what you mean, and use the literal phrase whenever one is available.

# Code principles

- **Types**: Use strict types. Do not cast as any. Validate foreign data.
- **Error handling**: Thrown errors and promise rejections are antipatterns invisible to static analysis. Instead, return strongly typed error states, modeling success and failure as variants of a return type. Furthermore, only expose errors when callers are expected to vary behavior in response.
- **Make impossible states impossible.** Design nominal types, state machines, and control flow so there are not dead code paths.

# Tech stack

If greenfield and not prescribed elsewhere, prefer pnpm, deploying on Vercel, and Next.js or TanStack Start.

When interacting with Cloudflare, use the `cf` CLI unless the project has a Wrangler configuration file.
