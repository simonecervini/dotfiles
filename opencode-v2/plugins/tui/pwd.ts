import { Plugin } from "@opencode-ai/plugin/tui"
import { createComponent } from "solid-js"

function Commands(props: { context: Plugin.Context }) {
  props.context.keymap.layer(() => ({
    mode: "global",
    commands: [
      {
        id: "user.copy-working-directory",
        title: "Copy working directory path",
        group: "Session",
        bind: "<leader>p",
        palette: true,
        slash: { name: "pwd" },
        enabled: () => props.context.ui.router.current().type === "session",
        run: async () => {
          const route = props.context.ui.router.current()
          if (route.type !== "session") return

          const directory = props.context.location?.directory
          if (!directory) {
            props.context.ui.toast.show({ message: "Session working directory is unavailable", variant: "error" })
            return
          }

          const child = Bun.spawn(["/usr/bin/pbcopy"], {
            stdin: new Blob([directory]),
            stdout: "ignore",
            stderr: "pipe",
          })
          const [exitCode, stderr] = await Promise.all([child.exited, new Response(child.stderr).text()])
          if (exitCode === 0) {
            props.context.ui.toast.show({ message: `Copied ${directory}`, variant: "info" })
            return
          }
          props.context.ui.toast.show({
            title: "Failed to copy working directory",
            message: stderr.trim() || `pbcopy exited with code ${exitCode}`,
            variant: "error",
          })
        },
      },
      {
        id: "user.open-vscode",
        title: "Open working directory in VS Code",
        group: "Session",
        bind: "<leader>v",
        palette: true,
        slash: { name: "code" },
        enabled: () => props.context.ui.router.current().type === "session",
        run: async () => {
          const route = props.context.ui.router.current()
          if (route.type !== "session") return

          const directory = props.context.location?.directory
          if (!directory) {
            props.context.ui.toast.show({ message: "Session working directory is unavailable", variant: "error" })
            return
          }

          const child = Bun.spawn(["open", "-a", "Visual Studio Code", directory], {
            cwd: directory,
            stdout: "ignore",
            stderr: "pipe",
          })
          const [exitCode, stderr] = await Promise.all([child.exited, new Response(child.stderr).text()])
          if (exitCode === 0) return
          props.context.ui.toast.show({
            title: "Failed to open VS Code",
            message: stderr.trim() || `open exited with code ${exitCode}`,
            variant: "error",
          })
        },
      },
    ],
  }))
  return null
}

export default Plugin.define({
  id: "user.pwd",
  setup(context) {
    return context.ui.slot({
      append: "app",
      render: () => createComponent(Commands, { context }),
    })
  },
})
