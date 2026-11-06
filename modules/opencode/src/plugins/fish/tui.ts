import { Plugin } from "@opencode/plugin/tui"
import { getTreeSitterClient } from "@opentui/core"

const version = "3.6.0"

export default Plugin.define({
  id: "dotfiles.fish",
  async setup() {
    const client = getTreeSitterClient()
    await client.initialize()
    client.addFiletypeParser({
      filetype: "fish",
      wasm: `https://github.com/ndonfris/tree-sitter-fish.wasm/releases/download/${version}/tree-sitter-fish.wasm`,
      queries: {
        highlights: [`https://raw.githubusercontent.com/ram02z/tree-sitter-fish/${version}/queries/highlights.scm`],
      },
    })
  },
})
