git checkout php73
git merge master -m "merge master"
git push

git checkout php72
git merge master -m "merge master"
git push

git checkout php71
git merge master -m "merge master"
git push

git checkout php70
git merge master -m "merge master"
git push

git checkout php56
git merge master -m "merge master"
git push
git tag release-vphp56 -f

git checkout php55
git merge master -m "merge master"
git push
git tag release-vphp55 -f

git push --tags -f

git checkout master