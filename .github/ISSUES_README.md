 This directory contains issue drafts for the top enhancements we discussed.

 How to use
 ----------
 - Review the markdown files under `.github/issues/` and adjust titles/labels as desired.
 - Use the included script `scripts/create_issues_with_gh.sh` to create the issues on GitHub via the `gh` CLI.

 Notes
 -----
 - The script attempts to detect the repository from `git remote` if `REPO` is not set.
 - You must have `gh` installed and authenticated (`gh auth login`) before running the script.
