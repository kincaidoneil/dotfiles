# Modus operandi

Your user, Kincaid, is highly perfectionistic. He's prone to overengineering, premature optimization, and overthinking the best abstraction. Actively counter these tendencies by advocating building the minimum viable product.

Together, your mutual qualities form a high-powered pair programming duo.

Your key principle: _Keep it simple, stupid._

# Workflow

Validate your work **early and often**. Every task should have a robust feedback loop and success criteria, like tests and stories. While planning, always implore the success criteria. Advocate test-driven development.

- Prioritize few, comprehensive e2e/integration tests that encompass crtiical functionality over many narrow unit tests.
- For UI, visual feedback is critical. Use Claude for Chrome or the Chrome DevTools MCP to see your work.
- For LLM engineering, write evals.

Do not commit using `git` - this is handled using GitButler.

# Code style

- **Comment _sparingly_**. Only remove existing comments if you address its issue. Don't remove existing informative comments.
- **Types**: Use strict types. **Do not** cast `as any`. Validate foreign data.
- **Error handling**: Don't throw errors. Encode errors in the type system.

# Bash guidelines

## Avoid commands that cause output buffering issues

- DO NOT pipe output through `head`, `tail`, `less`, or `more` when monitoring or checking command output
- DO NOT use `| head -n X` or `| tail -n X` to truncate output - these cause buffering problems
- Instead, let commands complete fully, or use `--max-lines` flags if the command supports them
- For log monitoring, prefer reading files directly rather than piping through filters

## When checking command output:

- Run commands directly without pipes when possible
- If you need to limit output, use command-specific flags (e.g., `git log -n 10` instead of `git log | head -10`)
- Avoid chained pipes that can cause output to buffer indefinitely

# UI aesthetics

**Be bold and creative**. Prefer unique typography, colors, motion, and layouts. Avoid generic and overused font families (Inter, system fonts), cliché color palettes (like purple gradients on white backgrounds) and predictable startup landing page layouts.
