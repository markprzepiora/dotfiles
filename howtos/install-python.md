Install dependencies and Python 3 with asdf.

```bash
sudo apt install -y tk-dev libbz2-dev liblzma-dev
latest_version=$(asdf list all python | grep '^3' | grep -v -- '-dev$' | grep -v 't$' | grep -v 'a' | tail -1)
asdf install python "$latest_version"
```
