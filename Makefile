PHONY: github

github:
	rm -rf docs
	cp -r __sapper__/export/toe-or-thumb docs
	git add -A
	git commit -m "update dev version"
	git push
	