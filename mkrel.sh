#!/bin/sh
set -e # exit if any of commands fail
# Check for unleash and install it if missing
which unleash > /dev/null || npm install -g unleash
# Check for Git-Flow and install it via Homebrew if missing
git flow help 2>&1 | grep -q 'is not a git command' && brew install git-flow
# Check for development branch name
DEVELOP_BRANCH="$(git branch --list 'develop*' --no-color | head -1 | sed -e 's/^..//')"
case $1 in
  release)
    case $2 in
      start)
        VERSION=$(grep version package.json | awk '{print $2}' | sed 's/[\",]//g')
        echo "==> Current version is ${VERSION}"
        NEW_VERSION=$(unleash --minor --dry-run | grep "changelog entry for version" | awk '{print $9}')
        echo "==> Starting new release ${NEW_VERSION}"
        git flow release start ${NEW_VERSION}
        echo "==> Release ${NEW_VERSION} started - you can now make the necessary changes to code"
        echo "==> IMPORTANT:"
        echo "==>     Run '$0 $1 finish' to finalize the process"
        ;;
      finish)
        if git flow release list 2>&1 | grep 'No release branches exist.'; then
          echo "==> There isn't any release started - run '$0 feature start' first"
          exit 1
        fi
        NEW_VERSION=$(unleash --minor --dry-run | grep "changelog entry for version" | awk '{print $9}')
        if ! git flow release list 2>&1 | grep ${NEW_VERSION}; then
          echo "==> There is no 'release/${NEW_VERSION}' branch started - run '$0 release' first"
          exit 1
        fi
        echo "==> Finalizing release ${NEW_VERSION}"
        unleash --minor --no-publish
        GIT_MERGE_AUTOEDIT=no git flow release finish -n -k ${NEW_VERSION}
        # Explicitly push master and develop(ment) branches to origin
        git push origin master
        git push origin ${DEVELOP_BRANCH}
        echo "==> Released version ${NEW_VERSION}"
        echo "==> NOTE: please manually delete 'origin/release/${NEW_VERSION}' branch once CI build is finished"
        ;;
      *)
        echo "Usage:"
        echo "    $0 $1 start   - start a new release, incrementing minor version"
        echo "    $0 $1 finish  - finalize the release process"
        echo

        exit 1
        ;;
      esac
    ;;
  hotfix)
    case $2 in
      start)
        VERSION=$(grep version package.json | awk '{print $2}' | sed 's/[\",]//g')
        echo "==> Current version is ${VERSION}"
        NEW_VERSION=$(unleash --patch --dry-run | grep "changelog entry for version" | awk '{print $9}')
        echo "==> Starting new hotfix version ${NEW_VERSION}"
        git flow hotfix start ${NEW_VERSION}
        echo "==> Hotfix ${NEW_VERSION} started - you can now make the necessary changes to code"
        echo "==> IMPORTANT:"
        echo "==>     Run '$0 $1 finish' to finalize the process"
        ;;
      finish)
        if git flow hotfix list 2>&1 | grep 'No hotfix branches exist.'; then
          echo "==> There isn't any hotfix started - run '$0 hotfix' first"
          exit 1
        fi
        NEW_VERSION=$(unleash --patch --dry-run | grep "changelog entry for version" | awk '{print $9}')
        if ! git flow hotfix list 2>&1 | grep ${NEW_VERSION}; then
          echo "==> There is no 'hotfix/${NEW_VERSION}' branch started - run '$0 hotfix' first"
          exit 1
        fi
        echo "==> New version is ${NEW_VERSION}"
        unleash --patch --no-publish
        GIT_MERGE_AUTOEDIT=no git flow hotfix finish -np ${NEW_VERSION}
        echo "==> Finished hotfix release ${NEW_VERSION}"
        ;;
      *)
        echo "Usage:"
        echo "    $0 $1 start   - start a new hotfix, incrementing patch version"
        echo "    $0 $1 finish  - finalize the hotfix process"
        echo

        exit 1
        ;;
    esac
    ;;
  *)
    echo "Usage:"
    echo "    $0 release [start|finish] - make a new release, incrementing minor version"
    echo "    $0 hotfix  [start|finish] - make a new hotfix, incrementing patch version"
    echo

    exit 1
    ;;
esac
