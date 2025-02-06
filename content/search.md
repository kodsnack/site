+++
date = 2025-02-06T14:55:00Z
draft = false
title = "Sök"
aliases = ["/search/"]
+++

<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="search"></div>
<script>
window.addEventListener('DOMContentLoaded', (event) => {
    new PagefindUI({ element: "#search", showSubResults: true });
});
</script>