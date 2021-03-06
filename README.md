# Programming With Wolfgang

A tech blog focusing on DevOps, Cloud, Azure, Kubernetes and Software Architecture.

## Checkout

Checkout the repository on Linux or WSL2 if you are on Windows. 

## Setting up the local envrionment

The whole environment is built and run inside a Docker container. To run the solution, execute the following command:

```terminal
docker run -it --rm --volume="$($PWD):/srv/jekyll" -p 4000:4000 jekyll/jekyll jekyll serve
```
If you only want to run the website, you can use the following code, which should start faster than the above one:

Optionally use the --force_polling flag which enables a watcher that re-creates the files everytime something changes.

## Setting up the live environment

Currently, the website needs to be built and the _site folder needs to be checked in. Build the site with the following command:

```terminal
docker run -it --rm --volume="$($PWD):/srv/jekyll" -p 4000:4000 jekyll/jekyll jekyll build
```

It is planned to move this task to the Github action in the future.
