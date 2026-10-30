# Named workspace output slots (auto-generated)
#
# Format: <name> <slot>, where slot indexes the connected outputs ordered as in
# output-order (unlisted outputs first). ws.sh clamps it to the last output.
<%
    named_workspaces = ['home', 'mail', 'todo', 'vim', 'auth', 'system', 'config', 'dev', 'project', 'ssh', 'chat', 'audio']
    # Named workspaces land on the primary output (slot 0) unless overridden per host.
    slot_overrides = {'cyxwel': {'audio': 1, 'chat': 1}}.get(DEPLOY_HOST, {})
%>
% for ws in named_workspaces:
${ws} ${slot_overrides.get(ws, 0)}
% endfor
