# Final code cleanup

- After completing a task that changed code, and before the final response, launch one general subagent to perform the rmslop review.
- Tell the subagent to load the `rmslop` skill, review only code changed during the current task, fix clear violations, verify its edits, and return the skill's compact feedback note for the feedback loop.
- Give the subagent the task goal, changed-file list, known user-owned changes, and verification already run. Do not ask it to rediscover the whole session.
- Review the subagent's edits and verification result before replying to the user.
- Do not run rmslop for research, planning, explanations, writing-only work, configuration-only changes, generated files, or when no code changed.
- Do not launch rmslop recursively when the current prompt identifies you as the rmslop review subagent.
