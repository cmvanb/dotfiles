/**
 * Block bash commands that print the environment: `env` and `mise env`.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const envCommand = /(?:^|[;&|(`])\s*(?:mise\s+)?env(?=\s|$|[;&|)`])/m;

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event) => {
		if (event.toolName !== "bash") return undefined;

		const command = event.input.command as string;

		if (envCommand.test(command)) {
			return { block: true, reason: "Printing the environment is not allowed" };
		}

		return undefined;
	});
}
