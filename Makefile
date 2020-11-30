develop:
	python setup.py develop

clean:
	find . -name \*.pyc -delete

git:
	git add .
	git commit -m $(msg)
	git push
	git status

install_pip:
	pip install -r requirements.txt