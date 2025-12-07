#!/usr/bin/env bash
set -euox pipefail

# Commands for gitlab:
# glab repo fork <repo>
# glab repo clone <repo> -- --bare

# --- Configuration ---
readonly CODE_DIR="${HOME}/code"
# GH_USERNAME will be set by validate_repo_url
GH_USERNAME=""

# --- Utility Functions ---

show_help() {
    cat <<EOF
Usage: ${0##*/} [OPTIONS] <repo-url>

git-grab clones a bare repository using a git worktree structure.
It optionally forks the repo on GitHub first.

Arguments:
  repo-url  The full SSH URL for the repository (e.g., git@github.com:org/repo.git)

Options:
  -h, --help      Display this help message and exit.
  -nf, --no-fork  Skip forking the repository and clone it directly.

Note: To automatically cd into the new directory, run this script with 'source' or '.':
      . ./${0##*/} git@github.com:org/repo.git
EOF
}

# Extracts and validates the GitHub repo URL and sets GH_USERNAME.
validate_repo_url() {
    local url="$1"
    local regex='^git@github\.com:([a-zA-Z0-9_-]+)\/([a-zA-Z0-9_.-]+)\.git$'

    if [[ ! "$url" =~ $regex ]]; then
        echo "Invalid repo URL. Must match: git@github.com:<org>/<repo>.git" >&2
        return 1
    fi

    local user_json
    user_json=$(gh auth status --json hosts 2>/dev/null) || {
        echo "Error: 'gh auth status' failed. Is the GitHub CLI installed and authenticated?" >&2
        return 1
    }

    GH_USERNAME=$(echo "$user_json" | jq -r '.hosts["github.com"][0].login // empty')
    if [[ -z "$GH_USERNAME" ]]; then
        echo "Error: Could not retrieve GitHub username. Are you logged in?" >&2
        return 1
    fi
}

# Core function to fork, clone, and set up the worktree.
git_grab() {
    local url="$1"
    local do_fork="$2"
    local domain repo_org repo_name full_path default_branch

    validate_repo_url "$url" || exit 1

    # Extract components using regex capture groups
    [[ "$url" =~ ^git@([^:]+):([^/]+)\/(.+)\.git$ ]]
    domain="${BASH_REMATCH[1]}"
    repo_org="${BASH_REMATCH[2]}"
    repo_name="${BASH_REMATCH[3]}"
    full_path="${CODE_DIR}/${domain}/${repo_org}/${repo_name}.git"

    mkdir -p "${CODE_DIR}/${domain}/${repo_org}"

    if [[ -d "$full_path" ]]; then
        echo "Repository directory already exists: ${full_path}"
        # Print path for caller to cd (TODO 3)
        echo "${full_path}/$(gh api "repos/${repo_org}/${repo_name}" --jq .default_branch 2>/dev/null || echo "main")"
        return 0
    fi

    cd "${CODE_DIR}/${domain}/${repo_org}/" || { echo "cd failed" >&2; exit 1; }

    local personal_repo_url="git@$domain:$GH_USERNAME/$repo_name.git"

    if [[ "$do_fork" == "true" ]]; then
        echo "Attempting to clone existing fork from ${personal_repo_url} ..."


        #TODO: Should only use gh if repo is hosted on github
        if ! gh repo clone "$personal_repo_url" -- --bare 2>/dev/null; then
            echo "${GH_USERNAME}/${repo_name} not found. Forking and cloning from ${url}..."

            # Fork and clone (gh repo fork creates a standard clone)
            gh repo fork "$url" --clone --remote -- --bare || { echo "Fork/Clone failed" >&2; exit 1; }
        else
            echo "Successfully cloned existing bare fork."
        fi
    else
        echo "Skipping fork. Cloning directly from ${url}..."
        gh repo clone "$url" -- --bare "$repo_name" || { echo "Clone failed" >&2; exit 1; }
    fi

    cd "$repo_name.git" || { echo "cd failed" >&2; exit 1; }

    # Ensure the repo is in the bare format for worktree setup
    if [[ -f HEAD && -d objects ]]; then
        echo "Preparing bare repository for worktree setup..."
        mkdir -p .git
        # Move all bare repository files into the new .git subdirectory
        find . -maxdepth 1 -mindepth 1 -not -name '.git' -exec mv {} .git \; 2>/dev/null || true
    fi

    # TODO 2: Detect the repo's default branch
    default_branch=$(gh api "repos/${repo_org}/${repo_name}" --jq .default_branch 2>/dev/null || echo "main")

    # If the user forked, check the fork's branch (which is usually the same but safer)
    if [[ "$do_fork" == "true" ]]; then
        default_branch=$(gh api "repos/${GH_USERNAME}/${repo_name}" --jq .default_branch 2>/dev/null || echo "${default_branch}")
    fi

    echo "Using default branch: ${default_branch}"

    git worktree add "${default_branch}" "${default_branch}" || { echo "git worktree add failed" >&2; exit 1; }

    if [[ "$do_fork" == "true" ]]; then
        git remote add upstream "$url" 2>/dev/null || true
        git fetch upstream
        git branch --set-upstream-to=upstream/"${default_branch}" "${default_branch}" 2>/dev/null || true
        echo "Added 'upstream' remote for tracking."
    fi

    echo "Repository successfully set up."

    # TODO 3: Print final path for caller environment change
    echo "${full_path}/${default_branch}"
}

# --- Main Execution ---

main() {
    local fork=true
    local positional_args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -nf|--no-fork)
                fork=false
                shift
                ;;
            *)
                positional_args+=("$1")
                shift
                ;;
        esac
    done

    if [[ ${#positional_args[@]} -eq 0 ]]; then
        echo "Error: Missing required argument: <repo-url>" >&2
        show_help
        exit 1
    fi

    git_grab "${positional_args[0]}" "$fork"
}

main "$@"
