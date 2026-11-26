# Key Principles

- "**Keep it simple, stupid.**" Do not overengineer or optimize prematurely.

# Workflow

Validate your work early and often:

- Write and run end-to-end and integration tests focused on critical flows. One comprehensive, true E2E test beats many narrow unit tests 95% of the time.
- For UI, validate your work visually by screenshotting it (e.g. using Vercel agent-browser or your preferred tooling).
- For UI components, write Storybook stories.
- For LLM engineering, write and run evals.
- Type checking (necessary but not sufficient)
- Linting and formatting (necessary but not sufficient)

Commit your work to version control with plain git, and use a git worktree for work that runs alongside other agents. Shepherd PRs through code review (by humans or other agents) to merged and deployed.

Unless the repo or the user says otherwise, merge PRs by rebasing, not with a merge commit or a squash. An agent that is the only one working on a branch may force-push it (with `--force-with-lease`) to clean up its commit history before merge.

## GitHub identity

Agents act on GitHub as the `kincaidoneil-agent` GitHub App, so their comments, reviews, and PRs show as `kincaidoneil-agent[bot]`. That way the user can tell agent writing from their own, and can approve PRs an agent opened.

- **`gh` is wrapped.** `~/dotfiles/agent-bin/gh` gives each `gh` command a 1-hour App token when `AGENT_GITHUB_APP_ID` and `AGENT_GITHUB_APP_KEY` are set. If `which gh` doesn't print that path, run `export PATH="$HOME/dotfiles/agent-bin:$PATH"`.
- **The App can comment, review, open PRs and issues, and read code and CI. It cannot push or merge.** `git push` and `gh auth` still run as the user.
- **If the credentials are unset, `gh` runs as the user** and warns. Then mark anything you post as agent-written. If minting a token fails, `gh` fails rather than post as the user; report the error instead of working around it.
- **Sign what you write.** End every comment, review, and PR body with the model and the harness running it, for example `— Claude Opus 5.5, Claude Code`, `— GPT 6.2 Astra, Codex`, or `— Kimi K3.1, Pi`. One App covers every agent, so the signature is what tells them apart.

## Suggested multi-agent setup for Claude

This section applies to Claude agents (such as Claude Code), and the model names are Claude models. For large or risky changes, consider splitting the work across agents with separate roles:

- **Owner (the user)** makes decisions and gives the final go or no-go.
- **Coordinator** (Opus, high effort) plans the work, writes briefs for other agents, lands changes on main, and updates docs. It delegates only when a task needs it:
  - **Explorer** (Haiku, or Sonnet when the search needs judgment) finds the relevant files and reports them. It does not draw conclusions.
  - **Builder** (Opus, in its own worktree) writes the code and tests.
- **Verification** is a script, not a model. It runs the checks locally and against the real dependencies (for example, the production database engine) and saves the output as evidence.
- **Reviewer** (Fable) reviews the branch and the verification output independently, then approves or requests changes. It is read-only and never pushes.

The sequence: the builder's branch passes verification, the reviewer approves it, the coordinator lands it on main and runs verification again, the reviewer confirms, and then the branch is pushed to origin.

In short: cheaper models find code, Opus writes it, Fable checks it, and the user decides.

# Memory

**The repo is the source of truth, not agent memory.** Don't record project facts or working preferences in agent memory.

# Writing style

**Write well.** This applies to all writing: your output, plans, code, code comments, documentation, AGENTS.md edits, issues, commit messages, PRs, etc.

**Remove all mannered prose.** Mannered prose swaps metaphor and flourish for direct statement. "A dial worth turning" instead of "a parameter worth varying"; "this point earns its keep" instead of "this point still matters." The phrases exist to display the writer, not to convey the idea, and readers can tell. They are also imprecise, because metaphors drag in connotations you did not choose. Say what you mean, and use the literal phrase whenever one is available.

# Code principles

- **Types**: Use strict types. Do not cast as any. Validate foreign data.
- **Error handling**: Thrown errors and promise rejections are antipatterns invisible to static analysis. Instead, return strongly typed error states, modeling success and failure as variants of a return type. Furthermore, only expose errors when callers are expected to vary behavior in response.
- **Make impossible states impossible.** Design nominal types, state machines, and control flow so there are not dead code paths.

# Tech stack

If greenfield and not prescribed elsewhere, prefer pnpm, deploying on Vercel, and Next.js or TanStack Start.

When interacting with Cloudflare, use the `cf` CLI unless the project has a Wrangler configuration file.
