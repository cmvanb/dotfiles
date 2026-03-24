---
id: "bookmarks/${new_bookmark_name_kebab}.md"
aliases:
  - "${new_bookmark_name}"
tags:
% for tag in new_bookmark_tags.split():
  - "${tag}"
% endfor
---

# ${new_bookmark_name}

[${new_bookmark_url}](${new_bookmark_url})
