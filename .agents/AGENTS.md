# Project Notes and Philosophies

- The name of the application is **Easel**.
- **shadcn** is our primary design inspiration (modular, composable, clean components).
- **storybook** is our architectural inspiration for the demo application (separate isolated environments for testing and showcasing components).
- Always include good, informative 1-sentence descriptions for each aspect/component when showcasing them in the demo application to ensure the User understands what they are looking at.
- Every component must support custom sprite backgrounds/assets. If custom assets aren't provided, components should cleanly fallback to generating flat primitive shapes.
- **USAGE DOCUMENTATION**: Every new page in `components` and `inputs` must have a Usage section rendered at the bottom (via `DemoUtils.createUsageBox`), and the code snippet must also be appended to the Usage section in the `README.md`.
- **BUILDING**: After running a build (e.g., `lime test windows`) and confirming it successfully compiles, immediately kill the running task/process so that the `.exe` and `.ndll` files are not locked and the user can test the build manually.
- **README UPDATES**: For every new feature added or fix made, ALWAYS ensure that the `README.md` is updated to reflect those changes.
- **SCRATCH FILES**: Always remember to clean up and delete any temporary scripts or scratch files (like `.py` scripts) generated during tasks once they are no longer needed.
