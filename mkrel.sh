#!/bin/sh
set -e # exit if any of commands fail
# Check for Git-Flow and install it via Homebrew if missing
git flow help 2>&1 | grep -q 'is not a git command' && \
  echo "Please install Git-Flow, eg. 'brew install git-flow'" && exit 1
# Check for development branch name
DEVELOP_BRANCH="$(git branch --list 'develop*' --no-color | head -1 | sed -e 's/^..//')"
case $1 in
  release)
    case $2 in
      start)
        VERSION_BUMP="$(npx standard-version -r minor --dry-run | grep 'bumping version in package.json')"
        CUR_VERSION="$(echo ${VERSION_BUMP} | awk '{print $7}')"
        NEW_VERSION="$(echo ${VERSION_BUMP} | awk '{print $9}')"
        echo "==> Current version is ${CUR_VERSION}"
        echo "==> Starting new release ${NEW_VERSION}"
        git flow release start ${NEW_VERSION}
        npx standard-version -r minor --prerelease rc --skip.changelog
        echo "==> Release candidate ${NEW_VERSION} started - you can now make the necessary changes to code"
        echo "==> IMPORTANT:"
        echo "==>     Run '$0 $1 finish' to finalize the process"
        ;;
      finish)
        if git flow release list 2>&1 | grep 'No release branches exist.'; then
          echo "==> There isn't any release started - run '$0 release start' first"
          exit 1
        fi
        VERSION_BUMP="$(npx standard-version -r minor --dry-run | grep 'bumping version in package.json')"
        CUR_VERSION="$(echo ${VERSION_BUMP} | awk '{print $7}')"
        NEW_VERSION="$(echo ${VERSION_BUMP} | awk '{print $9}')"
        if ! git flow release list 2>&1 | grep ${NEW_VERSION}; then
          echo "==> There is no 'release/${NEW_VERSION}' branch started - run '$0 release start' first"
          exit 1
        fi
        echo "==> Finalizing release ${NEW_VERSION}"
        npx standard-version -r minor
        GIT_MERGE_AUTOEDIT="no" git flow release finish -n -k ${NEW_VERSION}
        case $3 in
          --skip-migration)
            [ "$(git rev-parse --abbrev-ref HEAD)" != "master" ] && git checkout master
            COMMIT_MESSAGE="$(git log -1 --pretty=%B)"
            git commit --amend -m "${COMMIT_MESSAGE} [skip migration]"
            ;;
        esac
        # Explicitly push master and develop(ment) branches to origin
        git push --follow-tags origin master
        git push --follow-tags origin ${DEVELOP_BRANCH}
        echo "==> Released version ${NEW_VERSION}"
        echo "==> NOTE: please manually delete 'origin/release/${NEW_VERSION}' branch once CI build is finished"
        ;;
      -h)
      --help)
      *)
        echo "Usage:"
        echo "    $0 $1 start   - start a new release, incrementing minor version"
        echo "    $0 $1 finish [--skip-migration] - finalize the release process"
        echo

        exit 1
        ;;
      esac
    ;;
  hotfix)
    case $2 in
      start)
        VERSION_BUMP="$(npx standard-version -r patch --dry-run | grep 'bumping version in package.json')"
        CUR_VERSION="$(echo ${VERSION_BUMP} | awk '{print $7}')"
        NEW_VERSION="$(echo ${VERSION_BUMP} | awk '{print $9}')"
        echo "==> Current version is ${CUR_VERSION}"
        echo "==> Starting new hotfix version ${NEW_VERSION}"
        git flow hotfix start ${NEW_VERSION}
        echo "==> Hotfix ${NEW_VERSION} started - you can now make the necessary changes to code"
        echo "==> IMPORTANT:"
        echo "==>     Run '$0 $1 finish' to finalize the process"
        ;;
      finish)
        if git flow hotfix list 2>&1 | grep 'No hotfix branches exist.'; then
          echo "==> There isn't any hotfix started - run '$0 $1 start' first"
          exit 1
        fi
        VERSION_BUMP="$(npx standard-version -r patch --dry-run | grep 'bumping version in package.json')"
        CUR_VERSION="$(echo ${VERSION_BUMP} | awk '{print $7}')"
        NEW_VERSION="$(echo ${VERSION_BUMP} | awk '{print $9}')"
        if ! git flow hotfix list 2>&1 | grep ${NEW_VERSION}; then
          echo "==> There is no 'hotfix/${NEW_VERSION}' branch started - run '$0 $1 start' first"
          exit 1
        fi
        echo "==> New version is ${NEW_VERSION}"
        npx standard-version -r patch
        GIT_MERGE_AUTOEDIT="no" git flow hotfix finish -n ${NEW_VERSION}
        case $3 in
          --skip-migration)
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
