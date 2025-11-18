#!/usr/bin/env bash

# vars
set -x
code_dir="$HOME/code"

validate_github_pr_url() {
  local url="$1"

  # Regex to match the specific GitHub repo format
  local regex='^git@github\.com:[a-zA-Z0-9_-]+\/[a-zA-Z0-9_.-]+\.git$'
  if [[ "$url" =~ $regex ]]; then
    echo "$url"
    return 0
  else
    echo "Invalid GitHub repo URL.  Must match: git@github.com:<repo>.git"
    return 1
  fi
}

gh-grab() {
  url="$(validate_github_pr_url "$@")"
  if [[ $? != 0 ]]; then
    echo "$url"
    exit 1
  fi
  domain=$(echo "$url" | sed -E 's/.*@([^:]*):.*/\1/')
  repo_org=$(echo "$url" | sed -E 's/.*:([^\/]*)\/.*/\1/')
  repo_name=$(echo "$url" | sed -E 's/.*\/(.*)/\1/')

  mkdir -p "$code_dir/$domain/$repo_org/"

  if [ -d "$code_dir/$domain/$repo_org/$repo_name" ]; then
    echo "repo dir already exists"
    exit 0
  fi

  cd "$code_dir/$domain/$repo_org/" || echo "cd failed"

  gh repo fork "$url" --clone --remote -- --bare

  cd "$repo_name" || echo "cd failed"

  mkdir .git

  mv -- * .git

  git worktree add main main
}

show_help() {
  cat <<EOF
Usage: ${0##*/} [OPTIONS] <github-repo-url>

This tool takes a GitHub repo link, optionally forks it, then clones it
into a git worktree layout

Options:
  -h, --help        Display this help message and exit
  -nf, --no-fork    Skip forking the repo and just clone it

Examples:
  ${0##*/} git@github.com:containers/podman-py.git
  ${0##*/} --no-fork git@github.com:lewisdenny/podman-py.git
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    show_help
    exit 0
    ;;
  -nf | --no-fork)
    export fork=false
    ;;
  *)
    gh-grab "$@"
    ;;
  esac
  shift
done
