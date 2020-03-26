# Xontrib Conda Project

This `xontrib` will automatically activate a [`conda`](https://docs.conda.io/projects/conda/en/latest/user-guide/) environment residing in a project directory, upon moving to that directory.

For example, lets create a `conda` environment for our new project located at `~/project`

```
mkdir ~/project
cd ~/project
conda create --prefix conda-env xonsh
```

With `conda-project` loaded, this environment will automatically activate when you navigate to the project

```
cd ~
which xonsh  # /Users/deeuu/.local/share/virtualenvs/xonsh/bin/xonsh
cd ~/project
which xonsh  # /Users/deeuu/project/conda-env/bin/xonsh
```

and deactivate when you leave

```
cd ..
which xonsh  # /Users/deeuu/.local/share/virtualenvs/xonsh/bin/xonsh
```

By default, `conda-project` will decide to activate if a `conda-env` directory is found. You can change this by setting `$CONDA_PROJECT_DIR_NAME`.

Two useful aliases are also provided:

- `create-conda-project`: creates a `conda` environment in the current (project) directory, using an `env*.yaml` file if found. This is just a wrapper around `conda create`, so you can pass any valid arguments to this subcommand.
- `export-conda-project`: exports the `conda` environment located in the current (project) directory to `environment.yaml` (the environment does not need to be active to call this alias). This is just a wrapper around `conda env export`, so you can pass any valid arguments to this subcommand.

To deactivate the service, set `$CONDA_PROJECT = False` (or remove the `xontrib`).

## Install

```
xpip install xontrib-conda-project
```

Then load it by adding

```
xontrib load xontrib-conda-project
```

to your `.xonshrc`.
