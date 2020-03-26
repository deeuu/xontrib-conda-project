import os
import pathlib
import builtins

__all__ = ()

class CondaProject():


    def switch(self, newdir=None):
        """
        If `newdir` contains a conda environment, activate it after
        deactivating the current environment (if one).
        """

        if not builtins.__xonsh__.env.get('CONDA_PROJECT', True):
            return

        conda_project_dir_name = builtins.__xonsh__.env.get(
            'CONDA_PROJECT_DIR_NAME', 'conda-env'
        )

        if newdir is None:
            newdir = os.getcwd()

        conda_prefix = builtins.__xonsh__.env.get('CONDA_PREFIX')

        if conda_prefix and conda_prefix.endswith(conda_project_dir_name):

            env_parent = os.path.dirname(conda_prefix)

            if env_parent in newdir:
                return
            else:
                conda deactivate

        venv_path = os.path.join(newdir, conda_project_dir_name)
        if os.path.isdir(venv_path):
            conda activate @(venv_path)

    def create(self, args, stdin=None):
        """
        A wrapper around `conda env create`, creating the environment in the
        current project directory. Will use an `env*.yaml` file to create the
        environment, if found.
        """
        conda_project_dir_name = self.get_dir_name()

        if not args:
            assumed_env_file = g`./env*.yaml`
            if assumed_env_file:
                ![
                    conda env create @(['--prefix', conda_project_dir_name,
                                        '--file', assumed_env_file[0]])
                ]
                return

        conda create @(['--prefix', conda_project_dir_name] + args)

        self.print('Auto activating...')
        self.switch()

    def export(self, args, stdin=None):
        """
        A wrapper around `conda env export`, exporting the environment found in
        the current project directory to `environment.yaml`.
        """
        conda_project_dir_name = self.get_dir_name()

        if os.path.isdir(os.path.join(os.getcwd(),
                                      conda_project_dir_name)):
            ![
                conda env export @(['--prefix', conda_project_dir_name,
                                    '--file', 'environment.yaml'] + args)
            ]
            self.print('Exported conda environment to environment.yaml')
        else:
            self.print(
                'Environment directory not found. '
                'Are you in the root of the project?'
            )

    def get_dir_name(self):
        return builtins.__xonsh__.env.get(
            'CONDA_PROJECT_DIR_NAME', 'conda-env'
        )

    def print(self, string):
        print(f'conda-project: {string}')


@events.on_post_init
def init():

    _conda_project = CondaProject()

    @events.on_chdir
    def cd_handler(olddir, newdir):
        _conda_project.switch(newdir)

    aliases['create-conda-project'] = _conda_project.create
    aliases['export-conda-project'] = _conda_project.export

    _conda_project.switch()
