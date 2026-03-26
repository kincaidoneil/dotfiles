# Key Principles

1. Craft **production-quality** code that is **finished** and **validated end-to-end**.
2. "**Keep it simple, stupid.**" Do not overengineer or optimize prematurely.

# Workflow

Validate your work **early and often**.

Write plans that include success criteria and validation steps:

- End-to-end and integration tests focused on critical flows. Use test-driven development: your plan should stipulate writing tests before implementation. **You must run the tests.** Typically, prioritize fewer integration tests over many narrow unit tests.
- For UI, validate your work visually by screenshotting it with Claude in Chrome or the Playwright CLI.
- For UI components, write Storybook stories.
- For LLM engineering, write evals. **You must run the evals**.
- Type checking (necessary but not sufficient)
- Linting and formatting (necessary but not sufficient)

Furthermore, plans must also commit work to version control. Use your GitButler skill. If unclear, ask clarifying questions about branching or if a PR should be opened.

# Code style

- **Comment _sparingly_**. Only remove existing comments if you address its issue. Don't remove existing informative comments.
- **Types**: Use strict types. **Do not** cast `as any`. Validate foreign data.
- **Error handling**: Don't throw errors. Encode errors in the type system.

# UI aesthetics

**Be bold and creative**. Prefer unique typography, colors, motion, and layouts. Avoid generic and overused font families (Inter, system fonts), cliché color palettes (like purple gradients on white backgrounds) and predictable startup landing page layouts.
