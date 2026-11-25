import { Plugin } from "@opencode/plugin/tui"

// The TUI remembers the last variant per model in model.json and reuses it for new sessions.
const preferred = "high"

export default Plugin.define({
  id: "dotfiles.variant",
  setup(context) {
    const reset = (attempts: number) => {
      const variant = context.ui.model.variant.list().includes(preferred) ? preferred : undefined
      if (context.ui.model.variant.set(variant) || attempts <= 0) return
      setTimeout(() => reset(attempts - 1), 100)
    }

    return context.ui.slot({
      append: "home.footer",
      render: () => {
        queueMicrotask(() => reset(50))
        return null
      },
    })
  },
})
