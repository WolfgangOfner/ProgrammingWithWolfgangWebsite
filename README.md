# Programming With Wolfgang

A tech blog focusing on DevOps, Cloud, Azure, Kubernetes and Software Architecture.

## Checkout

Checkout the repository on Linux or WSL2 if you are on Windows. 

## Setting up the local envrionment

The whole environment is built and run inside a Docker container. Make sure to install Ruby and RubyGems on your Ubuntu (or WSL) machine that is used to build the docker container. 

To run the solution, execute the following command:

```bash
sudo apt-get install ruby-full build-essential zlib1g-dev

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# optionally or if the command above fails: apt install ruby

gem install jekyll bundler
```

```terminal
docker run -it --rm --volume="$($PWD):/srv/jekyll" -p 4000:4000 jekyll/jekyll jekyll serve
```
If you only want to run the website, you can use the following code, which should start faster than the above one:

Optionally use the --force_polling flag which enables a watcher that re-creates the files every time something changes.

## Setting up the live environment

Currently, the website needs to be built and the _site folder needs to be checked in. Build the site with the following command:

```terminal
docker run -it --rm --env JEKYLL_ENV=production --volume="$($PWD):/srv/jekyll" jekyll/jekyll jekyll build
```

It is planned to move this task to the GitHub action in the future.