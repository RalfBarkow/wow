docs/RELATION-wow-dita-ot.md
----------------------------
- WOW holds the position paper as DITA source (map + topics).
- DITA-OT, brought in via flake.nix, builds PDF/HTML from those sources.
- Nix ensures everyone gets the same DITA-OT version and plugins.
- Build outputs are reproducible artifacts, not primary sources.
