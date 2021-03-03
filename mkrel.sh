#!/bin/sh
set -e # exit if any of commands fail
MKREL="$(basename $0)"

# Check for Git-Flow and suggest installing it via Homebrew if missing
if git flow help 2>&1 | grep -q 'is not a git command'; then
  echo "Please install Git-Flow, eg. 'brew install git-flow'"
  exit 1
fi

# Check for standard-version npm module and install it if needed
STANDARD_VERSION="npx --no-install standard-version"
if ${STANDARD_VERSION} --help | grep "not found: standard-version"; then
  echo "==> standard-version wasn't found - adding as a devDependency"
  npm install --save-dev standard-version
fi

# Check for development branch name
DEVELOP_BRANCH="$(git branch --list 'develop*' --no-color | head -1 | sed -e 's/^..//')"

get_version_bump() {
  VERSION_BUMP="$(${STANDARD_VERSION} -r ${1:-minor} --dry-run | grep 'bumping version in package.json')"
  CUR_VERSION="$(echo ${VERSION_BUMP} | awk '{print $7}')"
  NEW_VERSION="$(echo ${VERSION_BUMP} | awk '{print $9}')"
  echo "==> Bumping version: ${CUR_VERSION} -> ${NEW_VERSION}"
}

release_start() {
  get_version_bump(minor)
  git flow release start ${NEW_VERSION}
  ${STANDARD_VERSION} -r minor --prerelease rc --skip.changelog --skip.tag
  echo "==> Release candidate for ${NEW_VERSION} started - you can now make the necessary changes to code"
  echo "==> IMPORTANT:"
  echo "==>     Run '${MKREL} release finish' to finalize the process"
}

case $1 in
  release)
    case $2 in
      start)
        if ! git flow release list 2>&1 | grep 'No release branches exist.'; then
          echo "==> Some release was already started? Finish it first by running '${MKREL} release finish'"
          exit 1
        fi
        release_start
        ;;
      finish)
        if git flow release list 2>&1 | grep 'No release branches exist.'; then
          echo "==> There isn't any release started - run '${MKREL} release start' first"
          exit 1
        fi
        get_version_bump(minor)
        if ! git flow release list 2>&1 | grep ${NEW_VERSION}; then
          echo "==> There is no 'release/${NEW_VERSION}' branch started - run '${MKREL} release start' first"
          exit 1
        fi
        echo "==> Finalizing release ${NEW_VERSION}"
        ${STANDARD_VERSION} -r minor
        GIT_MERGE_AUTOEDIT="no" git flow release finish -n -k ${NEW_VERSION}
        case $3 in
          -m|--skip-migration)
            [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ] && git checkout master
            COMMIT_MESSAGE="$(git log -1 --pretty=%B)"
            git commit --amend -m "${COMMIT_MESSAGE} [skip migration]"
            ;;
        esac
        # Explicitly push master and develop(ment) branches to origin
        git push --follow-tags origin master
        git push --follow-tags origin ${DEVELOP_BRANCH}
        echo "==> Released version ${NEW_VERSION}"
        echo "==> Removing local release/${NEW_VERSION} branch (not needed anymore)"
        git branch -d release/${NEW_VERSION}
        echo "==> NOTE: please manually delete 'origin/release/${NEW_VERSION}' branch once CI build is finished"
        
        case $3 in
          -s|--start-new)
            echo "==> Starting a new release right away..."
            release_start
            ;;
        esac
        ;;
      -h|--help|*)
        echo "Usage:"
        echo "    ${MKREL} $1 start   - start a new release, incrementing minor version"
        echo "    ${MKREL} $1 finish [--skip-migration] - finalize the release process"
        echo

        exit 1
        ;;
      esac
    ;;
  hotfix)
    case $2 in
      start)
        get_version_bump(patch)
        git flow hotfix start ${NEW_VERSION}
        echo "==> Hotfix ${NEW_VERSION} started - you can now make the necessary changes to code"
        echo "==> IMPORTANT:"
        echo "==>     Run '${MKREL} $1 finish' to finalize the process"
        ;;
      finish)
        if git flow hotfix list 2>&1 | grep 'No hotfix branches exist.'; then
          echo "==> There isn't any hotfix started - run '${MKREL} $1 start' first"
          exit 1
        fi
        get_version_bump(patch)
        if ! git flow hotfix list 2>&1 | grep ${NEW_VERSION}; then
          echo "==> There is no 'hotfix/${NEW_VERSION}' branch started - run '${MKREL} $1 start' first"
          exit 1
        fi
        echo "==> New version is ${NEW_VERSION}"
        ${STANDARD_VERSION} -r patch
        GIT_MERGE_AUTOEDIT="no" git flow hotfix finish -n ${NEW_VERSION}
        case $3 in
          -m|--skip-migration)
            [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ] && git checkout master
            COMMIT_MESSAGE="$(git log -1 --pretty=%B)"
            git commit --amend -m "${COMMIT_MESSAGE} [skip migration]"
            ;;
        esac
        # Explicitly push master and develop(ment) branches to origin
        git push --follow-tags origin master
        git push --follow-tags origin ${DEVELOP_BRANCH}
        echo "==> Finished hotfix release ${NEW_VERSION}"
        ;;
      -h|--help|*)
        echo "Usage:"
        echo "    ${MKREL} $1 start   - start a new hotfix, incrementing patch version"
        echo "    ${MKREL} $1 finish [--skip-migration] - finalize the hotfix process"
        echo

        exit 1
        ;;
    esac
    ;;
  -h|--help|*)
    echo "Usage:"
    echo "    ${MKREL} release [start|finish] - make a new release, incrementing minor version"
    echo "    ${MKREL} hotfix  [start|finish] - make a new hotfix, incrementing patch version"
    echo

    exit 1
    ;;
esac
